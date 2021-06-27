import 'package:dtube_togo/bloc/rewards/rewards_response_model.dart';
import 'package:dtube_togo/res/strings/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class RewardsRepository {
  Future<List<Reward>> getRewards(
      String apiNode, String applicationUser, String voteType);
}

class RewardRepositoryImpl implements RewardsRepository {
  @override
  Future<List<Reward>> getRewards(
      String apiNode, String applicationUser, String rewardState) async {
    var response = await http.get(Uri.parse(apiNode +
        AppStrings.rewardsUrl
            .replaceAll("##USERNAME", applicationUser)
            .replaceAll("##REWARDSTATE", rewardState)));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<Reward> rewardList = ApiResultModel.fromJson(data).rewardList;
      return rewardList;
    } else {
      throw Exception();
    }
  }
}
