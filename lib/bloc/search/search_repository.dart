import 'package:dtube_togo/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_togo/bloc/search/search_response_model.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class SearchRepository {
  Future<SearchResults> getSearchResults(String searchQuery, String apiNode);
}

class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<SearchResults> getSearchResults(
      String searchQuery, String apiNode) async {
    int vpGrowth = 0;
    var configResponse =
        await http.get(Uri.parse(apiNode + AppConfig.avalonConfig));
    if (configResponse.statusCode == 200) {
      var configData = json.decode(configResponse.body);
      AvalonConfig conf = ApiResultModelAvalonConfig.fromJson(configData).conf;
      vpGrowth = conf.vtGrowth;
    } else {
      throw Exception();
    }

    var response = await http.get(Uri.parse(
        AppConfig.searchAccountsUrl.replaceAll('##SEARCHSTRING', searchQuery)));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      // filter here for specfic notification types
      SearchResults results = SearchResults.fromJson(data, vpGrowth);
      return results;
    } else {
      throw Exception();
    }
  }
}
