part of 'export.dart';

/// Account shortcuts when the user is signed in (under Settings drawer).
class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            context.t.drawer.account,
            style: context.appTextTheme.titleSmall?.copyWith(
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(
            context.t.profile.title,
            style: context.appTextTheme.denseTitle,
          ),
          onTap: () async {
            unawaited(context.router.push(const ProfilePageRoute()));
          },
        ),
      ],
    );
  }
}
