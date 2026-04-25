import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/presentation/registration/login_modal.dart';
import 'package:provider/provider.dart';

Future<bool> _homeSessionIsLoggedIn() async {
  if (!coreSl.isRegistered<ILoginService>()) return false;
  return coreSl<ILoginService>().isUserLoggedIn();
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, auth, _) {
        return FutureBuilder<bool>(
          key: ValueKey<int>(auth.authEpoch),
          future: _homeSessionIsLoggedIn(),
          builder: (context, snapshot) {
            final isLoggedIn = snapshot.data ?? false;

            return isLoggedIn
                ? IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () async {
                      await context.router.push(
                        const ProfilePageRoute(),
                      );
                    },
                    tooltip: 'Profile',
                    icon: const Icon(Icons.person_outline),
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.zero,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 28,
                    width: 60,
                    child: TextButton(
                      onPressed: () => showLoginModal(context),
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.zero,
                        ),
                      ),
                      child: const Text('Log in'),
                    ),
                  );
          },
        );
      },
    );
  }
}
