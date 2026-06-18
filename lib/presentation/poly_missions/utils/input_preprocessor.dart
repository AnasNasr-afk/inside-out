class InputPreprocessor {
  static String classifyEmotion(String input) {
    final lower = input.toLowerCase();

    if (_hasAny(lower, [
      'scared', 'scary', 'no no', 'stop stop', 'too loud', 'loud loud',
      'hurts', 'hurt', 'pain', "don't want", 'not want', 'go away',
      // Egyptian Arabic
      'خايف', 'خوف', 'وجع', 'بيوجع', 'وجعني', 'ألم', 'مش عايز', 'مش عاوز',
      'بطل', 'بطّل', 'سيبني', 'لأ لأ', 'عالي',
    ])) { return 'distressed'; }

    if (_hasAny(lower, [
      'sad', 'miss', 'not coming', 'gone', 'lonely', 'alone', 'crying', 'cry',
      // Egyptian Arabic
      'زعلان', 'حزين', 'وحشني', 'وحشتني', 'بعيط', 'عياط', 'لوحدي', 'مروحش',
    ])) { return 'sad'; }

    if (_hasAny(lower, [
      "can't", 'cannot', 'issue', 'problem', 'hard', 'difficult', 'struggle',
      'not fair', 'unfair', 'stop it', "won't work", "doesn't work",
      // Egyptian Arabic
      'مقدرش', 'ماقدرش', 'مش قادر', 'صعب', 'صعبة', 'مشكلة', 'مش بيشتغل',
      'مش عارف', 'مش هينفع',
    ])) { return 'frustrated'; }

    if (input.contains('!') ||
        _hasAny(lower, [
          'again again', 'yes yes', 'wow', 'look look', 'yay',
          // Egyptian Arabic
          'تاني تاني', 'أيوه أيوه', 'واو', 'يا سلام', 'جامد',
        ])) {
      return 'excited';
    }

    return 'calm';
  }

  static String buildPrompt(
    String input,
    String language, {
    String taskContext = '',
    String childName = '',
    int childAge = 0,
    String childCase = '',
  }) {
    final emotion = classifyEmotion(input);

    // Child profile tag — only include fields that are known
    final profileParts = <String>[
      if (childName.isNotEmpty) 'name: $childName',
      if (childAge > 0) 'age: $childAge',
      if (childCase.isNotEmpty) 'case: $childCase',
    ];
    final profileTag = profileParts.isNotEmpty
        ? '[Child profile — ${profileParts.join(', ')}]'
        : '';

    final contextParts = <String>[
      'Child seems: $emotion',
      'Language: $language',
      if (taskContext.isNotEmpty) taskContext,
    ];
    final contextTag = '[${contextParts.join(' | ')}]';

    final header = [profileTag, contextTag].where((s) => s.isNotEmpty).join('\n');
    return '$header\nChild says: $input';
  }

  static bool _hasAny(String text, List<String> patterns) =>
      patterns.any(text.contains);
}
