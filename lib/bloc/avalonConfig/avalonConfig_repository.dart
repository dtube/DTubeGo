import 'package:dtube_togo/bloc/avalonConfig/avalonConfig_bloc_full.dart';

import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AvalonConfigRepository {
  Future<AvalonConfig> getAvalonConfig(
    String apiNode,
  );
}

class AvalonConfigRepositoryImpl implements AvalonConfigRepository {
  @override
  Future<AvalonConfig> getAvalonConfig(String apiNode) async {
    var response = await http.get(Uri.parse(apiNode + AppConfig.avalonConfig));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      AvalonConfig config = ApiResultModelAvalonConfig.fromJson(data).conf;
      return config;
    } else {
      throw Exception();
    }
  }
}
