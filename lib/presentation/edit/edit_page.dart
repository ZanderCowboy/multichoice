import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/application/export_application.dart';
import 'package:multichoice/constants/spacing_constants.dart';

@RoutePage()
class EditPage extends StatelessWidget {
  const EditPage({
    required this.ctx,
    super.key,
  });

  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: ctx.read<HomeBloc>(),
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: const Text('Edit'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              ctx.read<HomeBloc>().add(const HomeEvent.onPressedCancelTab());
              context.router.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
          ),
        ),
        body: const _EditPage(),
      ),
    );
  }
}

class _EditPage extends StatelessWidget {
  const _EditPage();

  @override
  Widget build(BuildContext context) {
    const formKey = GlobalObjectKey<FormState>('form');

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: allPadding12,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  initialValue: state.tab.title,
                  onChanged: (value) {
                    context.read<HomeBloc>().add(
                          HomeEvent.onChangedTabTitle(value),
                        );
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: state.tab.subtitle,
                  onChanged: (value) {
                    context.read<HomeBloc>().add(
                          HomeEvent.onChangedTabSubtitle(value),
                        );
                  },
                  decoration: const InputDecoration(
                    labelText: 'Subtitle',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: state.isValid
                          ? () {
                              context.read<HomeBloc>()
                                ..add(const HomeEvent.onEditTab())
                                ..add(const HomeEvent.onGetTabs());

                              context.router.popUntilRoot();
                            }
                          : null,
                      child: const Text('Add'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              const HomeEvent.onPressedCancelTab(),
                            );
                        context.router.pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
