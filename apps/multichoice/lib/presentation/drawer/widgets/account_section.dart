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
            'Account',
            style: context.appTextTheme.titleSmall?.copyWith(
              color: Colors.white70,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Profile'),
          onTap: () async {
            Navigator.of(context).pop();
            unawaited(context.router.push(const ProfilePageRoute()));
          },
        ),
      ],
    );
  }
}
