import 'session.dart';
import 'session_cache.dart';

import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Paladins {
  SessionCache sessionCache = SessionCache();

  int devId;
  String authKey;

  Paladins._({required this.devId, required this.authKey});

  factory Paladins(PaladinsBuilder builder) {
    return Paladins._(devId: builder.devId, authKey: builder.authKey);
  }

  Future<Session> createSession() async {
    dynamic response = await requestSession();
    Session session = Session(sessionId: response["session_id"]);

    sessionCache.addSession(session.sessionId);
    return session;
  }

  Future<dynamic> requestSession() async {
    String url = buildSessionUrl();
    print("Request -> $url");
    var response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });
    return jsonDecode(response.body);
  }

  Future<dynamic> requestEndpoint(Endpoint endpoint, Session session, List<String> args) async {
    String url = buildUrl(endpoint, session, args);
    print("Request -> $url");
    var response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });
    return jsonDecode(response.body);
  }

  String buildSessionUrl() {
    String timestamp = getTimeStamp();
    String signature = getSignature(devId, "createsession", authKey);
    return Endpoint.SESSION.getUrl() + "/$devId/$signature/$timestamp";
  }

  String buildUrl(Endpoint endpoint, Session session, List<String> args) {
    String timestamp = getTimeStamp();
    String signature = getSignature(devId, endpoint.endpoint, authKey);
    return endpoint.getUrl() + "/$devId/$signature/${session.sessionId}/$timestamp/${args.join("/")}";
  }

  String getSignature(int devId, String method, String authKey) {
    try {
      String timestamp = getTimeStamp();
      String signature = devId.toString() + method + authKey + timestamp;

      Digest digest = md5.convert(Uint8List.fromList(utf8.encode(signature)));

      StringBuffer buffer = StringBuffer();
      for (int byte in digest.bytes) {
        buffer.write(byte.toRadixString(16).padLeft(2, '0'));
      }
      return buffer.toString();
    } catch (e) {
      print(e);
    }
    return '';
  }

  String getTimeStamp() {
    DateFormat formatter = DateFormat('yyyyMMddHHmmss');
    return formatter.format(DateTime.now().toUtc());
  }
}

class PaladinsBuilder {
  int devId = -1;
  String authKey = "";

  PaladinsBuilder setDevId(int devId) {
    this.devId = devId;
    return this;
  }

  PaladinsBuilder setAuthKey(String authKey) {
    this.authKey = authKey;
    return this;
  }

  Paladins build() {
    return Paladins._(devId: devId, authKey: authKey);
  }
}

class Endpoint {
  static const String BASE_URL = "https://api.paladins.com/paladinsapi.svc/";
  final String endpoint;

  const Endpoint(this.endpoint);

  String getUrl() {
    return BASE_URL + endpoint;
  }

  static const SESSION = Endpoint("createsessionJson");
  static const PLAYER = Endpoint("getplayer");
}