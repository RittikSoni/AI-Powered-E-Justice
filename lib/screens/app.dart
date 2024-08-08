import 'dart:math';

import 'package:e_justice_v2/common/common_functions.dart';
import 'package:e_justice_v2/data/questions_data.dart';
import 'package:e_justice_v2/routes/kroutes.dart';
import 'package:e_justice_v2/screens/generate_ai.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  int pageAnimationDuration = 600;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe.builder(
            itemCount: questionsData.length,
            disableUserGesture: true,
            itemBuilder: (context, index) {
              final currentQuestion = questionsData[index];
              return AnimatedMeshGradient(
                colors: currentQuestion.bg,
                options: AnimatedMeshGradientOptions(),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              currentQuestion.question,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            CommonFunctions.getQuestionOptions(
                                questionData: currentQuestion)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            positionSlideIcon: 0.8,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            fullTransitionValue: 880,
            enableSideReveal: true,
            preferDragFromRevealedArea: true,
            enableLoop: false,
            ignoreUserGestureWhileAnimating: true,
          ),

          /// TRACKER DOT BUILDER

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List<Widget>.generate(questionsData.length, _buildDot),
                ),
              ],
            ),
          ),

          /// PREVIOUS BUTTON BUILDER

          liquidController.currentPage > 0
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextButton(
                      onPressed: () {
                        liquidController.animateToPage(
                          page: liquidController.currentPage - 1,
                          duration: pageAnimationDuration,
                        );
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.01),
                          foregroundColor: Colors.black),
                      child: const Text("Previous"),
                    ),
                  ),
                )
              : Container(),

          /// NEXT BUTTON BUILDER
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  if (liquidController.currentPage + 1 >
                      questionsData.length - 1) {
                    // LAST PAGE REACHED
                    KRoute.push(context: context, page: const GenerateAI());
                  } else {
                    liquidController.animateToPage(
                      page: liquidController.currentPage + 1,
                      duration: pageAnimationDuration,
                    );
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.01),
                    foregroundColor: Colors.black),
                child: const Text("Next"),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}
