import 'package:flutter/material.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translattr/Presentation/HomePage/controller/controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  bool _speechEnabled = false;
  late TextToSpeech tts;
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initialiseSpeechModel();
    _initialisetts();
  }

  void _initialiseSpeechModel() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _initialisetts() {
    tts = TextToSpeech();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'ml_');
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    text.value = result.recognizedWords;
  }

  final st = SimplyTranslator(EngineType.google);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ValueListenableBuilder(
                valueListenable: text,
                builder: (context, value, _) {
                  return Text(
                    _speechToText.isNotListening ? value : 'Tap the mic',
                    style: const TextStyle(fontSize: 25),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ValueListenableBuilder(
                  valueListenable: translated,
                  builder: (context, value, _) {
                    return Text(
                      translated.value,
                      style: const TextStyle(
                          fontSize: 25, overflow: TextOverflow.fade),
                    );
                  }),
            ),
            const SizedBox(
              height: 300,
            ),
            IconButton(
              onPressed: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening,
              icon: const Icon(
                Icons.mic,
                size: 50,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            IconButton(
                onPressed: () async {
                  var stTransl = await st.translateSimply(
                    text.value,
                    instanceMode: InstanceMode.Same,
                  );
                  translated.value = stTransl.translations.text;
                  tts.speak(translated.value);
                },
                icon: const Icon(
                  Icons.translate,
                  size: 50,
                )),
          ],
        ),
      ),
    );
  }
}
