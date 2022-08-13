import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/res/Config/APIUrlSchema.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AvalonConfigRepository {
  Future<AvalonConfig> getAvalonConfig(
    String apiNode,
  );
  Future<int> getAvalonAccountPrice(
    String accountName,
    String apiNode,
  );
}

class AvalonConfigRepositoryImpl implements AvalonConfigRepository {
  @override
  Future<AvalonConfig> getAvalonConfig(String apiNode) async {
    var response =
        await http.get(Uri.parse(apiNode + APIUrlSchema.avalonConfig));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      AvalonConfig config = ApiResultModelAvalonConfig.fromJson(data).conf;
      return config;
    } else {
      throw Exception();
    }
  }

  Future<int> getAvalonAccountPrice(String apiNode, String accountName) async {
    var response = await http.get(Uri.parse(apiNode +
        APIUrlSchema.accountPriceUrl.replaceAll("##USERNAME", accountName)));
    if (response.statusCode == 200) {
      var data = response.body;
      if (int.tryParse(data) != null) {
        return int.tryParse(data)!;
      } else {
        return 0;
      }
    } else {
      throw Exception();
    }
  }
}
