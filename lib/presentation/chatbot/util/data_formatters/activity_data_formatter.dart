import 'package:patient/model/task_model.dart';

abstract class GenericDataFormatter<T> {
  String formatResponse(List<T> items);
}

class ActivityDataFormatter extends GenericDataFormatter<PatientTaskModel> {

  @override
  String formatResponse(List<PatientTaskModel> items) {
    if (items.isEmpty) {
      return '📋✨ No activities found for today. Enjoy your free time!';
    }

    final completedCount = items.where((task) => task.isCompleted == true).length;
    final totalCount = items.length;
    
    final activitiesList = items.map((activity) {
      final status = activity.isCompleted == true ? '✅' : '⏳';
      return '$status ${activity.activityName ?? 'Unknown Activity'}';
    }).join('\n');

    return '📋✨ Here are your activities for today:\n\n$activitiesList\n\n📊 Progress: $completedCount/$totalCount completed\n\n🎯 Keep up the great work!';
  }
}
