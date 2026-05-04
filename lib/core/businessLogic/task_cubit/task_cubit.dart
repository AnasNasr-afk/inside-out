
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/businessLogic/task_cubit/task_listener.dart';

import '../../../model/task_model.dart';
import '../../networking/api_client.dart';
import '../../networking/tasks_repo.dart';


class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitialState());

  static TaskCubit get(BuildContext context) => BlocProvider.of(context);

  final TaskRepository _repository = TaskRepository();

  List<TaskModel> tasks = [];

  Future<void> getTasks(int childId) async {
    emit(TaskLoadingState());
    try {
      tasks = await _repository.getTasks(childId);
      emit(TaskSuccessState(tasks));
    } on ApiException catch (e) {
      emit(TaskErrorState(e.message));
    } catch (e) {
      emit(TaskErrorState('Something went wrong. Please try again.'));
    }
  }
}
