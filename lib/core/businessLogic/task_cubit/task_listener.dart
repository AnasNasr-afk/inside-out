import '../../../model/task_model.dart';

abstract class TaskStates {}

class TaskInitialState extends TaskStates {}

class TaskLoadingState extends TaskStates {}
class TaskSuccessState extends TaskStates {
  final List<TaskModel> tasks;
  TaskSuccessState(this.tasks);
}
class TaskErrorState extends TaskStates {
  final String message;
  TaskErrorState(this.message);
}
