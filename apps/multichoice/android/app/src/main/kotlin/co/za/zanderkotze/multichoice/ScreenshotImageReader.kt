package co.za.zanderkotze.multichoice

import android.content.ClipData
import android.content.ClipboardManager
import android.content.ContentUris
import android.content.Context
import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.concurrent.Executors

object ScreenshotImageReader {
    private const val TAG = "ScreenshotImageReader"
    private const val CHANNEL = "co.za.zanderkotze.multichoice/screenshot_image"
    private const val RECENT_SCREENSHOT_MAX_AGE_SECONDS = 180L

    private val mainHandler = Handler(Looper.getMainLooper())

    fun registerWith(
        messenger: BinaryMessenger,
        contextProvider: () -> Context,
    ) {
        val channel = MethodChannel(messenger, CHANNEL)
        val executor = Executors.newSingleThreadExecutor()
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "readImageBytes" -> executor.execute {
                    try {
                        val payload = readImageBytes(contextProvider())
                        mainHandler.post { result.success(payload) }
                    } catch (e: Exception) {
                        logWarning("readImageBytes failed", e)
                        mainHandler.post {
                            result.error("READ_FAILED", e.message, null)
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun readImageBytes(context: Context): List<Any?>? {
        readFromClipboard(context)?.let { return it }

        logDebug("Clipboard empty or unreadable; trying recent screenshot from MediaStore")
        return readRecentScreenshot(context)
    }

    private fun readFromClipboard(context: Context): List<Any?>? {
        val manager =
            context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = manager.primaryClip
        if (clip == null || clip.itemCount == 0) {
            logDebug("No primary clip (hasPrimaryClip=${manager.hasPrimaryClip()})")
            return null
        }

        logClipDescription(clip)

        val resolver = context.contentResolver
        for (i in 0 until clip.itemCount) {
            val item = clip.getItemAt(i)
            for (uri in urisFromItem(item, context)) {
                logDebug("Trying clipboard URI: $uri")
                readImageFromUri(resolver, uri)?.let { (bytes, extension) ->
                    return listOf(bytes, extension)
                }
            }
        }

        logDebug("No image bytes resolved from clipboard")
        return null
    }

    private fun readRecentScreenshot(context: Context): List<Any?>? {
        val resolver = context.contentResolver
        val collection =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)
            } else {
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            }

        val cutoffSeconds =
            (System.currentTimeMillis() / 1000) - RECENT_SCREENSHOT_MAX_AGE_SECONDS
        val projection =
            arrayOf(
                MediaStore.Images.Media._ID,
                MediaStore.Images.Media.DISPLAY_NAME,
            )

        val selection =
            "${MediaStore.Images.Media.DATE_ADDED} >= ? AND (" +
                "${MediaStore.Images.Media.DISPLAY_NAME} LIKE ? OR " +
                "${MediaStore.Images.Media.RELATIVE_PATH} LIKE ? OR " +
                "${MediaStore.Images.Media.RELATIVE_PATH} LIKE ?)"
        val selectionArgs =
            arrayOf(
                cutoffSeconds.toString(),
                "%Screenshot%",
                "%Screenshots%",
                "%screenshot%",
            )
        val sortOrder = "${MediaStore.Images.Media.DATE_ADDED} DESC"

        resolver.query(collection, projection, selection, selectionArgs, sortOrder)?.use { cursor ->
            if (!cursor.moveToFirst()) {
                logDebug("No recent screenshot found in MediaStore")
                return null
            }

            val idColumn = cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID)
            val nameColumn = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DISPLAY_NAME)
            val id = cursor.getLong(idColumn)
            val name = cursor.getString(nameColumn)
            val uri = ContentUris.withAppendedId(collection, id)

            logDebug("Using recent screenshot from MediaStore: $name ($uri)")
            readImageFromUri(resolver, uri)?.let { (bytes, extension) ->
                return listOf(bytes, extension)
            }
        }

        logDebug("Recent screenshot query returned no readable image")
        return null
    }

    private fun logClipDescription(clip: ClipData) {
        val description = clip.description
        val mimeTypes = buildList {
            for (i in 0 until description.mimeTypeCount) {
                add(description.getMimeType(i))
            }
        }
        logDebug(
            "Clip items=${clip.itemCount} mimeTypes=$mimeTypes label=${description.label}",
        )
    }

    private fun urisFromItem(item: ClipData.Item, context: Context): List<Uri> {
        val uris = linkedSetOf<Uri>()
        item.uri?.let { uris.add(it) }
        item.intent?.data?.let { uris.add(it) }
        parseUriFromText(item.text?.toString())?.let { uris.add(it) }
        parseUriFromText(item.coerceToText(context)?.toString())?.let { uris.add(it) }
        parseUriFromText(item.htmlText)?.let { uris.add(it) }
        item.htmlText?.let { html ->
            URI_PATTERN.findAll(html).forEach { match ->
                parseUriFromText(match.value)?.let { uris.add(it) }
            }
        }
        return uris.toList()
    }

    private fun parseUriFromText(text: String?): Uri? {
        if (text.isNullOrBlank()) return null
        val trimmed = text.trim()
        val match = URI_PATTERN.find(trimmed)?.value ?: trimmed
        return if (match.startsWith("content://") || match.startsWith("file://")) {
            Uri.parse(match)
        } else {
            null
        }
    }

