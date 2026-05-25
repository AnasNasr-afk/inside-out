
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/cubits/task_cubit/task_listener.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';

import '../../models/responses/parent_child_response_model.dart';
import '../../models/task_model.dart';
import '../../networking/api_client.dart';
import '../../networking/repositories/home_repo.dart';
import '../../networking/repositories/tasks_repo.dart';


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
      parentChildData = await _homeRepository.getParentChildData(childId);

      // Persist child profile so the AI avatar can read it without BLoC
      await SharedPrefHelper.setData(SharedPrefKeys.childAge, parentChildData!.age);
      await SharedPrefHelper.setData(SharedPrefKeys.childCase, parentChildData!.description);

      emit(TaskSuccessState(tasks));
    } catch (e) {
      emit(TaskErrorState('Failed to load parent/child data'));
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
