import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chat GPT API tutorial'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _apiText;
  final apiKey ='your_api_key';//APIキーを入力する
  String searchText='';
  bool _roading=false;
  @override
  void initState() {
    super.initState();

    //callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  if(_roading==true){
                    return const Center(child: CircularProgressIndicator());
                  } else if(_apiText!=null){
                    return Text(
                      '$_apiText',
                      style: const TextStyle(fontSize: 16),
                    );
                  } else {
                    return const SizedBox(width: 0,height: 0,);
                  }
                }
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: '検索したいテキスト'
              ),
              onChanged: (text) {
                searchText=text;
              },
            ),
            ElevatedButton(onPressed: (){
              callAPI();
            }, 
            child: const Text('検索'),),
          ],
        ),
      ),
    );
  }

  void callAPI() async {
    setState(() {
      _roading=true;
    });
    final response =
        await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(<String, dynamic>{
              "model": "gpt-3.5-turbo",
              "messages": [
                {"role": "user", "content": searchText},
              ]
            }));
    final body = response.bodyBytes;
    final jsonString = utf8.decode(body);
    final json = jsonDecode(jsonString);
    final choices = json['choices'];
    final content = choices[0]['message']['content'];

    setState(() {
      _roading=false;
      _apiText = content;
    });
  }
}
