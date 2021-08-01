import 'package:dtube_togo/bloc/accountHistory/accountHistory_response_model.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AccountHistoryRepository {
  Future<List<AvalonAccountHistoryItem>> getAccountHistory(
      String apiNode, List<int> accountHistoryTypes, String applicationUser);
}

class AccountHistoryRepositoryImpl implements AccountHistoryRepository {
  @override
  Future<List<AvalonAccountHistoryItem>> getAccountHistory(String apiNode,
      List<int> accountHistoryTypes, String applicationUser) async {
    // handling accountHistory types
    var response = await http.get(Uri.parse(apiNode +
        AppConfig.accountHistoryFeedUrl
            .replaceAll("##USERNAME", applicationUser)));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      // filter here for specfic accountHistory types
      List<AvalonAccountHistoryItem> historyItems =
          ApiResultModel.fromJson(data).accountHistorys;
      return historyItems;
    } else {
      throw Exception();
    }
  }
}
