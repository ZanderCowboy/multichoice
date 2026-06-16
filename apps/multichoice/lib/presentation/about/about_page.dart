import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/generated/assets.gen.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/utils/about_feature.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    guardAboutPageRoute(context);
  }

  static const _sectionMaxWidth = 420.0;

  Future<String?> _getRemoteStringOrNull(FirebaseConfigKeys key) async {
    if (!coreSl.isRegistered<IFirebaseService>()) return null;
    final value = (await coreSl<IFirebaseService>().getString(key))?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  Widget _sectionCard({
    required BuildContext context,
    required Widget child,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.18,
        ),
        borderRadius: borderCircular16,
        border: Border.all(
          color: context.theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Padding(
        padding: allPadding12,
        child: child,
      ),
    );
  }

  Future<
    ({
      String? instagramUrl,
      String? websiteUrl,
      String? emailAddress,
      String? privacyPolicyUrl,
      String? termsUrl,
      String? acknowledgementsUrl,
    })
  >
  _loadRemoteConfig() async {
    final instagramUrl = await _getRemoteStringOrNull(
      FirebaseConfigKeys.aboutInstagramUrl,
    );
    final websiteUrl = await _getRemoteStringOrNull(
      FirebaseConfigKeys.aboutWebsiteUrl,
    );
    final emailAddress = await _getRemoteStringOrNull(
      FirebaseConfigKeys.aboutContactEmail,
    );
    final privacyPolicyUrl = await _getRemoteStringOrNull(
      FirebaseConfigKeys.aboutPrivacyPolicyUrl,
    );
    final termsUrl = await _getRemoteStringOrNull(
      FirebaseConfigKeys.aboutTermsUrl,
    );
    final acknowledgementsUrl = await _getRemoteStringOrNull(
      FirebaseConfigKeys.aboutAcknowledgementsUrl,
    );

    return (
      instagramUrl: instagramUrl,
      websiteUrl: websiteUrl,
      emailAddress: emailAddress,
      privacyPolicyUrl: privacyPolicyUrl,
      termsUrl: termsUrl,
      acknowledgementsUrl: acknowledgementsUrl,
    );
  }

  Future<void> _openExternalUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openEmail(BuildContext context, String emailAddress) async {
    final uri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: const <String, String>{
        'subject': 'Multichoice',
      },
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadRemoteConfig(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final instagramUrl = data?.instagramUrl;
        final websiteUrl = data?.websiteUrl;
        final emailAddress = data?.emailAddress;
        final privacyPolicyUrl = data?.privacyPolicyUrl;
        final termsUrl = data?.termsUrl;
        final acknowledgementsUrl = data?.acknowledgementsUrl;

        final hasSocial = instagramUrl != null || websiteUrl != null;
        final hasPolicies =
            privacyPolicyUrl != null ||
            termsUrl != null ||
            acknowledgementsUrl != null;
        final hasBottomSections = emailAddress != null || hasPolicies;

        return Scaffold(
          backgroundColor: context.theme.appColors.background,
          appBar: AppBar(
            title: Text(context.t.about.title),
            backgroundColor: context.theme.appColors.appBarBackground,
          ),
          body: SafeArea(
            child: Padding(
              padding: allPadding16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: borderCircular12,
                        child: Image.asset(
                          Assets.images.playstore.path,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      gap16,
                      Expanded(
                        child: Text(
                          context.t.about.appName,
                          style: context.appTextTheme.headingMedium,
                        ),
                      ),
                    ],
                  ),
                  gap20,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: _sectionMaxWidth,
                                ),
                                child:
                                    snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Center(child: CircularLoader.small())
                                    : (hasSocial
                                          ? _sectionCard(
                                              context: context,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.share_outlined,
                                                      ),
                                                      gap10,
                                                      Text(
                                                        context
                                                            .t
                                                            .about
                                                            .socialTitle,
                                                        style: context
                                                            .appTextTheme
                                                            .titleMedium,
                                                      ),
                                                    ],
                                                  ),
                                                  gap12,
                                                  if (instagramUrl != null) ...[
                                                    FilledButton.icon(
                                                      onPressed: () =>
                                                          _openExternalUrl(
                                                            context,
                                                            instagramUrl,
                                                          ),
                                                      icon: const Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                      ),
                                                      label: Text(
                                                        context
                                                            .t
                                                            .about
                                                            .instagram,
                                                      ),
                                                    ),
                                                    if (websiteUrl != null)
                                                      gap10,
                                                  ],
                                                  if (websiteUrl != null)
                                                    FilledButton.icon(
                                                      onPressed: () =>
                                                          _openExternalUrl(
                                                            context,
                                                            websiteUrl,
                                                          ),
                                                      icon: const Icon(
                                                        Icons.public,
                                                      ),
                                                      label: Text(
                                                        context.t.about.website,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink()),
                              ),
                            ),
                          ),
                        ),
                        if (hasBottomSections) gap16,
                        if (hasBottomSections)
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _sectionMaxWidth,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (emailAddress != null)
                                  _sectionCard(
                                    context: context,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.email_outlined),
                                            gap10,
                                            Text(
                                              context.t.about.contactTitle,
                                              style: context
                                                  .appTextTheme
                                                  .titleMedium,
                                            ),
                                          ],
                                        ),
                                        gap8,
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: const Icon(
                                            Icons.alternate_email,
                                          ),
                                          title: Text(
                                            emailAddress,
                                            style:
                                                context.appTextTheme.bodyMedium,
                                          ),
                                          onTap: () => _openEmail(
                                            context,
                                            emailAddress,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (emailAddress != null && hasPolicies) gap12,
                                if (hasPolicies)
                                  _sectionCard(
                                    context: context,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.policy_outlined),
                                            gap10,
                                            Expanded(
                                              child: Text(
                                                context
                                                    .t
                                                    .about
                                                    .policiesAndAcknowledgements,
                                                style: context
                                                    .appTextTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                        gap8,
                                        if (privacyPolicyUrl != null)
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(
                                              Icons.privacy_tip_outlined,
                                            ),
                                            title: Text(
                                              context.t.about.privacyPolicy,
                                            ),
                                            onTap: () => _openExternalUrl(
                                              context,
                                              privacyPolicyUrl,
                                            ),
                                          ),
                                        if (termsUrl != null)
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(
                                              Icons.description_outlined,
                                            ),
                                            title: Text(context.t.about.terms),
                                            onTap: () => _openExternalUrl(
                                              context,
                                              termsUrl,
                                            ),
                                          ),
                                        if (acknowledgementsUrl != null)
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(
                                              Icons.favorite_outline,
                                            ),
                                            title: Text(
                                              context.t.about.acknowledgements,
                                            ),
                                            onTap: () => _openExternalUrl(
                                              context,
                                              acknowledgementsUrl,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
