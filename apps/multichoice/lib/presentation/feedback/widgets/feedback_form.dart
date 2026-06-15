import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/extensions/extension_getters.dart';
import 'package:multichoice/app/view/debug/remote_config_debug_notifier.dart';
import 'package:multichoice/app/view/theme/extensions/app_theme_extension.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:ui_kit/ui_kit.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeedbackFormBody();
  }
}

class _FeedbackFormBody extends StatefulWidget {
  const _FeedbackFormBody();

  @override
  State<_FeedbackFormBody> createState() => _FeedbackFormBodyState();
}

class _FeedbackFormBodyState extends State<_FeedbackFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  bool _hasTypedEmail = false;
  int _formVersion = 0;

  List<String> _categories(BuildContext context) => [
    context.t.feedback.categories.bugReport,
    context.t.feedback.categories.featureRequest,
    context.t.feedback.categories.generalFeedback,
    context.t.feedback.categories.uiUx,
    context.t.feedback.categories.performance,
  ];

  String? _messageHintForCategory(BuildContext context, String? category) {
    if (category == null) return null;

    final categories = context.t.feedback.categories;
    final hints = context.t.feedback.messageHints;

    if (category == categories.bugReport) return hints.bugReport;
    if (category == categories.featureRequest) return hints.featureRequest;
    if (category == categories.generalFeedback) return hints.generalFeedback;
    if (category == categories.uiUx) return hints.uiUx;
    if (category == categories.performance) return hints.performance;

    return null;
  }

  String? _validateOptionalEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_emailRegex.hasMatch(trimmed)) {
      return context.t.feedback.invalidEmail;
    }
    return null;
  }

  void _resetFormFields() {
    _messageController.clear();
    _emailController.clear();
    _formKey.currentState?.reset();
    setState(() {
      _hasTypedEmail = false;
      _formVersion++;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final feedbackState = context.read<FeedbackBloc>().state.feedback;
    final appVersion = await coreSl<IAppInfoService>().getAppVersion();

    final feedbackDTO = FeedbackDTO(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: _messageController.text,
      userEmail: _emailController.text,
      rating: feedbackState.rating,
      deviceInfo:
          '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      appVersion: appVersion,
      timestamp: DateTime.now().toLocal(),
      category: feedbackState.category,
    );

    // ignore: use_build_context_synchronously
    context.read<FeedbackBloc>().add(FeedbackEvent.submit(feedbackDTO));
  }

  Future<void> _pickImage(BuildContext context) async {
    final result = await coreSl<FilePicker>().pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      if (context.mounted) {
        for (final file in result.files) {
          context.read<FeedbackBloc>().add(FeedbackEvent.imageAdded(file));
        }
      }
    }
  }

  void _showNoImageInClipboardSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t.feedback.noImageInClipboard)),
    );
  }

  Future<void> _pasteImageFromClipboard(BuildContext context) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      if (context.mounted) {
        _showNoImageInClipboardSnackBar(context);
      }
      return;
    }

    final reader = await clipboard.read();

    final FileFormat? format;
    final String extension;
    if (reader.canProvide(Formats.png)) {
      format = Formats.png;
      extension = 'png';
    } else if (reader.canProvide(Formats.jpeg)) {
      format = Formats.jpeg;
      extension = 'jpg';
    } else {
      if (context.mounted) {
        _showNoImageInClipboardSnackBar(context);
      }
      return;
    }

    final completer = Completer<void>();
    final progress = reader.getFile(format, (file) async {
      try {
        final bytes = await file.readAll();
        if (!context.mounted) return;
        context.read<FeedbackBloc>().add(
          FeedbackEvent.imageAdded(
            PlatformFile(
              name:
                  'screenshot_${DateTime.now().millisecondsSinceEpoch}.$extension',
              size: bytes.length,
              bytes: bytes,
            ),
          ),
        );
        if (!completer.isCompleted) {
          completer.complete();
        }
      } on Object {
        if (!completer.isCompleted) {
          completer.completeError(Object());
        }
      }
    });

    if (progress == null) {
      if (context.mounted) {
        _showNoImageInClipboardSnackBar(context);
      }
      return;
    }

    try {
      await completer.future;
    } on Object {
      if (context.mounted) {
        _showNoImageInClipboardSnackBar(context);
      }
    }
  }

  Widget _buildImageThumbnails(BuildContext context, FeedbackState state) {
    if (state.imageFiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gap16,
        Text(context.t.feedback.attachedImages),
        gap8,
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.imageFiles.length,
            separatorBuilder: (_, _) => gap8,
            itemBuilder: (context, index) {
              final file = state.imageFiles[index];
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: file.bytes != null
                        ? Image.memory(file.bytes!, fit: BoxFit.cover)
                        : file.path != null
                        ? Image.file(File(file.path!), fit: BoxFit.cover)
                        : const Icon(Icons.image),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context.read<FeedbackBloc>().add(
                            FeedbackEvent.imageRemoved(index),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<RemoteConfigDebugNotifier>();
    return BlocListener<FeedbackBloc, FeedbackState>(
      listenWhen: (previous, current) =>
          !previous.isSuccess && current.isSuccess,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _resetFormFields();
          context.read<FeedbackBloc>().add(const FeedbackEvent.reset());
        });
      },
      child: BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: allPadding16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    key: ValueKey(_formVersion),
                    initialValue: state.feedback.category,
                    decoration: InputDecoration(
                      labelText: context.t.feedback.categoryLabelRequired,
                      border: const OutlineInputBorder(),
                    ),
                    items: _categories(context).map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      context.read<FeedbackBloc>().add(
                        FeedbackEvent.fieldChanged(
                          field: FeedbackField.category,
                          value: value,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.t.feedback.selectCategory;
                      }
                      return null;
                    },
                  ),
                  gap16,
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.t.feedback.emailLabel,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: _hasTypedEmail
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    onChanged: (value) {
                      if (!_hasTypedEmail && value.trim().isNotEmpty) {
                        setState(() {
                          _hasTypedEmail = true;
                        });
                      }
                      context.read<FeedbackBloc>().add(
                        FeedbackEvent.fieldChanged(
                          field: FeedbackField.email,
                          value: value,
                        ),
                      );
                    },
                    validator: _validateOptionalEmail,
                  ),
                  gap16,
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: context.t.feedback.messageLabelRequired,
                      hintText: _messageHintForCategory(
                        context,
                        state.feedback.category,
                      ),
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    textAlignVertical: TextAlignVertical.top,
                    onChanged: (value) {
                      context.read<FeedbackBloc>().add(
                        FeedbackEvent.fieldChanged(
                          field: FeedbackField.message,
                          value: value,
                        ),
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.t.feedback.enterFeedback;
                      }
                      return null;
                    },
                  ),
                  gap16,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.t.feedback.ratingLabel,
                      style: context.theme.appTextTheme.bodyLarge?.copyWith(
                        color: context.theme.appColors.textPrimary,
                      ),
                    ),
                  ),
                  gap8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < state.feedback.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: index < state.feedback.rating
                              ? Colors.amber
                              : Colors.grey,
                          size: 32,
                        ),
                        onPressed: () {
                          context.read<FeedbackBloc>().add(
                            FeedbackEvent.fieldChanged(
                              field: FeedbackField.rating,
                              value: index + 1,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  gap16,
                  if (coreSl<IFirebaseService>().isEnabled(
                    FirebaseConfigKeys.feedbackImagesEnabled,
                  )) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(context),
                            icon: const Icon(Icons.image),
                            label: Text(context.t.feedback.addImages),
                          ),
                        ),
                        gap8,
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pasteImageFromClipboard(context),
                            icon: const Icon(Icons.content_paste),
                            label: Text(context.t.feedback.pasteScreenshot),
                          ),
                        ),
                      ],
                    ),
                    _buildImageThumbnails(context, state),
                    gap24,
                  ] else ...[
                    gap24,
                  ],
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () => _submitFeedback(context),
                    child: state.isLoading
                        ? CircularLoader.small()
                        : Text(context.t.feedback.submitFeedback),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
