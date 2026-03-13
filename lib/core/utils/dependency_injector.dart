import 'package:get_it/get_it.dart';
import 'package:patient/core/core.dart';
import 'package:patient/repository/supabase_patient_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerSingleton<PatientRepository>(SupabasePatientRepository(supabaseClient: getIt<SupabaseClient>()));
}