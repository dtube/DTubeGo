import 'dart:math';

int generateRandom(int min, int max) {
  var _rn = new Random();
  var _randomInt = min + _rn.nextInt(max - min);
  print(_randomInt);
  return _randomInt;
}
