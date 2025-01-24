import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _url =
      'https://plantinfoutilityendpoints.onrender.com/generate-description';

  static Future<Map<String, dynamic>> submitImage(File imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse(_url))
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      return jsonDecode(responseData.body);
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
