

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../model/user_model.dart';
import 'auth_listener.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);


  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoadingState());

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(GoogleSignInErrorState("sign-in-cancelled"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user!;

      final firestore = FirebaseFirestore.instance;
      final userDoc =
      await firestore.collection("users").doc(user.uid).get();

      if (!userDoc.exists) {
        final nameParts = (user.displayName ?? "").split(" ");

        final newUser = UserModel(
          uid: user.uid,
          firstName: nameParts.isNotEmpty ? nameParts.first : "",
          lastName: nameParts.length > 1 ? nameParts.last : "",
          email: user.email ?? "",
          photoUrl: user.photoURL ?? "",
        );

        await firestore
            .collection("users")
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
}
