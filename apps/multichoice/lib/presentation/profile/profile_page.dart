import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/shared/widgets/shine_card.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    guardUserAccountsRoute(context);
  }

  String _display(String? value) =>
      (value != null && value.isNotEmpty) ? value : '—';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<ProfileBloc>()..add(const ProfileLoadStarted()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.isLoggedOut) {
            context.read<AuthNotifier>().notifyAuthChanged();
            context.router.popUntilRoot();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.t.auth.signedOutSuccess),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.t.profile.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                if (!context.mounted) return;
                context.router.pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: allPadding16,
              child: ShineCard(
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state.isLoading;
                    final email = state.email;
                    final username = state.username;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isLoading)
                          const Center(
                            child: Padding(
                              padding: allPadding24,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else ...[
                          ListTile(
                            leading: const Icon(Icons.email_outlined),
                            title: Text(context.t.profile.email),
                            subtitle: Text(_display(email)),
                            tileColor: context.theme.appColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: borderCircular12,
                            ),
                          ),
                          gap12,
                          ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(context.t.profile.username),
                            subtitle: Text(_display(username)),
                            tileColor: context.theme.appColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: borderCircular12,
                            ),
                          ),
                          gap12,
                          ListTile(
                            leading: const Icon(Icons.lock_outline),
                            title: Text(
                              state.hasPasswordProvider
                                  ? context.t.profile.updatePassword
                                  : context.t.profile.setPassword,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              await context.router.push(
                                ResetPasswordPageRoute(
                                  isChangePassword: true,
                                  isSetPassword: !state.hasPasswordProvider,
                                ),
                              );
                              if (context.mounted) {
                                context.read<ProfileBloc>().add(
                                  const ProfileLoadStarted(),
                                );
                              }
                            },
                            tileColor: context.theme.appColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: borderCircular12,
                            ),
                          ),
                          gap12,
                          ListTile(
                            leading: Icon(
                              Icons.delete_outline,
                              color: context.appColorsTheme.error,
                            ),
                            title: Text(
                              context.t.profile.deleteAccount,
                              style: TextStyle(
                                color: context.appColorsTheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              await context.router.push(
                                const AccountDeletionPageRoute(),
                              );
                              if (context.mounted) {
                                context.read<ProfileBloc>().add(
                                  const ProfileLoadStarted(),
                                );
                              }
                            },
                            tileColor: context.theme.appColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: borderCircular12,
                            ),
                          ),
                          gap24,
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<ProfileBloc>().add(
                                const ProfileLogoutRequested(),
                              );
                            },
                            icon: const Icon(Icons.logout_outlined),
                            label: Text(context.t.auth.logout),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
