import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static const String quotesCollection = 'quotes';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Thêm quote mới vào Firestore
  static Future<void> addQuote(String text) async {
    try {
      await _firestore.collection(quotesCollection).add({
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Quote saved to Firestore successfully');
    } catch (e) {
      print('Error adding quote to Firestore: $e');
    }
  }
}
