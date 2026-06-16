
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient/core/cubits/task_cubit/task_listener.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';

import '../../models/app_notification.dart';
import '../../models/responses/parent_child_response_model.dart';
import '../../models/task_model.dart';
import '../../networking/api_client.dart';
import '../../networking/repositories/home_repo.dart';
import '../../networking/repositories/notification_repo.dart';
import '../../networking/repositories/tasks_repo.dart';
import '../../services/notification_service.dart';
import '../../services/notification_store.dart';


class TaskCubit extends Cubit<TaskStates> {
  TaskCubit() : super(TaskInitialState());

  static TaskCubit get(BuildContext context) => BlocProvider.of(context);

  final TaskRepository _taskRepository = TaskRepository();
  final HomeRepository _homeRepository = HomeRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  ParentChildResponseModel? parentChildData;
  List<TaskModel> tasks = [];

  StreamSubscription<String>? _tokenRefreshSub;



  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((t) => t.isCompleted).length;

  Future<void> getParentChildData(int childId) async {
    try {
      parentChildData = await _homeRepository.getParentChildData(childId);

      // Persist child profile so the AI avatar can read it without BLoC
      await SharedPrefHelper.setData(SharedPrefKeys.childName, parentChildData!.childName);
      await SharedPrefHelper.setData(SharedPrefKeys.childAge,  parentChildData!.age);
      await SharedPrefHelper.setData(SharedPrefKeys.childCase, parentChildData!.description);
      await SharedPrefHelper.setData(SharedPrefKeys.specialistId, parentChildData!.specialistId);
      await SharedPrefHelper.setData(SharedPrefKeys.specialistName, parentChildData!.specialistName);

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

  Future<void> completeTask(int taskId, String motherNote) async {
    emit(TaskCompleteLoadingState());
    try {
      await _taskRepository.completeTask(taskId, motherNote);
      emit(TaskCompleteSuccessState());

      // The backend pushes a notification to the specialist on completion.
      // Confirm to the parent locally and log it in the notification list.
      // Guarded so a display failure never flips the success state.
      try {
        await PushNotificationService.instance.pushLocalConfirmation(
          title: 'Task completed',
          body: 'Your note was sent to the specialist.',
          type: AppNotificationType.taskCompleted,
        );
      } catch (e) {
        debugPrint('⚠️ Local completion confirmation failed: $e');
      }
    } on ApiException catch (e) {
      emit(TaskCompleteErrorState(e.message));
    } catch (e) {
      emit(TaskCompleteErrorState('Something went wrong. Please try again.'));
    }
  }

  // ── Notifications ──────────────────────────────────────
  /// Boots the push pipeline: loads stored notifications, initialises FCM,
  /// registers this device's token, and re-registers on token refresh.
  Future<void> initNotifications() async {
    try {
      await NotificationStore.instance.init();
      await PushNotificationService.instance.init();
      await registerDeviceToken();

      _tokenRefreshSub ??= PushNotificationService.instance.onTokenRefresh
          .listen((token) => _sendToken(token));
    } catch (e) {
      debugPrint('⚠️ initNotifications failed: $e');
    }
  }

  /// Fetches the current FCM token and registers it with the backend (role 'Parent').
  Future<void> registerDeviceToken() async {
    final token = await PushNotificationService.instance.getToken();
    if (token == null || token.isEmpty) return;
    debugPrint('📱 FCM token (copy for Firebase test): $token');
    await _sendToken(token);
  }

  Future<void> _sendToken(String token) async {
    // The backend keys device tokens on the numeric parent id (frontendId).
    // SharedPrefs `userId` holds the auth GUID, which is not an int — so we use
    // frontendId, falling back to parsing userId only if it happens to be numeric.
    int userId = SharedPrefHelper.getInt(SharedPrefKeys.frontendId);
    if (userId <= 0) {
      userId = int.tryParse(SharedPrefHelper.getString(SharedPrefKeys.userId)) ?? 0;
    }
    if (userId <= 0) {
      debugPrint('⚠️ Skipping device-token registration — no valid frontendId');
      return;
    }
    final platform = Platform.isAndroid
        ? 'Android'
        : Platform.isIOS
            ? 'iOS'
            : 'Web';
    try {
      await _notificationRepository.registerDeviceToken(
        userId: userId,
        token: token,
        platform: platform,
      );
      debugPrint('✅ Device token registered for user $userId ($platform)');
    } catch (e) {
      debugPrint('⚠️ Device token registration failed: $e');
    }
  }

  /// Marks every notification as read (e.g. when the list is opened).
  Future<void> markNotificationsRead() =>
      NotificationStore.instance.markAllRead();

  @override
  Future<void> close() {
    _tokenRefreshSub?.cancel();
    return super.close();
  }
}
