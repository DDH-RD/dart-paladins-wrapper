import 'session.dart';
import 'session_cache.dart';
import 'endpoint.dart';
import 'player.dart';

import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class Paladins {
  SessionCache sessionCache = SessionCache();

  int devId;
  String authKey;

  Paladins._({required this.devId, required this.authKey});

  factory Paladins(PaladinsBuilder builder) {
    Paladins paladins = Paladins._(devId: builder.devId, authKey: builder.authKey);
    paladins.scheduleSessionValidator(10*60*1000); // 10 minutes
    return paladins;
  }

  Future<List<Player>> getPlayer(String name) async {
    Session session = await _getAndValidateLatestSession();
    dynamic response = await _requestEndpoint(Endpoint.PLAYER, session, [name]);

    List<Player> players = [];
    for (dynamic player in response) {
      players.add(Player.fromJson(player));
    }
    return players;
  }

  Timer scheduleSessionValidator([int milliseconds = 10000]) =>
    Timer.periodic(Duration(milliseconds: milliseconds), (Timer t) => _getAndTestLatestSession());

  Future<Session> _getAndTestLatestSession() async {
    if (sessionCache.hasSessions()) {
      String sessionId = sessionCache.getLatestSession();
      if (!sessionCache.isSessionExpired(sessionId)) {
        Session session = Session(sessionId: sessionId);
        http.Response response = await _requestEndpoint(Endpoint.TEST_SESSION, session, []);
        if(response.statusCode == 200) {
          return session;
        }
        sessionCache.removeSession(sessionId);
      } else {
        sessionCache.removeSession(sessionId);
      }
    }

    return await _requestNewSession();
  }

  Future<Session> _getAndValidateLatestSession() async {
    if (sessionCache.hasSessions()) {
      String sessionId = sessionCache.getLatestSession();
      if (!sessionCache.isSessionExpired(sessionId)) {
        return Session(sessionId: sessionId);
      } else {
        sessionCache.removeSession(sessionId);
      }
    }

    return await _requestNewSession();
  }

  Future<Session> _requestNewSession() async {
    dynamic response = await _requestSession();
    Session session = Session(sessionId: response["session_id"]);

    sessionCache.addSession(session.sessionId);
    return session;
  }

  Future<http.Response> _request(String url) async {
    print("Request -> $url");

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });

    print("Response -> ${response.statusCode}");
    return response;
  }

  Future<dynamic> _requestSession() async {
    String url = _buildSessionUrl();

    http.Response response = await _request(url);
    return jsonDecode(response.body);
  }

  Future<dynamic> _requestEndpoint(Endpoint endpoint, Session session, List<String> args) async {
    String url = _buildUrl(endpoint, session, args);

    http.Response response = await _request(url);
    return jsonDecode(response.body);
  }

  String _buildSessionUrl() {
    String timestamp = _getTimeStamp();
    String signature = _getSignature(devId, "createsession", authKey);
    return Endpoint.SESSION.getUrl() + "/$devId/$signature/$timestamp";
  }

  String _buildUrl(Endpoint endpoint, Session session, List<String> args) {
    String timestamp = _getTimeStamp();
    String signature = _getSignature(devId, endpoint.endpoint.replaceAll("Json", ""), authKey);
    return endpoint.getUrl() + "/$devId/$signature/${session.sessionId}/$timestamp/${args.join("/")}";
  }

  String _getSignature(int devId, String method, String authKey) {
    try {
      String timestamp = _getTimeStamp();
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

  String _getTimeStamp() {
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