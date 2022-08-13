import 'package:path_provider/path_provider.dart';

Future<String> getFileUrl(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return "${directory.path}/$fileName";
}
