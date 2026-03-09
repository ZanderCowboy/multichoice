import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:ui_kit/ui_kit.dart';

/// A dismissable banner that prompts users to import data when they have
/// no collections. Shows between the app bar and content on the home page.
class ImportDataBanner extends StatefulWidget {
  const ImportDataBanner({super.key});

  @override
  State<ImportDataBanner> createState() => _ImportDataBannerState();
}

class _ImportDataBannerState extends State<ImportDataBanner> {
  bool _isDismissed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDismissalState());
  }

  Future<void> _loadDismissalState() async {
    final isDismissed =
        await coreSl<IAppStorageService>().isImportDataBannerDismissed;
    if (mounted) {
      setState(() {
        _isDismissed = isDismissed;
        _isLoading = false;
      });
    }
  }

  Future<void> _dismissBanner() async {
    await coreSl<IAppStorageService>().setIsImportDataBannerDismissed(true);
    await coreSl<IAnalyticsService>().logEvent(
      const UiActionEventData(
        page: AnalyticsPage.home,
        button: AnalyticsButton.dismissBanner,
        action: AnalyticsAction.close,
      ),
    );
    if (mounted) {
      setState(() {
        _isDismissed = true;
      });
    }
  }

  Future<void> _handleImportTap() async {
    await coreSl<IAnalyticsService>().logEvent(
      const UiActionEventData(
        page: AnalyticsPage.home,
        button: AnalyticsButton.importData,
        action: AnalyticsAction.open,
      ),
    );
    if (!mounted) return;

    await context.router.push(
      DataTransferScreenRoute(
        onCallback: () {
          context.read<HomeBloc>().add(
            const HomeEvent.onGetTabs(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeBloc>().state;
    final tabs = state.tabs ?? [];

    // Don't show banner if:
    // - Still loading dismissal state
    // - Already dismissed
    // - There are tabs
    // - Data is still loading
    if (_isLoading || _isDismissed || tabs.isNotEmpty || state.isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryLight?.withValues(alpha: 0.15),
        border: Border(
          bottom: BorderSide(
            color:
                context.theme.appColors.primaryLight?.withValues(alpha: 0.3) ??
                Colors.transparent,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.theme.appColors.primary,
            size: 20,
          ),
          gap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No collections yet',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.appColors.foreground,
                  ),
                ),
                gap4,
                GestureDetector(
                  onTap: _handleImportTap,
                  child: Text(
                    'Import data or create a new collection',
                    style: AppTypography.bodySmall.copyWith(
                      color: context.theme.appColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          gap8,
          IconButton(
            icon: Icon(
              Icons.close,
              color: context.theme.appColors.foreground?.withValues(alpha: 0.7),
              size: 20,
            ),
            onPressed: _dismissBanner,
            tooltip: 'Dismiss',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
