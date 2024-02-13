import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final SpeechToText _speechToText = SpeechToText();
bool speechEnabled = false;
String textResult = "";
bool isStart = false;
 final translator = GoogleTranslator();
 FlutterTts flutterTts = FlutterTts();
 bool isTranslated = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
  }

void initSpeech() async {
  speechEnabled = await _speechToText.initialize();
  
  setState(() {});
}

void startSpeech() async{
  await _speechToText.listen(onResult: resultSpeech);
  setState(() {
    isTranslated = false;
    isStart = true;
  });
}

void stopSpeech() async {
  await _speechToText.stop();
  setState(() {
    isStart = false;
  });
   
}

void resultSpeech(SpeechRecognitionResult result) async{
setState(() {
  textResult = result.recognizedWords;
});
}

Future<void> speak(String text) async {
await flutterTts.setLanguage("id-ID"); // Kode bahasa Indonesia
  await flutterTts.setPitch(1.0); // Nilai pitch
  await flutterTts.setSpeechRate(0.3); // Nilai kecepatan
  await flutterTts.setVolume(1.0);
  await flutterTts.speak(text);
}

void speech() async{
  //Su = Sunda
  //Jv = Jawa
if(isTranslated == false){
   var translation = await translator.translate(textResult, from:'id', to: 'jv');
    setState(() {
      textResult = translation.text;
    });
    isTranslated = true;
}
    speak(textResult);

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speech To Text")),
      body: Center(
        child: Column(children: [
          Text((isTranslated == true) ? textResult + " [Translated]" : textResult),
          isStart ? ElevatedButton(onPressed: (){
            stopSpeech();
          }, child: Text("Stop Voice", style: TextStyle(color: Colors.red),)) : ElevatedButton(onPressed: (){
            startSpeech();
          }, child: Text("Start Voice", style: TextStyle(color: Colors.green),)),
          (textResult != "") ? ElevatedButton(onPressed: (){
            speech();
          }, child: Text("Play Voice", style: TextStyle(color: Colors.blue),)) :
          Container()
        ]),
      ),
    );
  }
}