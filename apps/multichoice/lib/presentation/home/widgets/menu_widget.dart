import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app_router.gr.dart';
import 'package:multichoice/application/home/home_bloc.dart';
import 'package:multichoice/constants/spacing_constants.dart';
import 'package:multichoice/models/enums/menu_items.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    required this.ctx,
    required this.homeBloc,
    required this.id,
    super.key,
  });

  final BuildContext ctx;
  final HomeBloc homeBloc;
  final int id;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      consumeOutsideTap: true,
      builder: (_, controller, __) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(
            Icons.more_vert_outlined,
          ),
          hoverColor: Colors.pink,
          padding: EdgeInsets.zero,
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () => {
            context.router.push(EditTabPageRoute(ctx: context)),
          },
          child: Text(MenuItems.edit.name),
        ),
        MenuItemButton(
          onPressed: () {
            showDialog<AlertDialog>(
              context: ctx,
              builder: (_) {
                return BlocProvider<HomeBloc>.value(
                  value: homeBloc..add(HomeEvent.onUpdateTab(id)),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (builderCtx, state) {
                      return AlertDialog(
                        title: Text(
                          'Delete All Entries of ${state.tab.title}?',
                        ),
                        content: SizedBox(
                          height: 50,
                          child: Text(
                            'Are you sure you want to delete all the entries of ${state.tab.title}?',
                          ),
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () => Navigator.of(
                                  builderCtx,
                                ).pop(),
                                child: const Text(
                                  'Cancel',
                                ),
                              ),
                              gap10,
                              ElevatedButton(
                                onPressed: () {
                                  context.read<HomeBloc>()
                                    ..add(
                                      HomeEvent.onPressedDeleteEntries(
                                        id,
                                      ),
                                    )
                                    ..add(const HomeEvent.onGetTabs());

                                  if (Navigator.canPop(
                                    builderCtx,
                                  )) {
                                    Navigator.of(
                                      builderCtx,
                                    ).pop();
                                  }
                                },
                                child: const Text(
                                  'Delete Entries',
                                ),
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
          },
          child: Text(MenuItems.deleteEntries.name),
        ),
        MenuItemButton(
          onPressed: () {
            showDialog<AlertDialog>(
              context: ctx,
              builder: (_) {
                return BlocProvider<HomeBloc>.value(
                  value: homeBloc..add(HomeEvent.onUpdateTab(id)),
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
                                  context.read<HomeBloc>()
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
          },
          child: Text(MenuItems.delete.name),
        ),
      ],
    );
  }
}
