import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefCache {
  static const String _key = "cacheData";

  static Future<List<Map<String, dynamic>>> listData() async {
    print('listData');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the JSON string
    String? jsonString = prefs.getString(_key);
    
    print('jsonString: $jsonString');

    if (jsonString != null) {
      // Decode the JSON string back to a Map
      Map<String, dynamic> dataMap = json.decode(jsonString);
      // Convert the Map to a List of Maps
      List<Map<String, dynamic>> dataList = [];
      dataMap.forEach((key, value) {
        dataList.add({key: value});
      });
      return dataList;
    } else {
      return []; // Return an empty list if no data is found
    }
  }

  static Future<void> storeData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert data to JSON string
    String jsonString = json.encode(data);
    await prefs.setString(_key, jsonString);
  }
}