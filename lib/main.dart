import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp( MyApp());
}
var o3dController = O3DController();
var textController = TextEditingController();
var text = 'انا عينة من تصميم بدر الدين المصري';
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterTts = FlutterTts();


  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            O3D(src: 'assets/talking.glb',
            ar: false,
            controller:o3dController,
            animationName: 'mixamo.com',
            autoPlay: false,
            disableZoom: true,
            disableTap: true,
            disablePan: true,
            cameraControls: false,
            autoRotate: false,),
            Row(
              children: [
                ElevatedButton(onPressed: (){
                 o3dController.pause();
                  o3dController.animationName=null;
                 // setState(() {});
                }, child: Text("stop")),
                ElevatedButton(onPressed: (){
                 o3dController.play();
                  o3dController.animationName='mixamo.com';
                 // setState(() {});
                }, child: Text("start")),
                ElevatedButton(onPressed: () async {
                  o3dController.play();
                  o3dController.animationName='mixamo.com';
                  flutterTts.setLanguage('ar-001');
                  flutterTts.setSpeechRate(0.8);
                  flutterTts.speak(text);
                  flutterTts.completionHandler = ((){
                    o3dController.pause();
                    o3dController.animationName=null;
                  });
                }, child: Text("Sound 1")),
                ElevatedButton(onPressed: (){
                  postRequest("مرحبا").then((value) async {
                    print(value);
                    print(value['URL']);
                    final player = AudioPlayer();
                    await player.play(UrlSource(value['URL'])).then((value) { o3dController.play(); o3dController.animationName='mixamo.com';});
                    player.onPlayerComplete.listen((event) {
                      o3dController.pause();
                      o3dController.animationName=null;
                    });
                  });
                }, child: Text("Sound 2")),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<Map<String, dynamic>> postRequest(String msg) async {
    var body = json.encode({
      'msg': msg,
      'lang':'Zeina',
      'source':'ttsmp3'
    });

    print('Body: $body');

    var response = await http.post(
      Uri.parse("https://ttsmp3.com/makemp3_new.php"),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': '__gads=ID=46041a83d8ee5847:T=1701648994:RT=1701648994:S=ALNI_MbHva5US9bFJ1Lo2Xv0onIzGvSAKA; __gpi=UID=00000ce2b8cac9a2:T=1701648994:RT=1701648994:S=ALNI_MYbsmQfYreMalUOvc5E7q6LZMblAA; _gid=GA1.2.244296921.1701649063; _ga=GA1.1.986968977.1701648994; _fbp=fb.1.1701649064360.347453148; __stripe_mid=b35582c7-8fac-4120-9e9c-2e3e4c63e451456bf4; __stripe_sid=12fa7ccd-ec6d-41c2-9bf7-6b68bfad0b11b02bb5; _ga_H0XGBVF70F=GS1.1.1701648993.1.1.1701649088.0.0.0' ,
         'Origin': 'https://ttsmp3.com' ,
         'Referer': 'https://ttsmp3.com/text-to-speech/Arabic/' 
      },
        body:  'msg=$text&lang=Zeina&source=ttsmp3' ,
    //  body:  'msg=%22%D9%85%D8%B1%D8%AD%D8%A8%D8%A7%20%20%20%D8%A7%D9%86%D8%A7%20%20%20%D8%B9%D9%8A%D9%86%D8%A9%20%20%20%D9%85%D9%86%20%20%20%D8%AA%D8%B5%D9%85%D9%8A%D9%85%20%20%20%20%D8%A8%D8%AF%D8%B1%20%20%20%D8%A7%D9%84%D8%AF%D9%8A%D9%86%20%20%20%D8%A7%D9%84%D9%85%D8%B5%D8%B1%D9%8A%22&lang=Zeina&source=ttsmp3' ,
    );
    
    return json.decode(response.body);
  }
}

