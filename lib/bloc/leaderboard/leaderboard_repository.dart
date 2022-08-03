import 'package:dtube_go/bloc/leaderboard/leaderboard_response_model.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class LeaderboardRepository {
  Future<List<Leader>> getLeaderboard(String apiNode);
}

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  @override
  Future<List<Leader>> getLeaderboard(
    String apiNode,
  ) async {
    var response =
        await http.get(Uri.parse(apiNode + AppConfig.leaderboardUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<Leader> leaderboardList =
          ApiResultModel.fromJson(data).leaderboardList;

      return leaderboardList;
    } else {
      throw Exception();
    }
  }
}
