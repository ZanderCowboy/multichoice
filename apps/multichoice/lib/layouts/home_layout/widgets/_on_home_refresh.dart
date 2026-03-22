part of '../home_layout.dart';

Future<void> _onHomeRefresh(BuildContext context) async {
  final bloc = context.read<HomeBloc>()..add(const HomeEvent.refresh());

  try {
    await bloc.stream
        .firstWhere((state) => !state.isLoading)
        .timeout(const Duration(seconds: 5));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Refreshed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.theme.appColors.textTertiary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              gap8,
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: Icon(
                  Icons.close,
                  color: context.theme.appColors.textTertiary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  } on TimeoutException {
    // Refresh took too long; actual errors are handled by the error listener
  }
}
