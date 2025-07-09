import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  String appGroupId = "group.com.victoryverse.flutterkit";
  String iOSWidgetName = "HomeWidgetExtension";
  String androidWidgetName = "HomeWidgetExtension";
  String dataKey = "text_from_flutter_app";
  TextEditingController _textController = TextEditingController();
  String _savedText = '';

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);
    _loadSavedText();
  }

  void _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? text = prefs.getString(dataKey);
    if (text != null) {
      setState(() {
        _savedText = text;
        _textController.text = text;
      });
    }
  }

  void _saveTextAndUpdateWidget() async {
    String text = _textController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(dataKey, text);
    setState(() {
      _savedText = text;
    });
    await HomeWidget.saveWidgetData(dataKey, text);
    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Nhập nội dung muốn gửi xuống widget:'),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nội dung',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _saveTextAndUpdateWidget,
              child: const Text('Lưu & Gửi xuống Widget'),
            ),
            const SizedBox(height: 24),
            const Text('Nội dung đã lưu:'),
            Text(_savedText, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
