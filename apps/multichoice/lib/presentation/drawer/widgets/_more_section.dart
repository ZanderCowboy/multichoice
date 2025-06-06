part of '../home_drawer.dart';

class _MoreSection extends StatelessWidget {
  const _MoreSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            'More',
            style: AppTypography.titleSmall.copyWith(
              color: Colors.white70,
              letterSpacing: 1.1,
            ),
          ),
        ),
        ListTile(
          title: const Text('Reset Tutorial'),
          trailing: IconButton(
            onPressed: () async {
              if (context.mounted) {
                Navigator.of(context).pop();
                coreSl<ProductBloc>().add(
                  const ProductEvent.resetTour(),
                );
              }
            },
            icon: const Icon(
              Icons.refresh_outlined,
            ),
          ),
        ),
      ],
    );
  }
}
