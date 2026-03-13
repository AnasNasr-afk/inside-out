import 'package:flutter/material.dart';
import 'package:patient/core/core.dart';
import 'package:patient/core/repository/repository.dart';
import 'package:patient/core/utils/utils.dart';

import '../model/therapy_models/therapy_models.dart';

class TherapyGoalsProvider extends ChangeNotifier {

  TherapyGoalsProvider({
    required PatientRepository patientRepository,
  }): _patientRepository = patientRepository;

  final PatientRepository _patientRepository;

  TherapyGoalModel? _therapyGoal;
  ApiStatus _apiStatus = ApiStatus.initial;

  TherapyGoalModel? get therapyGoal => _therapyGoal;
  ApiStatus get apiStatus => _apiStatus;

  void fetchTherapyGoals(DateTime date) async {
    _apiStatus = ApiStatus.loading;
    notifyListeners();

    final result = await _patientRepository.getTherapyGoals(date: date);

    if (result is ActionResultSuccess) {
      _therapyGoal = result.data as TherapyGoalModel;
      _apiStatus = ApiStatus.success;
      notifyListeners();
    } else {
      _therapyGoal = null;
      _apiStatus = ApiStatus.failure;
      notifyListeners();
    }
  }
}