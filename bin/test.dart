import '../lib/paladins.dart';

void main() {
  Paladins paladins = PaladinsBuilder()
    .setDevId(1234)
    .setAuthKey("1234")
    .build();

  paladins.createSession().then((session) {
    print(session.sessionId);
  });
}