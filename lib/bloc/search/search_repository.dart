import 'package:dtube_togo/bloc/search/search_response_model.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class SearchRepository {
  Future<List<SearchResult>> getSearchResults(String searchQuery);
}

class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<List<SearchResult>> getSearchResults(String searchQuery) async {
    // handling notification types
    var response = await http.get(Uri.parse(
        AppConfig.searchAccountsUrl.replaceAll('##SEARCHSTRING', searchQuery)));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      // filter here for specfic notification types
      List<SearchResult> results = ApiResultModel.fromJson(data).searchResults;
      return results;
    } else {
      throw Exception();
    }
  }
}
