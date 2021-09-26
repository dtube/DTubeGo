import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/bloc/search/search_response_model.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class SearchRepository {
  Future<SearchResults> getSearchResults(String searchQuery,
      String searchEntity, String apiNode, String currentUser);
}

class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<SearchResults> getSearchResults(String searchQuery,
      String searchEntity, String apiNode, String currentUser) async {
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

    String _searchURL = "";
    switch (searchEntity) {
      case "Users":
        _searchURL = AppConfig.searchAccountsUrl
            .replaceAll('##SEARCHSTRING', searchQuery);
        break;
      case "Posts":
        _searchURL =
            AppConfig.searchPostsUrl.replaceAll('##SEARCHSTRING', searchQuery);
        break;
      default:
    }
    var response = await http.get(Uri.parse(_searchURL));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      // filter here for specfic notification types
      SearchResults results =
          SearchResults.fromJson(data, vpGrowth, currentUser);
      return results;
    } else {
      throw Exception();
    }
  }
}
