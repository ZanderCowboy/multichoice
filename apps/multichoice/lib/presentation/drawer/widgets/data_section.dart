// ignore_for_file: use_build_context_synchronously

part of 'export.dart';

class DataSection extends StatelessWidget {
  const DataSection({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> openDataTransfer() async {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: horizontal16 + vertical8,
          child: Text(
            context.t.drawer.data,
            style: context.appTextTheme.titleSmall?.copyWith(
              letterSpacing: 1.1,
            ),
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final canDeleteAll = state.tabs != null && state.tabs!.isNotEmpty;

            Future<void> showDeleteAllDialog() async {
              if (!canDeleteAll) return;

              CustomDialog<AlertDialog>.show(
                context: context,
                title: Text(
                  context.t.drawer.deleteAllDataTitle,
                ),
                content: Text(
                  context.t.drawer.deleteAllDataContent,
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.t.common.noCancel),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await coreSl<IAnalyticsService>().logEvent(
                        const CrudEventData(
                          page: AnalyticsPage.settings,
                          entity: AnalyticsEntity.allTabs,
                          action: AnalyticsAction.delete,
                        ),
                      );
                      context.read<HomeBloc>().add(
                        const HomeEvent.onPressedDeleteAll(),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(context.t.common.yesDelete),
                  ),
                ],
              );
            }

            return ListTile(
              title: Text(
                context.t.drawer.deleteAllData,
                style: context.appTextTheme.denseTitle,
              ),
              onTap: canDeleteAll ? showDeleteAllDialog : null,
              trailing: IconButton(
                key: context.keys.deleteAllDataButton,
                onPressed: canDeleteAll ? showDeleteAllDialog : null,
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
          title: Text(
            context.t.drawer.importExportData,
            style: context.appTextTheme.denseTitle,
          ),
          onTap: () async => openDataTransfer(),
          trailing: IconButton(
            key: context.keys.importExportDataButton,
            onPressed: () async => openDataTransfer(),
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
