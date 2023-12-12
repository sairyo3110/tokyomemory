import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mapapp/model/Invitecode.dart';

Future<http.Response> createInviteCode(String userId) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/ivent');

  Map<String, dynamic> body = {
    'user_id': userId,
    'action': 'create_invite_code',
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  return response;
}

Future<http.Response> inputInviteCode(String userId, String? inviteCode) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/ivent');

  Map<String, dynamic> body = {
    'user_id': userId,
    "invite_code": inviteCode,
    "action": "save_used_invite_code",
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");

  return response;
}

Future<List<InviteCode>> fetchInviteCodes() async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/ivent');
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({'action': 'get_all_data'}),
  );

  if (response.statusCode == 200) {
    String responseBody = utf8.decode(response.bodyBytes);
    Map<String, dynamic> outerBody = json.decode(responseBody);
    Map<String, dynamic> innerBody = outerBody['body'];
    Map<String, dynamic> bodyDatas = json.decode(innerBody['body']);
    List<dynamic> bodyData = bodyDatas['invite_codes'];

    List<InviteCode> invitecode = bodyData.map((item) {
      return InviteCode.fromJson(item);
    }).toList();

    return invitecode;
  } else {
    throw Exception('Failed to load places');
  }
}

Future<List<UsedInviteCode>> fetchUsedInviteCodes() async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/ivent');
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({'action': 'get_all_data'}),
  );

  if (response.statusCode == 200) {
    String responseBody = utf8.decode(response.bodyBytes);
    Map<String, dynamic> outerBody = json.decode(responseBody);
    Map<String, dynamic> innerBody = outerBody['body'];
    Map<String, dynamic> bodyDatas = json.decode(innerBody['body']);
    List<dynamic> bodyData = bodyDatas['used_invite_codes'];
    print('bodyDate$bodyData');

    List<UsedInviteCode> usedinvitecode = bodyData.map((item) {
      return UsedInviteCode.fromJson(item);
    }).toList();

    return usedinvitecode;
  } else {
    throw Exception('Failed to load places');
  }
}
