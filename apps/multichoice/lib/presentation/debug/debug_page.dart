import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/presentation/debug/widgets/export.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(child: Text('Not available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: const _DebugBody(),
    );
  }
}

class _DebugBody extends StatefulWidget {
  const _DebugBody();

  @override
  State<_DebugBody> createState() => _DebugBodyState();
}

class _DebugBodyState extends State<_DebugBody> {
  DebugView _selectedView = DebugView.debugTools;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: allPadding16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Debug only – accessible via double-tap or long-press on version',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            gap12,
            DebugOptionSelector(
              selectedView: _selectedView,
              onSelect: (view) => setState(() => _selectedView = view),
            ),
            gap16,
            Expanded(
              child: switch (_selectedView) {
                DebugView.debugTools => DebugToolsContent(
                  onClearStorage: _clearStorageData,
                ),
                DebugView.appColors => const AppColorsContent(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearStorageData(BuildContext context) async {
    if (!kDebugMode) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Storage Data'),
        content: const Text(
          'Are you sure you want to clear all storage data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await coreSl<IAppStorageService>().clearAllData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage data cleared successfully')),
        );
      }
    }
  }
}
