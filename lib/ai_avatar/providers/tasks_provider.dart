import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patient/core/models/task_model.dart';

final tasksProvider = StateProvider<List<TaskModel>>((ref) => const []);

// true while _loadChildData is in flight; false once tasks arrive (or error)
final tasksLoadingProvider = StateProvider<bool>((ref) => true);
