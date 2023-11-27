import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/spacing_constants.dart';
import 'package:multichoice/get_it_injection.dart';
import 'package:multichoice/infrastructure/tabs/tabs_repository.dart';
import 'package:multichoice/presentation/home/widgets/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

part 'widgets/main_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/empty_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => TabsRepository(),
      child: BlocProvider(
        create: (_) => coreSl<HomeBloc>(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Multichoice'),
            centerTitle: true,
            leading: const Drawer(),
            backgroundColor: Colors.lightBlue,
            actions: const <Widget>[
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.add_outlined,
                ),
              ),
            ],
          ),
          body: _HomePage(),
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  _HomePage();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.isLoading) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('loading...'),
              ),
            );
        }
        if (state.isAdded) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('added...'),
              ),
            );
        }
        if (state.isDeleted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('deleted...'),
              ),
            );
        }
      },
      builder: (context, state) {
        final tabs = context.read<TabsRepository>().readTabs();

        return Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height / 1.375,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehaviour(),
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == tabs.length) {
                          return const EmptyTab();
                        } else {
                          return tabs[index];
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
