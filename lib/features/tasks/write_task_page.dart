// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tasks_crud/core/models/task.dart';
import 'package:tasks_crud/features/tasks/providers/write_task_notifer_provider.dart';

class WriteTaskPage extends ConsumerWidget {
  WriteTaskPage({super.key, this.initial});

  final Task? initial;

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = writeTaskNotifierProvider(initial);
    final state = ref.read(provider);
    final notifier = ref.watch(provider.notifier);
    ref.watch(provider.select(
      (value) =>
          value.task.done.hashCode ^
          value.loading.hashCode ^
          value.task.ready.hashCode,
    ));

    return LoadingLayer(
      loading: state.loading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Write Task"),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: FilledButton(
              onPressed: state.task.ready
                  ? () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          await notifier.write();
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$e'),
                            ),
                          );
                        }
                      }
                    }
                  : null,
              child: const Text('Save'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Name"),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: state.task.name,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Requried";
                    }
                  },
                  onChanged: notifier.nameChanged,
                ),
                const SizedBox(height: 24),
                const Text("Description"),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: state.task.description,
                  maxLines: 5,
                  minLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Requried";
                    }
                  },
                  onChanged: notifier.descriptionChanged,
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: state.task.done,
                      onChanged: (v) {
                        notifier.doneChanged(v ?? false);
                      },
                    ),
                    const Text('Done'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingLayer extends StatelessWidget {
  const LoadingLayer({super.key, required this.child, this.loading = false});

  final bool loading;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Material(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
