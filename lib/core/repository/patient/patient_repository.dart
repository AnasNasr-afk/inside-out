import 'package:patient/core/entities/patient_entities/patient_schedule_appointment_entity.dart';
import 'package:patient/core/result/result.dart';

import '../../../model/task_model.dart';

abstract interface class PatientRepository {

  /// Schedules an appointment by inserting a new record into the `session` table.
  ///
  /// This method takes a [PatientScheduleAppointmentEntity] object, converts it to a map,
  /// and inserts it into the `session` table using Supabase.
  ///
  /// - **Parameters:**  
  ///   - `appointmentEntity` : An instance of [PatientScheduleAppointmentEntity]  
  ///     containing appointment details.
  ///
  /// - **Returns:**  
  ///   - A [Future] of [ActionResult], which can either be:  
  ///     - [ActionResultSuccess] with a success message and status code `200` if the appointment  
  ///       is successfully scheduled.  
  ///     - [ActionResultFailure] with an error message and status code `500` if an exception occurs.
  ///
  /// - **Exceptions:**  
  ///   - If an error occurs while inserting the record, it is caught and returned as a failure.
  
  Future<ActionResult> scheduleAppointment(PatientScheduleAppointmentEntity appointmentEntity);

  Future<ActionResult> getTherapyGoals({
    required DateTime date,
  });
  /// Fetches all appointments from the `session` table.
  ///
  /// This method fetches all appointments from the `session` table using Supabase.
  ///
  /// - **Returns:**
  ///   - A [Future] of [ActionResult], which can either be:
  ///     - [ActionResultSuccess] with a success message and status code `200` if the appointments are successfully fetched.
  ///     - [ActionResultFailure] with an error message and status code `500` if an exception occurs.
  ///
  /// - **Exceptions:**
  ///   - If an error occurs while fetching the appointments, it is caught and returned as a failure.
  Future<ActionResult> fetchAllAppointments();

  /// Deletes an appointment from the `session` table.
  ///
  /// This method deletes an appointment from the `session` table using Supabase.
  ///
  /// - **Parameters:**
  ///   - `id` : The ID of the appointment to be deleted.
  ///
  /// - **Returns:**
  ///   - A [Future] of [ActionResult], which can either be:
  ///     - [ActionResultSuccess] with a success message and status code `200` if the appointment is successfully deleted.
  ///     - [ActionResultFailure] with an error message and status code `500` if an exception occurs.
  ///
  /// - **Exceptions:**
  ///   - If an error occurs while deleting the appointment, it is caught and returned as a failure.
  Future<ActionResult> deleteAppointment(String id);

  /// Fetches the activities for the given date.
  ///
  /// This method fetches the activities for the given date from the `daily_activity` table using Supabase.
  ///
  /// - **Parameters:**
  ///   - `date` : The date for which the activities are to be fetched.
  ///
  /// - **Returns:**
  ///   - A [Future] of [ActionResult], which can either be:
  ///     - [ActionResultSuccess] with a success message and status code `200` if the activities are successfully fetched.
  ///     - [ActionResultFailure] with an error message and status code `500` if an exception occurs.
  ///
  /// - **Exceptions:**
  ///   - If an error occurs while fetching the activities, it is caught and returned as a failure.
  Future<ActionResult> getTodayActivities({
    DateTime? date
  });

  /// Updates the completion status of the activities.
  ///
  /// This method updates the completion status of the activities in the `daily_activity` table using Supabase.
  ///
  /// - **Parameters:**
  ///   - `tasks` : A list of [PatientTaskModel] objects containing the activities to be updated.
  ///

  /// - **Returns:**
  ///   - A [Future] of [ActionResult], which can either be:
  ///     - [ActionResultSuccess] with a success message and status code `200` if the activities are successfully updated.
  ///     - [ActionResultFailure] with an error message and status code `500` if an exception occurs.
  ///
  /// - **Exceptions:**
  ///   - If an error occurs while updating the activities, it is caught and returned as a failure.
  Future<ActionResult> updateActivityCompletion({
    required List<PatientTaskModel> tasks,
    String? activityId,
    String? activitySetId,
  });

  /// Fetches the reports for the given date.
  ///
  /// This method fetches the reports for the given date from the `daily_activity` table using Supabase.
  ///
  /// - **Parameters:**
  ///   - `date` : The date for which the reports are to be fetched.
  ///
  /// - **Returns:**
  ///   - A [Future] of [ActionResult], which can either be:
  ///     - [ActionResultSuccess] with a success message and status code `200` if the reports are successfully fetched.
  ///     - [ActionResultFailure] with an error message and status code `500` if an exception occurs.
  ///
  /// - **Exceptions:**
  ///   - If an error occurs while fetching the reports, it is caught and returned as a failure.

  Future<ActionResult> getReports({
    required DateTime date,
  });
 
}