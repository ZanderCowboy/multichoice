import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/spacing_constants.dart';

Future<T?> show<T>(BuildContext ctx, HomeBloc bloc, int id) {
  return showDialog<T>(
    context: ctx,
    builder: (_) {
      return BlocProvider<HomeBloc>.value(
        value: bloc..add(HomeEvent.onUpdateTab(id)),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return AlertDialog(
              title: Text('Delete ${state.tab.title}?'),
              content: Text(
                "Are you sure you want to delete tab ${state.tab.title} and all it's entries?",
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    gap10,
                    ElevatedButton(
                      onPressed: () {
                        ctx.read<HomeBloc>()
                          ..add(
                            HomeEvent.onLongPressedDeleteTab(id),
                          )
                          ..add(const HomeEvent.onGetTabs());

                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
