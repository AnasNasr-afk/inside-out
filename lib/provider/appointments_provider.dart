import 'package:flutter/material.dart';
import 'package:patient/core/core.dart';
import 'package:patient/core/repository/auth/auth.dart';
import 'package:patient/model/patient_models/patient_models.dart';
import 'package:patient/presentation/appointments/models/appointment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentsProvider extends ChangeNotifier {

  AppointmentsProvider({
    required AuthRepository authRepository,
    required PatientRepository patientRepository,
  }) : _authRepository = authRepository, _patientRepository = patientRepository;

  final AuthRepository _authRepository;
  final PatientRepository _patientRepository;

  static const List<String> _serviceTypes = [
    'Consultation',
    'Therapy Session',
    'Assessment Evaluation',
  ];

  final List<AppointmentModel> _appointments = [];
  List<String> _availableTimeSlots = [];

  String _selectedService = 'Consultation';
  DateTime? _selectedDate;
  String _selectedTimeSlot = '';

  // Getters
  List<String> get serviceTypes => _serviceTypes;
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  String get selectedService => _selectedService;
  DateTime? get selectedDate => _selectedDate;
  String get selectedTimeSlot => _selectedTimeSlot;
  bool get hasAppointments => _appointments.isNotEmpty;
  List<String> get availableTimeSlots => _availableTimeSlots;
 // List<Map<String, dynamic>> get timeSlots => List.unmodifiable(_timeSlots);


  // Setters

  set availableTimeSlots(List<String> timeSlots) {
    _availableTimeSlots = timeSlots;
  }

  void setSelectedService(String service) {
    if (_selectedService != service) {
      _selectedService = service;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
    _availableBookingSlots(date);
  }

  void setSelectedTimeSlot(String timeSlot) {
    if (_selectedTimeSlot != timeSlot) {
      _selectedTimeSlot = timeSlot;
      notifyListeners();
    }
  }

  void _availableBookingSlots(DateTime date) async {
    try {
      final result = await _authRepository.getAvailableBookingSlotsForTherapist(
        '5929f9bb-e294-4812-ae08-4a1c10ca7123', date, '9:30', '18:00');
      if(result is ActionResultSuccess) {
        availableTimeSlots = result.data as List<String>;
      } else {
        availableTimeSlots = [];
      }
    } catch(e) {
      print(e);
      availableTimeSlots = [];
    } finally {
      notifyListeners();
    }
  }

  /// Helper method to format `TimeOfDay` into readable string.
  String _formatTimeOfDay(TimeOfDay time, BuildContext context) {
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  // Fetch all appointments from the patient repository
  Future<void> fetchAllAppointments() async {
    try {
      final result = await _patientRepository.fetchAllAppointments();
      if(result is ActionResultSuccess) {
        _appointments.clear();
        _appointments.addAll(result.data as List<AppointmentModel>);
      }
      if(result is ActionResultFailure) {
        if(result.statusCode == 404) {
          _appointments.clear();
        }
      }
    } catch(e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  /// Creates a new appointment and resets selection. Future: Save to Supabase.
  Future<bool> createAppointment() async {
    try {
      final appointmentModel = PatientScheduleAppointmentModel(
        patientId: Supabase.instance.client.auth.currentUser!.id,
        therapistId: '', 
        serviceType: _selectedService, 
        date: _selectedDate!.toIso8601String(),
        slot: _selectedTimeSlot, 
        appointmentName: 'Appointment with the Therapist'
      );

      final result = await _authRepository.bookConsultation(appointmentModel.toEntity().toConsultationRequestEntity());


      if(result is ActionResultSuccess) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    } finally {
      fetchAllAppointments();
      notifyListeners();
    }
  }

  /// Deletes an appointment by ID.
  Future<bool> deleteAppointment(String id) async {
    try {
      final result = await _patientRepository.deleteAppointment(id);
      if(result is ActionResultSuccess) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    } finally {
      fetchAllAppointments();
      notifyListeners();
    }
  }

  /// Clears selected service, date, and time slot.
  void clearSelections() {
    _selectedService = 'Consultation';
    _selectedDate = null;
    _selectedTimeSlot = '';
    notifyListeners();
  }
}
