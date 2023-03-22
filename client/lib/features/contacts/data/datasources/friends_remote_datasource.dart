import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FriendsRemoteDataSource {
  late String baseUrl;
  late String accessToken;

  FriendsRemoteDataSource() {
    baseUrl = dotenv.env['ENV'] == 'local'
        ? dotenv.env['LOCAL_SERVER']!
        : dotenv.env['ENV'] == 'dev'
            ? dotenv.env['DEV_SERVER']!
            : dotenv.env['PROD_SERVER']!;
    _getAccessToken();
  }

  Future<void> _getAccessToken() async {
    accessToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    await _getAccessToken();
    final response = await http.get(
      Uri.parse('${baseUrl}users/friends'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch friends');
  }

  Future<List<Map<String, dynamic>>> getIncomingRequests() async {
    await _getAccessToken();
    final response = await http.get(
      Uri.parse('${baseUrl}users/requests/in'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch incoming requests');
  }

  Future<List<Map<String, dynamic>>> getOutgoingRequests() async {
    await _getAccessToken();
    final response = await http.get(
      Uri.parse('${baseUrl}users/requests/out'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch outcoming requests');
  }

  Future<String> sendFriendRequest(String id) async {
    await _getAccessToken();
    final response = await http.post(
      Uri.parse('${baseUrl}sendFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'uid': id}),
    );

    if (response.statusCode == 200) {
      return 'Friend request sent';
    }
    return 'Failed to send friend request';
  }

  Future<List<Map<String, dynamic>>> handleFriendRequest(
      String id, bool accept) async {
    await _getAccessToken();
    final response = await http.post(
      Uri.parse('${baseUrl}handleFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'uid': id,
        'accept': accept,
      }),
    );

    if (response.statusCode < 400) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to handle friend request');
  }

  Future<List<Map<String, dynamic>>> cancelFriendRequest(String id) async {
    await _getAccessToken();
    final response = await http.post(
      Uri.parse('${baseUrl}cancelFriendRequest'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'uid': id,
      }),
    );
    if (response.statusCode < 400) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to handle friend request');
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    await _getAccessToken();
    final response = await http.post(Uri.parse('${baseUrl}users/find'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'query': query,
        }));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch friends');
  }
}
