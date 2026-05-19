import 'package:patient/ai_avatar/data/openai_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_response_controller.g.dart';

@riverpod
class OpenAIResponseController extends _$OpenAIResponseController {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  void getResponse(String prompt) async {
    final repository = ref.read(openAIRepostitoryProvider);

    state = const AsyncValue.loading();

    final responseValue = await AsyncValue.guard(() async {
      return repository.fetchAnswer(prompt);
    });

    responseValue.when(
      data: (data) => print('Gemini response: $data'),
      error: (error, _) => print('Gemini error: $error'),
      loading: () {},
    );

    state = responseValue;
  }
}
