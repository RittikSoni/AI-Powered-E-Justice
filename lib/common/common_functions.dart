import 'package:country_list_pick/country_list_pick.dart';
import 'package:e_justice_v2/const/kenums.dart';
import 'package:e_justice_v2/const/kstrings.dart';
import 'package:e_justice_v2/models/questions_data_model.dart';
import 'package:e_justice_v2/providers/q_a_provider.dart';
import 'package:e_justice_v2/routes/kroutes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

class CommonFunctions {
  static getQuestionOptions({required QuestionsDataModel questionData}) {
    final qaPro = Provider.of<QAProvider>(navigatorKey.currentContext!);
    final getAnsPro = qaPro.getAnswers;

    switch (questionData.questionType) {
      case KEnumQuestionType.countryDropdown:
        return CountryListPick(
          pickerBuilder: (context, countryCode) {
            return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      countryCode?.name ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 9.0,
                    ),
                    Image.asset(
                      countryCode!.flagUri.toString(),
                      package: 'country_list_pick',
                      height: 25.0,
                      width: 25.0,
                      fit: BoxFit.contain,
                    ),
                  ],
                ));
          },
          useUiOverlay: false,
          useSafeArea: true,
          theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: true,
            isShowCode: false,
            isDownIcon: true,
            showEnglishName: true,
          ),
          onChanged: (value) {
            qaPro.updateAnswers(
                questionData: questionData,
                newAnswer: value.toString(),
                reset: true);
          },
          initialSelection: getAnsPro.isEmpty
              ? 'IN'
              : getAnsPro
                  .firstWhere(
                    (e) => e.questionData.questionId == 'countrySelection',
                    orElse: () => KDummyModelData.countryDefault,
                  )
                  .answers
                  .first,
        );

      case KEnumQuestionType.multiSelectCheckBox:
        return Consumer<QAProvider>(
          builder: (context, provid, child) => MultiSelectChipDisplay(
            onTap: (p0) {
              qaPro.updateAnswers(questionData: questionData, newAnswer: p0);
            },
            icon: const Icon(
              Icons.balance_rounded,
            ),
            alignment: Alignment.center,
            items: questionData.options
                ?.map((e) => MultiSelectItem(e, e))
                .toList(),
            colorator: (p0) => provid.isSelected(questionData, p0)
                ? Colors.lightBlue
                : Colors.white,
            textStyle: const TextStyle(color: Colors.black),
          ),
        );

      case KEnumQuestionType.singleSelectCheckBox:
        return Consumer<QAProvider>(
          builder: (context, provid, child) => MultiSelectChipDisplay(
            onTap: (p0) {
              qaPro.updateAnswers(
                  questionData: questionData, newAnswer: p0, reset: true);
            },
            icon: const Icon(
              Icons.balance_rounded,
            ),
            alignment: Alignment.center,
            items: questionData.options
                ?.map((e) => MultiSelectItem(e, e))
                .toList(),
            colorator: (p0) => provid.isSelected(questionData, p0)
                ? Colors.lightBlue
                : Colors.white,
            textStyle: const TextStyle(color: Colors.black),
          ),
        );
      case KEnumQuestionType.nearMeServices:
        return Consumer<QAProvider>(
          builder: (context, provid, child) => MultiSelectChipDisplay(
            onTap: (p0) async {
              if (p0.toLowerCase() == 'yes') {
                // user wants near by location services
                final position = await CommonFunctions.determinePosition();
                final long = position.longitude;
                final lat = position.latitude;

                qaPro.updateAnswers(
                    questionData: questionData,
                    newAnswer: '$long, $lat',
                    reset: true);
              } else {
                qaPro.updateAnswers(
                    questionData: questionData, newAnswer: p0, reset: true);
              }
            },
            icon: const Icon(
              Icons.balance_rounded,
            ),
            alignment: Alignment.center,
            items: questionData.options
                ?.map((e) => MultiSelectItem(e, e))
                .toList(),
            colorator: (p0) => provid.isSelected(questionData, p0)
                ? Colors.lightBlue
                : Colors.white,
            textStyle: const TextStyle(color: Colors.black),
          ),
        );
      case KEnumQuestionType.shortText:
        return TextFormField(
          onChanged: (value) {
            qaPro.updateAnswers(
                questionData: questionData, newAnswer: value, reset: true);
          },
          maxLength: 250,
          maxLines: 5,
          minLines: 5,
        );
      default:
        return Container();
    }
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
