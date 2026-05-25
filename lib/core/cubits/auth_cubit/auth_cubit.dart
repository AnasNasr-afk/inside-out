import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/responses/login_response_model.dart';
import '../../models/requests/signup_request_model.dart';
import '../../models/user_model.dart';
import '../../networking/api_client.dart';
import '../../networking/repositories/auth_repo.dart';
import '../../helpers/shared_pref.dart';
import '../../helpers/shared_pref_keys.dart';
import 'auth_listener.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  final _authRepository = AuthRepository();

  // ── Form keys ──────────────────────────────────────────
  final formSignupKey = GlobalKey<FormState>();
  final formLoginKey  = GlobalKey<FormState>();

  // ── Signup controllers ─────────────────────────────────
  final fullNameController       = TextEditingController();
  final phoneController          = TextEditingController();
  final emailSignupController    = TextEditingController();
  final passwordSignupController = TextEditingController();
  final cityController           = TextEditingController();
  final streetController         = TextEditingController();
  final childNameController      = TextEditingController();
  final childAgeController       = TextEditingController();
  final childCaseController      = TextEditingController();

  // ── Login controllers ──────────────────────────────────
  final emailLoginController    = TextEditingController();
  final passwordLoginController = TextEditingController();

  // ── Cached login response ──────────────────────────────
  LoginResponseModel? currentUser;

  // ── Register ───────────────────────────────────────────
  Future<void> register() async {
    if (!formSignupKey.currentState!.validate()) return;

    emit(RegisterLoadingState());
    try {
      final model = SignupRequestModel(
        fullName:    fullNameController.text.trim(),
        email:       emailSignupController.text.trim(),
        password:    passwordSignupController.text,
        phoneNumber: phoneController.text.trim(),
        city:        cityController.text.trim(),
        street:      streetController.text.trim(),
        children: [
          Child(
            name:        childNameController.text.trim(),
            age:         int.tryParse(childAgeController.text) ?? 0,
            description: childCaseController.text.trim(),
          ),
        ],
      );

      await _authRepository.registerParent(model);

      // Login response doesn't return names — save at registration time
      // await SharedPrefHelper.setData(
      //     SharedPrefKeys.fullName,  fullNameController.text.trim());
      // await SharedPrefHelper.setData(
      //     SharedPrefKeys.childName, childNameController.text.trim());

      emit(RegisterSuccessState());
    } on ApiException catch (e) {
      emit(RegisterErrorState(e.message));
    } catch (_) {
      emit(RegisterErrorState('Something went wrong. Please try again.'));
    }
  }

  // ── Login ──────────────────────────────────────────────
  Future<void> login() async {
    if (!formLoginKey.currentState!.validate()) return;

    emit(LoginLoadingState());
    try {
      currentUser = await _authRepository.login(
        emailLoginController.text.trim(),
        passwordLoginController.text,
      );
      await _persistSession(currentUser!);
      emit(LoginSuccessState(currentUser!.id));
    } on ApiException catch (e) {
      emit(LoginErrorState(e.message));
    } catch (_) {
      emit(LoginErrorState('Something went wrong. Please try again.'));
    }
  }

  // ── Persist session ────────────────────────────────────
  Future<void> _persistSession(LoginResponseModel user) async {
    await SharedPrefHelper.setData(SharedPrefKeys.userId, user.id);
    await SharedPrefHelper.setData(SharedPrefKeys.frontendId, user.frontendId);
    await SharedPrefHelper.setData(SharedPrefKeys.email, user.email);

    final childId = user.firstChildId;
    if (childId != null) {
      await SharedPrefHelper.setData(SharedPrefKeys.childId, childId);
      debugPrint('✅ childId saved: $childId');
    } else {
      debugPrint('⚠️ No childIds returned from login response');
    }
  }

  // ── Logout ─────────────────────────────────────────────
  Future<void> logout() async {
    emit(LogoutLoadingState());
    try {
      final userId = SharedPrefHelper.getString(SharedPrefKeys.userId);

      // Call backend logout — fire and forget if userId missing
      if (userId.isNotEmpty) {
        await _authRepository.logout(userId);
        debugPrint('✅ Backend logout successful');
      }
    } catch (e) {
      // Backend logout failed — still clear local data
      // User must be logged out locally regardless
      debugPrint('⚠️ Backend logout failed: $e — clearing local data anyway');
    } finally {
      // Always clear local session
      await SharedPrefHelper.clearAllData();
      currentUser = null;
      debugPrint('🧹 Local session cleared');
      emit(LogoutSuccessState());
    }
  }

  // ── Google Sign In ─────────────────────────────────────
  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoadingState());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(GoogleSignInErrorState('sign-in-cancelled'));
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user!;

      final firestore = FirebaseFirestore.instance;
      final userDoc =
      await firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        final nameParts = (user.displayName ?? '').split(' ');
        final newUser = UserModel(
          uid:       user.uid,
          firstName: nameParts.isNotEmpty ? nameParts.first : '',
          lastName:  nameParts.length > 1 ? nameParts.last : '',
          email:     user.email ?? '',
          photoUrl:  user.photoURL ?? '',
        );
        await firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());
      }

      emit(GoogleSignInSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(GoogleSignInErrorState(e.code));
    } catch (e) {
      emit(GoogleSignInErrorState(e.toString()));
    }
  }

  // ── Dispose controllers ────────────────────────────────
  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    emailSignupController.dispose();
    passwordSignupController.dispose();
    cityController.dispose();
    streetController.dispose();
    childNameController.dispose();
    childAgeController.dispose();
    childCaseController.dispose();
    emailLoginController.dispose();
    passwordLoginController.dispose();
    return super.close();
  }
}