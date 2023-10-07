class Endpoint {
  static const String BASE_URL = "https://api.paladins.com/paladinsapi.svc/";
  final String endpoint;

  const Endpoint(this.endpoint);

  String getUrl() {
    return BASE_URL + endpoint;
  }

  static const SESSION = Endpoint("createsessionJson");
  static const PLAYER = Endpoint("getplayerJson");
}