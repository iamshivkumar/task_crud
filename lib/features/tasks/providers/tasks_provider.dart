




import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tasks_crud/core/models/task.dart';
import 'package:tasks_crud/core/repositories/tasks_repository_provider.dart';

part 'tasks_provider.g.dart';

@riverpod
FutureOr<List<Task>> tasks(TasksRef ref) {
  return ref.read(tasksRepositoryProvider).list();
}