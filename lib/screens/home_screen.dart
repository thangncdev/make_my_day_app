import 'package:flutter/material.dart';
import '../services/widget_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  String _currentQuote = '';

  @override
  void initState() {
    super.initState();
    WidgetService.init();
    _loadCurrentQuote();
  }

  void _loadCurrentQuote() async {
    final text = await WidgetService.loadSavedText();
    setState(() {
      _currentQuote = text ?? '';
    });
  }

  void _saveQuote() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    await WidgetService.addQuote(text);
    setState(() {
      _currentQuote = text;
      _textController.clear();
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu quote và gửi xuống widget!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), elevation: 2),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Nhập quote muốn lưu và gửi xuống widget:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ShantellSans',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Quote mới',
                          ),
                          minLines: 1,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saveQuote,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text(
                              'Lưu & Gửi xuống Widget',
                              style: TextStyle(fontFamily: 'ShantellSans'),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Quote hiện tại:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ShantellSans',
                  ),
                ),
                const SizedBox(height: 12),
                if (_currentQuote.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      _currentQuote,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontFamily: 'ShantellSans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Text(
                    'Chưa có quote nào được lưu.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