    private fun readImageFromUri(
        resolver: android.content.ContentResolver,
        uri: Uri,
    ): Pair<ByteArray, String>? {
        readRawBytes(resolver, uri)?.let { bytes ->
            if (bytes.isNotEmpty()) {
                val extension =
                    extensionFromBytes(bytes)
                        ?: extensionFromMime(resolver.getType(uri))
                        ?: "png"
                return bytes to extension
            }
        }

        decodeWithImageDecoder(resolver, uri)?.let { return it }
        decodeWithThumbnail(resolver, uri)?.let { return it }
        readFileUri(uri)?.let { return it }

        logDebug("Failed to read image from URI=$uri type=${resolver.getType(uri)}")
        return null
    }

    private fun readRawBytes(
        resolver: android.content.ContentResolver,
        uri: Uri,
    ): ByteArray? {
        try {
            resolver.openInputStream(uri)?.use { return it.readBytes() }
        } catch (e: Exception) {
            logDebug("openInputStream failed for $uri: ${e.message}")
        }

        try {
            resolver.openAssetFileDescriptor(uri, "r")?.use { descriptor ->
                descriptor.createInputStream()?.use { return it.readBytes() }
            }
        } catch (e: Exception) {
            logDebug("openAssetFileDescriptor failed for $uri: ${e.message}")
        }

        val mime = resolver.getType(uri)
        if (mime != null && mime.startsWith("image/")) {
            try {
                resolver.openTypedAssetFileDescriptor(uri, mime, null)?.use { descriptor ->
                    descriptor.createInputStream()?.use { return it.readBytes() }
                }
            } catch (e: Exception) {
                logDebug("openTypedAssetFileDescriptor($mime) failed: ${e.message}")
            }
            try {
                resolver.openTypedAssetFileDescriptor(uri, "image/*", null)?.use { descriptor ->
                    descriptor.createInputStream()?.use { return it.readBytes() }
                }
            } catch (e: Exception) {
                logDebug("openTypedAssetFileDescriptor(image/*) failed: ${e.message}")
            }
        }

        return null
    }

    private fun decodeWithImageDecoder(
        resolver: android.content.ContentResolver,
        uri: Uri,
    ): Pair<ByteArray, String>? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) return null

        return try {
            val source = ImageDecoder.createSource(resolver, uri)
            val bitmap = ImageDecoder.decodeBitmap(source)
            bitmapToPng(bitmap)
        } catch (e: Exception) {
            logDebug("ImageDecoder failed for $uri: ${e.message}")
            null
        }
    }

    private fun decodeWithThumbnail(
        resolver: android.content.ContentResolver,
        uri: Uri,
    ): Pair<ByteArray, String>? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return null

        return try {
            val bitmap = resolver.loadThumbnail(uri, Size(2048, 2048), null)
            bitmapToPng(bitmap)
        } catch (e: Exception) {
            logDebug("loadThumbnail failed for $uri: ${e.message}")
            null
        }
    }

    private fun bitmapToPng(bitmap: Bitmap): Pair<ByteArray, String> {
        return try {
            val output = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)
            output.toByteArray() to "png"
        } finally {
            bitmap.recycle()
        }
    }

    private fun readFileUri(uri: Uri): Pair<ByteArray, String>? {
        if (uri.scheme != "file") return null
        val path = uri.path ?: return null
        val file = File(path)
        if (!file.exists() || !file.isFile) return null

        return try {
            val bytes = file.readBytes()
            if (bytes.isEmpty()) return null
            val extension = extensionFromBytes(bytes) ?: "png"
            bytes to extension
        } catch (e: Exception) {
            logDebug("readFileUri failed for $uri: ${e.message}")
            null
        }
    }

    private fun extensionFromMime(mime: String?): String? {
        return when (mime?.substringBefore(';')?.trim()?.lowercase()) {
            "image/png" -> "png"
            "image/jpeg", "image/jpg" -> "jpg"
            "image/webp" -> "webp"
            "image/gif" -> "gif"
            else -> null
        }
    }

    private fun extensionFromBytes(bytes: ByteArray): String? {
        if (bytes.size < 3) return null
        return when {
            bytes.size >= 8 &&
                bytes[0] == 0x89.toByte() &&
                bytes[1] == 0x50.toByte() &&
                bytes[2] == 0x4E.toByte() &&
                bytes[3] == 0x47.toByte() -> "png"

            bytes.size >= 3 &&
                bytes[0] == 0xFF.toByte() &&
                bytes[1] == 0xD8.toByte() &&
                bytes[2] == 0xFF.toByte() -> "jpg"

            bytes.size >= 12 &&
                bytes[0] == 0x52.toByte() &&
                bytes[1] == 0x49.toByte() &&
                bytes[2] == 0x46.toByte() &&
                bytes[3] == 0x46.toByte() &&
                bytes[8] == 0x57.toByte() &&
                bytes[9] == 0x45.toByte() &&
                bytes[10] == 0x42.toByte() &&
                bytes[11] == 0x50.toByte() -> "webp"

            bytes.size >= 6 &&
                bytes[0] == 0x47.toByte() &&
                bytes[1] == 0x49.toByte() &&
                bytes[2] == 0x46.toByte() &&
                bytes[3] == 0x38.toByte() -> "gif"

            else -> null
        }
    }

    private fun logDebug(message: String) {
        if (Log.isLoggable(TAG, Log.DEBUG)) {
            Log.d(TAG, message)
        }
    }

    private fun logWarning(message: String, error: Throwable? = null) {
        if (!Log.isLoggable(TAG, Log.WARN)) return

        if (error != null) {
            Log.w(TAG, message, error)
        } else {
            Log.w(TAG, message)
        }
    }

    private val URI_PATTERN =
        Regex("""(?:content|file)://[^\s"'<>]+""")
}
