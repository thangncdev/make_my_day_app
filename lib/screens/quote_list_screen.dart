import 'package:flutter/material.dart';
import '../services/widget_service.dart';

class QuoteListScreen extends StatefulWidget {
  const QuoteListScreen({super.key});

  @override
  State<QuoteListScreen> createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  List<String> _quotes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() => _loading = true);
    final quotes = await WidgetService.getQuotes();
    setState(() {
      _quotes = quotes;
      _loading = false;
    });
  }

  void _deleteQuote(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(fontFamily: 'ShantellSans'),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa quote này không?',
          style: TextStyle(fontFamily: 'ShantellSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await WidgetService.deleteQuote(index);
      await _loadQuotes();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa quote!')));
    }
  }

  void _editQuote(int index) async {
    final controller = TextEditingController(text: _quotes[index]);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Sửa quote',
          style: TextStyle(fontFamily: 'ShantellSans'),
        ),
        content: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Quote',
          ),
          style: const TextStyle(fontFamily: 'ShantellSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && result != _quotes[index]) {
      await WidgetService.updateQuote(index, result);
      await _loadQuotes();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã cập nhật quote!')));
    }
  }

  void _pinQuote(int index) async {
    await WidgetService.pinQuote(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã ghim quote xuống widget!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quote đã lưu',
          style: TextStyle(fontFamily: 'ShantellSans'),
        ),
        elevation: 2,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _quotes.isEmpty
          ? Center(
              child: Text(
                'Chưa có quote nào.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontFamily: 'ShantellSans',
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _quotes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final quote = _quotes[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    title: Text(
                      quote,
                      style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: 'ShantellSans',
                            fontStyle: FontStyle.italic,
                            fontSize: 17,
                          ) ??
                          const TextStyle(fontFamily: 'ShantellSans'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.push_pin_rounded,
                            color: Colors.orange,
                          ),
                          tooltip: 'Ghim xuống widget',
                          onPressed: () => _pinQuote(index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Colors.blueAccent,
                          ),
                          tooltip: 'Sửa',
                          onPressed: () => _editQuote(index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Colors.redAccent,
                          ),
                          tooltip: 'Xóa',
                          onPressed: () => _deleteQuote(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
