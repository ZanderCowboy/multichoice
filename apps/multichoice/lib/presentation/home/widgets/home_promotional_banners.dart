import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/home/widgets/import_data_banner.dart';
import 'package:multichoice/presentation/home/widgets/signup_banner.dart';
import 'package:provider/provider.dart';
import 'package:ui_kit/ui_kit.dart';

/// Hosts import + sign-up home banners in a [BannerCarousel] when applicable.
///
/// Each banner has its own dismissal flag in storage. When only one is
/// visible, the carousel shows a single page (no auto-advance or dots).
class HomePromotionalBanners extends StatefulWidget {
  const HomePromotionalBanners({super.key});

  @override
  State<HomePromotionalBanners> createState() => _HomePromotionalBannersState();
}

class _HomePromotionalBannersState extends State<HomePromotionalBanners> {
  bool? _importDismissed;
  bool? _signupDismissed;
  bool _loggedIn = false;
  int _lastAuthEpoch = -1;
  int _lastStorageClearEpoch = 0;
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authNotifier = context.read<AuthNotifier>();
    _authNotifier.addListener(_onAuthNotifierChanged);
    unawaited(_loadDismissalFromStorage());
  }

  @override
  void dispose() {
    _authNotifier.removeListener(_onAuthNotifierChanged);
    super.dispose();
  }

  void _onAuthNotifierChanged() {
    if (_authNotifier.storageClearEpoch <= _lastStorageClearEpoch) return;
    _lastStorageClearEpoch = _authNotifier.storageClearEpoch;
    unawaited(_loadDismissalFromStorage());
  }

  Future<void> _loadDismissalFromStorage() async {
    final storage = coreSl<IAppStorageService>();
    final import = await storage.isImportDataBannerDismissed;
    final signup = await storage.isSignupBannerDismissed;
    if (!mounted) return;
    setState(() {
      _importDismissed = import;
      _signupDismissed = signup;
    });
  }

  Future<void> _refreshLoggedIn(AuthNotifier auth) async {
    if (auth.authEpoch == _lastAuthEpoch) return;
    _lastAuthEpoch = auth.authEpoch;
    final loggedIn = await auth.isUserLoggedIn;
    if (!mounted) return;
    setState(() => _loggedIn = loggedIn);
  }

  Future<void> _onDismissImport() async {
    await coreSl<IAppStorageService>().setIsImportDataBannerDismissed(true);
    await coreSl<IAnalyticsService>().logEvent(
      const UiActionEventData(
        page: AnalyticsPage.home,
        button: AnalyticsButton.dismissBanner,
        action: AnalyticsAction.close,
      ),
    );
    if (!mounted) return;
    setState(() => _importDismissed = true);
  }

  Future<void> _onDismissSignup() async {
    await coreSl<IAppStorageService>().setIsSignupBannerDismissed(true);
    await coreSl<IAnalyticsService>().logEvent(
      const UiActionEventData(
        page: AnalyticsPage.home,
        button: AnalyticsButton.dismissBanner,
        action: AnalyticsAction.close,
      ),
    );
    if (!mounted) return;
    setState(() => _signupDismissed = true);
  }

  Future<void> _onImportTap(BuildContext context) async {
    await coreSl<IAnalyticsService>().logEvent(
      const UiActionEventData(
        page: AnalyticsPage.home,
        button: AnalyticsButton.importData,
        action: AnalyticsAction.open,
      ),
    );
    if (!context.mounted) return;

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

  Future<void> _onSignUpTap(BuildContext context) async {
    await coreSl<IAnalyticsService>().logEvent(
      const UiActionEventData(
        page: AnalyticsPage.home,
        button: AnalyticsButton.signUp,
        action: AnalyticsAction.open,
      ),
    );
    if (!context.mounted) return;
    final auth = context.read<AuthNotifier>();
    await context.router.push(const SignupPageRoute());
    if (!mounted) return;
    final loggedIn = await auth.isUserLoggedIn;
    if (!mounted) return;
    if (loggedIn) {
      await coreSl<IAppStorageService>().setIsSignupBannerDismissed(true);
      if (!mounted) return;
      setState(() => _signupDismissed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageReady = _importDismissed != null && _signupDismissed != null;
    if (!storageReady) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.tabs != current.tabs ||
          previous.isLoading != current.isLoading,
      builder: (context, homeState) {
        return Consumer<AuthNotifier>(
          builder: (context, auth, _) {
            unawaited(_refreshLoggedIn(auth));

            final tabs = homeState.tabs ?? [];
            final showImport =
                !_importDismissed! && tabs.isEmpty && !homeState.isLoading;
            final showSignup = !_signupDismissed! && !_loggedIn;

            final usePillStyle = coreSl<IFirebaseService>().isEnabled(
              FirebaseConfigKeys.usePillStyleBanner,
            );

            final pages = <Widget>[
              if (showImport)
                ImportDataBannerPage(
                  key: const ValueKey<Object>('home_promo_import'),
                  usePillStyle: usePillStyle,
                  onImportTap: () => unawaited(_onImportTap(context)),
                  onDismiss: _onDismissImport,
                ),
              if (showSignup)
                SignupBannerPage(
                  key: const ValueKey<Object>('home_promo_signup'),
                  usePillStyle: usePillStyle,
                  onSignUpTap: () => unawaited(_onSignUpTap(context)),
                  onDismiss: _onDismissSignup,
                ),
            ];

            if (pages.isEmpty) {
              return const SizedBox.shrink();
            }

            // New carousel state when the set of visible banners changes so
            // [PageView] and DevTools layout explorer do not keep stale pages.
            return BannerCarousel(
              key: ValueKey<String>(
                '${showImport}_$showSignup',
              ),
              height: 100,
              children: pages,
            );
          },
        );
      },
    );
  }
}
