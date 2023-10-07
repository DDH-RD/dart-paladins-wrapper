class SessionCache {

  Map<String, int> _sessionCache = Map();

  void addSession(String sessionId) {
    _sessionCache[sessionId] = DateTime.now().millisecondsSinceEpoch;
  }

  bool hasSession(String sessionId) {
    return _sessionCache.containsKey(sessionId);
  }

  bool isSessionExpired(String sessionId) {
    return DateTime.now().millisecondsSinceEpoch - _sessionCache[sessionId]! > 15 * 60 * 1000;
  }

  int? getSession(String sessionId) {
    return _sessionCache[sessionId];
  }

  void removeSession(String sessionId) {
    _sessionCache.remove(sessionId);
  }
}