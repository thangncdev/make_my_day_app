import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetService {
  static const String appGroupId = "group.com.thangnc.MessageBox";
  static const String iOSWidgetName = "MessageBox";
  static const String androidWidgetName = "MessageBox";
  static const String dataKey = "message_from_flutter_app";
  static const String listKey = "quotes_list";
  static const String pinnedQuoteKey = "pinned_quote";

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
    // Khi thêm quote mới, tự động ghim nó
    await saveTextAndUpdateWidget(text);
  }

  static Future<void> updateQuote(int index, String newText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final quotes = prefs.getStringList(listKey) ?? [];
    if (index >= 0 && index < quotes.length) {
      final oldText = quotes[index];
      quotes[index] = newText;
      await prefs.setStringList(listKey, quotes);

      // Kiểm tra xem quote được sửa có phải là quote đang được ghim không
      final pinnedQuote = prefs.getString(pinnedQuoteKey);
      if (pinnedQuote == oldText) {
        // Nếu sửa quote đang được ghim, cập nhật ghim
        await saveTextAndUpdateWidget(newText);
      }
    }
  }

  static Future<void> deleteQuote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final quotes = prefs.getStringList(listKey) ?? [];
    if (index >= 0 && index < quotes.length) {
      final deletedQuote = quotes[index];
      quotes.removeAt(index);
      await prefs.setStringList(listKey, quotes);

      // Kiểm tra xem quote bị xóa có phải là quote đang được ghim không
      final pinnedQuote = prefs.getString(pinnedQuoteKey);
      if (pinnedQuote == deletedQuote) {
        // Nếu xóa quote đang được ghim, ghim quote cuối cùng hoặc xóa ghim
        if (quotes.isNotEmpty) {
          await saveTextAndUpdateWidget(quotes.last);
        } else {
          // Không còn quote nào, xóa ghim
          await prefs.remove(pinnedQuoteKey);
          await prefs.remove(dataKey);
          await HomeWidget.saveWidgetData(dataKey, '');
          await HomeWidget.updateWidget(
            iOSName: iOSWidgetName,
            androidName: androidWidgetName,
          );
        }
      }
    }
  }

  static Future<String?> loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ưu tiên lấy quote đang được ghim
    final pinnedQuote = prefs.getString(pinnedQuoteKey);
    if (pinnedQuote != null && pinnedQuote.isNotEmpty) {
      return pinnedQuote;
    }
    // Nếu không có quote được ghim, lấy quote cuối cùng
    final quotes = prefs.getStringList(listKey) ?? [];
    return quotes.isNotEmpty ? quotes.last : null;
  }

  static Future<void> saveTextAndUpdateWidget(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(dataKey, text);
    await prefs.setString(pinnedQuoteKey, text);
    await HomeWidget.saveWidgetData(dataKey, text);
    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }

  static Future<void> pinQuote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final quotes = prefs.getStringList(listKey) ?? [];
    if (index >= 0 && index < quotes.length) {
      final quoteToPin = quotes[index];
      await saveTextAndUpdateWidget(quoteToPin);
    }
  }
}
