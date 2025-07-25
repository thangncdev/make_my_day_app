import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetService {
  static const String appGroupId = "group.com.thangnc.MessageBox";
  static const String iOSWidgetName = "MessageBox";
  static const String androidWidgetName = "MessageBox";
  static const String dataKey = "message_from_flutter_app";
  static const String listKey = "quotes_list";

  static void init() {
    HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<List<String>> getQuotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(listKey) ?? [];
  }

  static Future<void> addQuote(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final quotes = prefs.getStringList(listKey) ?? [];
    quotes.add(text);
    await prefs.setStringList(listKey, quotes);
    await saveTextAndUpdateWidget(text);
  }

  static Future<void> updateQuote(int index, String newText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final quotes = prefs.getStringList(listKey) ?? [];
    if (index >= 0 && index < quotes.length) {
      quotes[index] = newText;
      await prefs.setStringList(listKey, quotes);
      if (index == quotes.length - 1) {
        await saveTextAndUpdateWidget(newText);
      }
    }
  }

  static Future<void> deleteQuote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final quotes = prefs.getStringList(listKey) ?? [];
    if (index >= 0 && index < quotes.length) {
      quotes.removeAt(index);
      await prefs.setStringList(listKey, quotes);
      // Nếu xóa quote cuối, cập nhật widget
      if (index == quotes.length) {
        final last = quotes.isNotEmpty ? quotes.last : '';
        await saveTextAndUpdateWidget(last);
      }
    }
  }

  static Future<String?> loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final quotes = prefs.getStringList(listKey) ?? [];
    return quotes.isNotEmpty ? quotes.last : null;
  }

  static Future<void> saveTextAndUpdateWidget(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(dataKey, text);
    await HomeWidget.saveWidgetData(dataKey, text);
    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }
}
