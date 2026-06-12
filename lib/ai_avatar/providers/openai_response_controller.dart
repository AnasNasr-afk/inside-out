import 'package:flutter/material.dart';
import 'package:patient/ai_avatar/data/openai_repository.dart';
import 'package:patient/ai_avatar/providers/animation_state_controller.dart';
import 'package:patient/ai_avatar/providers/child_profile_provider.dart';
import 'package:patient/ai_avatar/providers/task_context_provider.dart';
import 'package:patient/ai_avatar/utils/input_preprocessor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_response_controller.g.dart';

@riverpod
class OpenAIResponseController extends _$OpenAIResponseController {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  void speakDirect(String text) {
    state = AsyncValue.data(text);
  }

  void getResponse(String prompt) async {
    final repository = ref.read(openAIRepostitoryProvider);
    final language = ref.read(animationStateControllerProvider).language;
    final profile = ref.read(childProfileProvider);
    // Always include task context per turn so GPT stays anchored to the specific
    // task even as conversation history grows. The primed system message covers
    // full detail; this acts as a lightweight per-turn reminder.
    final taskContext = ref.read(taskContextProvider);
    final contextualPrompt = InputPreprocessor.buildPrompt(
      prompt,
      language,
      taskContext: taskContext,
      childName: profile.name,
      childAge: profile.age,
      childCase: profile.medicalCase,
    );

    state = const AsyncValue.loading();

    final responseValue = await AsyncValue.guard(() async {
      return repository.fetchAnswer(contextualPrompt);
    });

    responseValue.when(
      data: (data) => debugPrint('✅ Poly response: $data'),
      error: (error, _) => debugPrint('❌ OpenAI error: $error'),
      loading: () {},
    );

    state = responseValue;
  }
}
