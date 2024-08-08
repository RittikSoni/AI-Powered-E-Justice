import 'package:e_justice_v2/const/ktheme.dart';
import 'package:e_justice_v2/providers/q_a_provider.dart';
import 'package:e_justice_v2/routes/kroutes.dart';
import 'package:e_justice_v2/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateAI extends StatefulWidget {
  const GenerateAI({super.key});

  @override
  State<GenerateAI> createState() => _SectionTextInputStreamState();
}

class _SectionTextInputStreamState extends State<GenerateAI> {
  final ImagePicker picker = ImagePicker();

  final gemini = Gemini.instance;
  String? question, _finishReason;

  String? get finishReason => _finishReason;

  set finishReason(String? set) {
    if (set != _finishReason) {
      setState(() => _finishReason = set);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provid =
          Provider.of<QAProvider>(navigatorKey.currentContext!, listen: false);

      question = provid.generateQuestion();

      gemini
          .streamGenerateContent(question!,
              modelName: 'models/gemini-1.5-flash-latest')
          .handleError((e) {
        if (e is GeminiException) {
          debugPrint(e.toString());
        }
      }).listen((value) {
        if (value.finishReason != 'STOP') {
          finishReason = 'Finish reason is `${value.finishReason}`';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedMeshGradient(
            colors: Ktheme.kmeshgrad4,
            options: AnimatedMeshGradientOptions(),
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        KRoute.pushRemove(context: context, page: const App());
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                ),
                Expanded(child: GeminiResponseTypeView(
                  builder: (context, child, response, loading) {
                    if (loading) {
                      return Center(
                        child: Lottie.asset('assets/lottie/ai.json'),
                      );
                    }

                    if (response != null) {
                      return Markdown(
                        onTapLink: (text, href, title) {
                          launchUrl(Uri.parse(href.toString()));
                        },
                        data: response,
                        selectable: true,
                      );
                    } else {
                      return const Center(child: Text('Search something!'));
                    }
                  },
                )),

                /// if the returned finishReason isn't STOP
                if (finishReason != null) Text(finishReason!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
