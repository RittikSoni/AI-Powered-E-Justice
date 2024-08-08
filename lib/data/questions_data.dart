import 'package:e_justice_v2/const/kenums.dart';
import 'package:e_justice_v2/const/kquestion_ids.dart';
import 'package:e_justice_v2/const/ktheme.dart';
import 'package:e_justice_v2/models/questions_data_model.dart';

List<QuestionsDataModel> questionsData = [
  QuestionsDataModel(
    questionId: 'countrySelection',
    question: "Choose your Country",
    bg: Ktheme.kmeshgrad1,
    questionType: KEnumQuestionType.countryDropdown,
  ),
  QuestionsDataModel(
    questionId: KquestionIds.perkSelection,
    question: "What do you wants to know?",
    bg: Ktheme.kmeshgrad2,
    questionType: KEnumQuestionType.multiSelectCheckBox,
    options: [
      'Punishments',
      'Laws, Act & Sections',
      'Resources',
    ],
  ),
  QuestionsDataModel(
    questionId: KquestionIds.defendantTypeSelection,
    question: "Are you a _",
    bg: Ktheme.kmeshgrad3,
    questionType: KEnumQuestionType.singleSelectCheckBox,
    options: ['Company', 'Individual', 'Other'],
  ),
  QuestionsDataModel(
    questionId: KquestionIds.shortTextAns,
    question: "Tell me about the situation in max 250 chars.",
    bg: Ktheme.kmeshgrad1,
    questionType: KEnumQuestionType.shortText,
  ),
];
