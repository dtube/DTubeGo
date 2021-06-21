import 'dart:math';

String randomPermlink(length) {
  var text = "";
  var possible = "abcdefghijklmnopqrstuvwxyz0123456789";
  Random random = new Random();
  for (var i = 0; i < length; i++)
    text += possible[random.nextInt(possible.length)];

  return text;
}
