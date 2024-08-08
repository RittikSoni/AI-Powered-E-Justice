import 'dart:ui';

import 'package:e_justice_v2/const/kenums.dart';

class QuestionsDataModel {
  final String questionId;
  final List<Color> bg;
  final String question;
  final KEnumQuestionType questionType;
  final List<String>? options;

  QuestionsDataModel({
    required this.questionId,
    required this.question,
    required this.questionType,
    required this.bg,
    this.options,
  });
}
