import 'dart:io';

import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/i18n/strings.g.dart';
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

  List<String> _categories(BuildContext context) => [
    context.t.feedback.categories.bugReport,
    context.t.feedback.categories.featureRequest,
    context.t.feedback.categories.generalFeedback,
    context.t.feedback.categories.uiUx,
    context.t.feedback.categories.performance,
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

    // ignore: use_build_context_synchronously
    context.read<FeedbackBloc>().add(FeedbackEvent.submit(feedbackDTO));
  }

  Future<void> _pickImage(BuildContext context) async {
    final result = await coreSl<FilePicker>().pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      if (context.mounted) {
        for (final file in result.files) {
          context.read<FeedbackBloc>().add(FeedbackEvent.imageAdded(file));
        }
      }
    }
  }

  Widget _buildImageThumbnails(BuildContext context, FeedbackState state) {
    if (state.imageFiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gap16,
        Text(context.t.feedback.attachedImages),
        gap8,
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.imageFiles.length,
            separatorBuilder: (_, _) => gap8,
            itemBuilder: (context, index) {
              final file = state.imageFiles[index];
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: file.bytes != null
                        ? Image.memory(file.bytes!, fit: BoxFit.cover)
                        : file.path != null
                        ? Image.file(File(file.path!), fit: BoxFit.cover)
                        : const Icon(Icons.image),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context.read<FeedbackBloc>().add(
                            FeedbackEvent.imageRemoved(index),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
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
                  initialValue: state.feedback.category,
                  decoration: InputDecoration(
                    labelText: context.t.feedback.categoryLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: _categories(context).map((category) {
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
                      return context.t.feedback.selectCategory;
                    }
                    return null;
                  },
                ),
                gap16,
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: context.t.feedback.emailLabel,
                    border: const OutlineInputBorder(),
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
                        return context.t.feedback.invalidEmail;
                      }
                    }
                    return null;
                  },
                ),
                gap16,
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: context.t.feedback.messageLabel,
                    border: const OutlineInputBorder(),
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
                      return context.t.feedback.enterFeedback;
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
                gap16,
                if (coreSl<IFirebaseService>().isEnabled(
                  FirebaseConfigKeys.feedbackImagesEnabled,
                )) ...[
                  OutlinedButton.icon(
                    onPressed: () => _pickImage(context),
                    icon: const Icon(Icons.image),
                    label: Text(context.t.feedback.addImages),
                  ),
                  _buildImageThumbnails(context, state),
                  gap24,
                ] else ...[
                  gap24,
                ],
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () => _submitFeedback(context),
                  child: state.isLoading
                      ? CircularLoader.small()
                      : Text(context.t.feedback.submitFeedback),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
