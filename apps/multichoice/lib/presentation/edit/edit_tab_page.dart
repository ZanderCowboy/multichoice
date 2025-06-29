import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class EditTabPage extends StatelessWidget {
  const EditTabPage({
    required this.ctx,
    super.key,
  });

  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: ctx.read<HomeBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Tab'),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              ctx.read<HomeBloc>().add(const HomeEvent.onPressedCancel());
              context.router.popUntilRoot();
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
        if (state.isLoading) {
          return CircularLoader.small();
        }

        return Padding(
          padding: allPadding18,
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
                gap20,
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
                gap20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              const HomeEvent.onPressedCancel(),
                            );
                        context.router.popUntilRoot();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: state.isValid && state.tab.title.isNotEmpty
                          ? () {
                              context
                                  .read<HomeBloc>()
                                  .add(const HomeEvent.onSubmitEditTab());

                              context.router.popUntilRoot();
                            }
                          : null,
                      child: const Text('Ok'),
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
