import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:telegram_clone/config/api.dart";
import "dart:convert";

import "package:telegram_clone/models/user.dart";

class AuthServices {
  bool isLoggedIn = false;

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString("id");
    if (userId != null) {
      return userId;
    } else {
      return null;
    }
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("id");
  }

  static Future<bool> login(String hp, String password) async {
    var response = await http.post(
      Uri.parse("${ApiServices.baseUrl}/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "hp": hp,
        "password": password,
      }),
    );

    if (jsonDecode(response.body)["status"] == 200) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            "id", jsonDecode(response.body)["user"]["id"].toString());
      } catch (e) {
        print("SharedPreferences error: $e");
      }

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> regist(User user) async {
    var response = await http.post(
      Uri.parse("${ApiServices.baseUrl}/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(user.toJson()),
    );

    if (jsonDecode(response.body)["status"] == 200) {
      return true;
    } else {
      return false;
    }
  }
}
