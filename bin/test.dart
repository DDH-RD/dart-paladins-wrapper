import '../lib/src/paladins.dart';

void main() {
  Paladins paladins = PaladinsBuilder()
    .setDevId(1234)
    .setAuthKey("1234")
    .build();

  paladins.getPlayer("Luziferium").then((value) => {
    print(value)
  });
}