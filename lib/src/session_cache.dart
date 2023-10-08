class SessionCache {

  Map<String, int> _sessionCache = Map();

  void addSession(String sessionId) {
    _sessionCache[sessionId] = DateTime.now().millisecondsSinceEpoch;
  }

  bool hasSessions() {
    return _sessionCache.isNotEmpty;
  }

  bool hasSession(String sessionId) {
    return _sessionCache.containsKey(sessionId);
  }

  bool isSessionExpired(String sessionId) {
    return DateTime.now().millisecondsSinceEpoch - _sessionCache[sessionId]! > 15 * 60 * 1000;
  }

  String getLatestSession() {
    return _sessionCache.keys.last;
  }

  void removeSession(String sessionId) {
    _sessionCache.remove(sessionId);
  }
}