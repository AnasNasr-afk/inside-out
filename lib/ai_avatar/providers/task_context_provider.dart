import 'package:flutter_riverpod/flutter_riverpod.dart';

// Holds the formatted task context string injected into every Poly API call.
// Set by AiBearScreen on load, read by OpenAIResponseController on each turn.
final taskContextProvider = StateProvider<String>((ref) => '');
