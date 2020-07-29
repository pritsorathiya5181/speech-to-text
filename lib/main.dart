import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Voice',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SpeechScreen());
  }
}
class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> highlights = {
    'flutter': HighlightedWord(
        onTap: () => print('flutter'),
        textStyle:
            const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
    'voice': HighlightedWord(
        onTap: () => print('voice'),
        textStyle:
            const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    'subscribe': HighlightedWord(
        onTap: () => print('subscribe'),
        textStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    'like': HighlightedWord(
        onTap: () => print('like'),
        textStyle: const TextStyle(
            color: Colors.blueAccent, fontWeight: FontWeight.bold)),
    'comment': HighlightedWord(
        onTap: () => print('comment'),
        textStyle:
            const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
  };

  stt.SpeechToText _speech;
  bool isListening = false;
  String text = 'Press the button and start listening';
  double confidence = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%',
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: TextHighlight(
            text: text,
            words: highlights,
            textStyle: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        repeat: true,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }

  void _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => print('Status: $val'),
          onError: (err) => print('Error: $err'));
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            text = val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence > 0){
              confidence = val.confidence;
            }
          }),
        );
      }
    }
    else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }
}