



// This contains a dummy entry point, and is opted out
// @dart=2.9

//if bs58 is null safety we can remove this dirty workarround

import 'package:dtube_togo/realMain.dart';

void main() {
  // Can't use null safety features in this file
  realMain();
}
