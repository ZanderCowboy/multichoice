//
// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:ui_kit/ui_kit.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeedbackFormBody();
  }
}

class _FeedbackFormBody extends StatefulWidget {
  const _FeedbackFormBody();

  @override
  State<_FeedbackFormBody> createState() => _FeedbackFormBodyState();
}

class _FeedbackFormBodyState extends State<_FeedbackFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();

  final List<String> _categories = [
    'Bug Report',
    'Feature Request',
    'General Feedback',
    'UI/UX',
    'Performance',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final feedbackState = context.read<FeedbackBloc>().state.feedback;
    final appVersion = await coreSl<IAppInfoService>().getAppVersion();

    final feedbackDTO = FeedbackDTO(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: _messageController.text,
      userEmail: _emailController.text,
      rating: feedbackState.rating,
      deviceInfo:
          '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      appVersion: appVersion,
      timestamp: DateTime.now().toLocal(),
      category: feedbackState.category,
    );

    //
    // ignore: use_build_context_synchronously
    context.read<FeedbackBloc>().add(FeedbackEvent.submit(feedbackDTO));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: allPadding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: state.feedback.category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    context.read<FeedbackBloc>().add(
                          FeedbackEvent.fieldChanged(
                            field: FeedbackField.category,
                            value: value,
                          ),
                        );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                gap16,
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    context.read<FeedbackBloc>().add(
                          FeedbackEvent.fieldChanged(
                            field: FeedbackField.email,
                            value: value,
                          ),
                        );
                  },
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                ),
                gap16,
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Your Feedback',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    context.read<FeedbackBloc>().add(
                          FeedbackEvent.fieldChanged(
                            field: FeedbackField.message,
                            value: value,
                          ),
                        );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                gap16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < state.feedback.rating
                            ? Icons.star
                            : Icons.star_border,
                        color: index < state.feedback.rating
                            ? Colors.amber
                            : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () {
                        context.read<FeedbackBloc>().add(
                              FeedbackEvent.fieldChanged(
                                field: FeedbackField.rating,
                                value: index + 1,
                              ),
                            );
                      },
                    );
                  }),
                ),
                gap24,
                ElevatedButton(
                  onPressed:
                      state.isLoading ? null : () => _submitFeedback(context),
                  child: state.isLoading
                      ? CircularLoader.small()
                      : const Text('Submit Feedback'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
