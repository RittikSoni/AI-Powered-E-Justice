import 'package:e_justice_v2/const/kquestion_ids.dart';
import 'package:e_justice_v2/const/kstrings.dart';
import 'package:e_justice_v2/models/questions_data_model.dart';
import 'package:flutter/material.dart';

class QAProvider extends ChangeNotifier {
  final List<AnsModel> _answers = [];

  List<AnsModel> get getAnswers => _answers;

  void updateAnswers(
      {required QuestionsDataModel questionData,
      required String newAnswer,
      bool? reset}) {
    final index = _answers.indexWhere(
        (ans) => ans.questionData.questionId == questionData.questionId);

    if (index != -1) {
      // If the question already exists, add the new answer if it doesn't already exist
      if (reset == true) {
        _answers[index].answers.clear();
        _answers[index].answers.add(newAnswer);
      } else if (!_answers[index].answers.contains(newAnswer)) {
        _answers[index].answers.add(newAnswer);
      } else {
        _answers[index].answers.remove(newAnswer);
      }
    } else {
      // If the question does not exist, create a new entry with the new answer
      _answers.add(AnsModel(questionData: questionData, answers: [newAnswer]));
    }

    // Notify listeners to update the UI
    notifyListeners();
  }

  bool isSelected(QuestionsDataModel questionData, String answer) {
    final index = _answers.indexWhere(
        (ans) => ans.questionData.questionId == questionData.questionId);
    if (index != -1) {
      return _answers[index].answers.contains(answer);
    }
    return false;
  }

  String get getCountryCode => _answers
      .firstWhere(
        (e) => e.questionData.questionId == KquestionIds.countryQuestionId,
        orElse: () => KDummyModelData.countryDefault,
      )
      .answers
      .first;

  /// get user longitude, latitude (if user opt-in)
  String get getLongLat => _answers
      .firstWhere(
        (e) => e.questionData.questionId == KquestionIds.nearMeId,
        orElse: () => KDummyModelData.longlatDefault,
      )
      .answers
      .first;
  String get getCrimeCategory => _answers
      .firstWhere(
        (e) => e.questionData.questionId == KquestionIds.crimeCategory,
        orElse: () => KDummyModelData.otherDefault,
      )
      .answers
      .join(',')
      .toString();
  String get getPerks => _answers
      .firstWhere(
        (e) => e.questionData.questionId == KquestionIds.perkSelection,
        orElse: () => KDummyModelData.otherDefault,
      )
      .answers
      .join(',')
      .toString();
  String get getShortText => _answers
      .firstWhere(
        (e) => e.questionData.questionId == KquestionIds.shortTextAns,
        orElse: () => KDummyModelData.otherDefault,
      )
      .answers
      .first
      .toString();

  String generateQuestion() {
    final String userCountryCode = getCountryCode;
    final String userShortText = getShortText;
    final String userPerks = getPerks;

    return '''
tell me general $userPerks applicable in given scenarios in table format in country $userCountryCode:
in case of $userShortText
''';
  }
}

class AnsModel {
  final QuestionsDataModel questionData;
  final List<String> answers;

  AnsModel({required this.questionData, required this.answers});
}
