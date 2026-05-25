import 'package:flutter_bloc/flutter_bloc.dart';

import 'avatar_states.dart';

class AvatarCubit extends Cubit<AvatarState> {
  AvatarCubit() : super(const AvatarState(emotion: 'idle'));

  void setEmotion(String emotion) {
    emit(AvatarState(emotion: emotion));
  }
}