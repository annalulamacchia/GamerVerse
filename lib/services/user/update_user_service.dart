import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UpdateUserService {
  static const String _baseUrl = "https://gamerversemobile.pythonanywhere.com";
  static const String _imgbbApiUrl = "https://api.imgbb.com/1/upload";
  static const String _imgbbApiKey = "ce85b3ddd83772dbecd1556c90f86d3e"; // Replace with your ImgBB API key

  // Function to upload image to ImgBB
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_imgbbApiUrl?key=$_imgbbApiKey'));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final decodedResponse = json.decode(responseData.body);
        return decodedResponse['data']['url']; // The public URL of the uploaded image
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to update user profile
  static Future<Map<String, dynamic>> updateUser(Map<String, dynamic> userData, {File? profileImage}) async {
    String? profilePictureUrl;

    // Upload image if provided
    if (profileImage != null) {
      profilePictureUrl = await uploadImage(profileImage);
      if (profilePictureUrl == null) {
        return {'success': false, 'message': 'Failed to upload profile picture'};
      }
      userData['profile_picture'] = profilePictureUrl;
    }

    // Send update request to server
    final url = Uri.parse("$_baseUrl/update-profile");
    print(jsonEncode(userData));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      print('Failed to update user: ${response.statusCode}');
      return {'success': false, 'message': response.body};
    }
  }
}
