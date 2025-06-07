part of 'export.dart';

class DataSection extends StatelessWidget {
  const DataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            'Data',
            style: AppTypography.titleSmall.copyWith(
              color: Colors.white70,
              letterSpacing: 1.1,
            ),
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return ListTile(
              title: const Text('Delete All Data'),
              trailing: IconButton(
                key: context.keys.deleteAllDataButton,
                onPressed: state.tabs != null && state.tabs!.isNotEmpty
                    ? () {
                        CustomDialog<AlertDialog>.show(
                          context: context,
                          title: const Text(
                            'Delete all tabs and entries?',
                          ),
                          content: const Text(
                            'Are you sure you want to delete all tabs and their entries?',
                          ),
                          actions: [
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('No, cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<HomeBloc>().add(
                                      const HomeEvent.onPressedDeleteAll(),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes, delete'),
                            ),
                          ],
                        );
                      }
                    : null,
                tooltip: TooltipEnums.deleteAllData.tooltip,
                icon: state.tabs == null || state.tabs!.isEmpty
                    ? Icon(
                        Icons.delete_sweep_outlined,
                        color: context.theme.appColors.disabled,
                      )
                    : Icon(
                        Icons.delete_sweep_rounded,
                        color: context.theme.appColors.enabled,
                      ),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Import / Export Data'),
          trailing: IconButton(
            key: context.keys.importExportDataButton,
            onPressed: () => context.router.push(
              DataTransferScreenRoute(
                onCallback: () {
                  context.read<HomeBloc>().add(
                        const HomeEvent.onGetTabs(),
                      );
                },
              ),
            ),
            tooltip: TooltipEnums.importExport.tooltip,
            icon: const Icon(
              Icons.import_export_outlined,
            ),
          ),
        ),
      ],
    );
  }
}
