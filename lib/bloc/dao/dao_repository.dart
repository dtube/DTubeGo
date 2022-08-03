import 'package:dtube_go/bloc/dao/dao_response_model.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class DaoRepository {
  Future<List<DAOItem>> getDao(
      String apiNode, String applicationUser, String voteType);
}

class DaoRepositoryImpl implements DaoRepository {
  @override
  Future<List<DAOItem>> getDao(
      String apiNode, String daoStatus, String daoType) async {
    var response = await http.get(Uri.parse(apiNode +
        AppConfig.daoUrl
            .replaceAll("##STATUS", daoStatus)
            .replaceAll("##TYPE", daoType)));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<DAOItem> daoList = ApiResultModel.fromJson(data).daoList;
      int daoListId = 0;
      for (var daoItem in daoList) {
        var votesResponse = await http.get(Uri.parse(apiNode +
            AppConfig.daoVotesUrl
                .replaceAll("##DAOID", daoItem.iId.toString())));

        if (votesResponse.statusCode == 200) {
          var voteData = json.decode(votesResponse.body);
          daoList[daoListId].votes =
              ApiVoteResultModel.fromJson(voteData).daoVoteList;

          if (daoList[daoListId].votes != null) {
            String voters = "";
            for (var element in daoList[daoListId].votes!) {
              voters = voters + element.voter!;
            }
            daoList[daoListId].voters = voters;
          }
        } else {
          throw Exception();
        }
        daoListId = daoListId + 1;
      }

      return daoList;
    } else {
      throw Exception();
    }
  }
}
