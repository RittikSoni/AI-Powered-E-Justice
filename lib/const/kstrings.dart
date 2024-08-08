import 'package:e_justice_v2/const/kenums.dart';
import 'package:e_justice_v2/const/kquestion_ids.dart';
import 'package:e_justice_v2/models/questions_data_model.dart';
import 'package:e_justice_v2/providers/q_a_provider.dart';

class Kstrings {
  static const String disclaimer =
      "Information is for general knowledge and should not be considered legal advice. It's always recommended to consult with a qualified lawyer for specific legal guidance.";
}

class KDummyModelData {
  static AnsModel countryDefault = AnsModel(
      questionData: QuestionsDataModel(
          questionId: KquestionIds.countryQuestionId,
          question: '',
          questionType: KEnumQuestionType.countryDropdown,
          bg: []),
      answers: ['IN']);

  static AnsModel longlatDefault = AnsModel(
      questionData: QuestionsDataModel(
          questionId: KquestionIds.nearMeId,
          question: '',
          questionType: KEnumQuestionType.nearMeServices,
          bg: []),
      answers: ['n/a']);

  static AnsModel otherDefault = AnsModel(
      questionData: QuestionsDataModel(
          questionId: KquestionIds.nearMeId,
          question: '',
          questionType: KEnumQuestionType.nearMeServices,
          bg: []),
      answers: ['n/a']);
}
