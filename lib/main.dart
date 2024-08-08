import 'package:e_justice_v2/firebase_options.dart';
import 'package:e_justice_v2/providers/q_a_provider.dart';
import 'package:e_justice_v2/routes/kroutes.dart';
import 'package:e_justice_v2/screens/app.dart';
import 'package:e_justice_v2/widgets/no_api_key_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? geminiAPIKey = dotenv.env['GEMINI_API_KEY'];
  if (geminiAPIKey != null) {
    Gemini.init(
      apiKey: geminiAPIKey,
    );
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => QAProvider(),
          ),
        ],
        builder: (context, child) {
          return const GemApp();
        },
      ),
    );
  } else {
    runApp(const NoApiKeyFoundScreen());
  }
}

class GemApp extends StatelessWidget {
  const GemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const App(),
    );
  }
}
