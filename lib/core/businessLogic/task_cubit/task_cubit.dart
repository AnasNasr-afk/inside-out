
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/businessLogic/task_cubit/task_listener.dart';

import '../../../model/responses/parent_child_response_model.dart';
import '../../../model/task_model.dart';
import '../../networking/api_client.dart';
import '../../networking/data/home_repo.dart';
import '../../networking/data/tasks_repo.dart';


class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitialState());

  static TaskCubit get(BuildContext context) => BlocProvider.of(context);

  final TaskRepository _taskRepository = TaskRepository();
  final HomeRepository _homeRepository = HomeRepository();
  ParentChildResponseModel? parentChildData;
  List<TaskModel> tasks = [];



  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  Future<void> getParentChildData(int childId) async {
    try {
      parentChildData =
      await _homeRepository.getParentChildData(
        childId,
      );

      emit(TaskSuccessState(tasks));
    } catch (e) {
      emit(TaskErrorState(
        'Failed to load parent/child data',
      ));
    }
  }
  Future<void> getTasks(int childId) async {
    emit(TaskLoadingState());
    try {
      tasks = await _taskRepository.getTasks(childId);
      emit(TaskSuccessState(tasks));
    } on ApiException catch (e) {
      emit(TaskErrorState(e.message));
    } catch (e) {
      emit(TaskErrorState('Something went wrong. Please try again.'));
    }
  }
}
