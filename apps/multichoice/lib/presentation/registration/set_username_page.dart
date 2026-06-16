import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/app/view/auth/auth_notifier.dart';
import 'package:multichoice/i18n/localize_core_message.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/registration/widgets/username_field.dart';
import 'package:multichoice/presentation/shared/widgets/shine_card.dart';
import 'package:multichoice/utils/user_accounts_feature.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class SetUsernamePage extends StatefulWidget {
  const SetUsernamePage({super.key});

  @override
  State<SetUsernamePage> createState() => _SetUsernamePageState();
}

class _SetUsernamePageState extends State<SetUsernamePage> {
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    guardUserAccountsRoute(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<SetUsernameBloc>(),
      child: BlocConsumer<SetUsernameBloc, SetUsernameState>(
        listener: (context, state) {
          if (state.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  localizeCoreMessage(context, state.errorMessage!),
                ),
              ),
            );
          }
          if (state.isSuccess) {
            context.read<AuthNotifier>().notifyAuthChanged();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.t.profile.usernameSetSuccess)),
            );
            context.router.popUntilRoot();
          }
        },
        builder: (context, state) {
          final canSubmit =
              UsernameField.defaultValidator(state.username, context.t) == null;

          return Scaffold(
            appBar: AppBar(
              title: Text(context.t.profile.setUsername),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: allPadding16,
                child: ShineCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.t.profile.setUsernameDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      gap16,
                      UsernameField(
                        controller: _usernameController,
                        onChanged: (value) => context.read<SetUsernameBloc>().add(
                          SetUsernameEvent.usernameChanged(value),
                        ),
                      ),
                      gap24,
                      AsyncFilledButton(
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<SetUsernameBloc>().add(
                                const SetUsernameEvent.submitted(),
                              ),
                        enabled: canSubmit,
                        isLoading: state.isLoading,
                        label: Text(context.t.common.save),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
