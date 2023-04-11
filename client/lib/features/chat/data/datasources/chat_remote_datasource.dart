import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mochi/core/utils/server_url.dart';
import 'package:mochi/core/models/models.dart' as mochi_models;
import 'package:mochi/features/chat/domain/models/models.dart';
import '../repository/repository.dart';

class ChatRemoteDataSource {
  late String baseUrl;
  late String accessToken;

  ChatRemoteDataSource() {
    baseUrl = getServerUrl();
    _getAccessToken();
  }

  Future<void> _getAccessToken() async {
    accessToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }

  Future<List<Map<String, dynamic>>> getChats() async {
    await _getAccessToken();
    final response = await http.get(
      Uri.parse('${baseUrl}chats'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch chats');
  }

  Future<Map<String, dynamic>> getChat(
      List<mochi_models.User> recipients) async {
    await _getAccessToken();
    final response = await http.post(
        Uri.parse(
          '${baseUrl}chats/search',
        ),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'participants': jsonEncode(
            recipients.map((e) => e.id).toList(),
          ),
        });
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to create chat');
  }

  Future<Map<String, dynamic>> getChatById(Chat chat) async {
    await _getAccessToken();
    final response = await http.get(
      Uri.parse('${baseUrl}chats/${chat.id}'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch messages for chat');
  }

  Future<Map<String, dynamic>> newChat(
    Message message,
    List<mochi_models.User> recipients,
  ) async {
    await _getAccessToken();
    final response =
        await http.post(Uri.parse('${baseUrl}chats/new'), headers: {
      'Authorization': 'Bearer $accessToken'
    }, body: {
      'participants': jsonEncode(
        recipients.map((e) => e.id).toList(),
      ),
      'message': jsonEncode(MessageRepository.toJSON(message)),
    });
    if (response.statusCode == 201) {
      final dynamic data = jsonDecode(response.body);
      return data;
    }
    throw Exception('Failed to create chat');
  }

  Future<bool> sendMessage(Chat chat, Message message) async {
    await _getAccessToken();
    final response = await http.put(
      Uri.parse('${baseUrl}chats/send'),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: {
        'chatId': chat.id,
        'message': jsonEncode(
          MessageRepository.toJSON(message),
        ),
      },
    );
    return response.statusCode == 200 ? true : false;
  }

  Future<Map<String, dynamic>> addUser(
    mochi_models.User user,
    Chat chat,
  ) async {
    await _getAccessToken();
    final response = await http.put(
      Uri.parse('${baseUrl}chats/addUser'),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: {
        'chatId': chat.id,
        'uid': user.id,
      },
    );
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to add user to chat');
  }
}
