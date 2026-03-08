import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/app/engine/tooltip_enums.dart';
import 'package:multichoice/presentation/shared/data_transfer/data_transfer_service.dart';
import 'package:multichoice/presentation/shared/data_transfer/utils/data_transfer_handlers.dart';
import 'package:multichoice/presentation/shared/data_transfer/widgets/data_transfer_content.dart';

@RoutePage()
class DataTransferScreen extends StatefulWidget {
  const DataTransferScreen({
    required this.onCallback,
    super.key,
  });

  final void Function() onCallback;

  @override
  State<DataTransferScreen> createState() => _DataTransferScreenState();
}

class _DataTransferScreenState extends State<DataTransferScreen> {
  late final DataTransferService _dataTransferService;
  late final Future<bool> _isDBEmpty;

  @override
  void initState() {
    super.initState();
    _dataTransferService = DataTransferService();
    _isDBEmpty = _dataTransferService.isDBEmpty();
  }

  // TODO(@ZanderCowboy): When the user Appends New Data, the data should
  // be appended to the end of the existing data, NOT the beginning.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Transfer'),
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          tooltip: TooltipEnums.back.tooltip,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.router.popUntilRoot();
              scaffoldKey.currentState?.closeDrawer();
            },
            tooltip: TooltipEnums.home.tooltip,
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: SafeArea(
        child: DataTransferContent(
          isDBEmpty: _isDBEmpty,
          onImportPressed: () => handleImport(
            context: context,
            service: _dataTransferService,
            onImportSuccess: widget.onCallback,
            showMessage: (message) => _showSnackBar(context, message),
          ),
          onExportPressed: () => handleExport(
            context: context,
            service: _dataTransferService,
            showMessage: (message) => _showSnackBar(context, message),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
