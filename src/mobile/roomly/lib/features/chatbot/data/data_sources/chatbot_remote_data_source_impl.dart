import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chatbot_request.dart';
import '../models/chatbot_response.dart';
import '../models/chatbot_room_image.dart';
import 'chatbot_remote_data_source.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final http.Client client;
  static const String chatbotBaseUrl = 'https://mostafaabdelkawy-roomly-chatbot.hf.space';
  static const String roomImageBaseUrl = 'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/images';

  ChatbotRemoteDataSourceImpl({required this.client});

  @override
  Future<ChatbotResponse> sendMessage(ChatbotRequest request) async {
    final response = await client.post(
      Uri.parse('$chatbotBaseUrl/chat'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ChatbotResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }

  @override
  Future<List<RoomImage>> getRoomImages(String roomId) async {
    final response = await client.get(
      Uri.parse('$roomImageBaseUrl/room?roomId=$roomId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((image) => RoomImage.fromJson(image)).toList();
    } else {
      throw Exception('Failed to get room images: ${response.statusCode}');
    }
  }
}

