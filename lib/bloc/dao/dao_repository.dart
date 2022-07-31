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

      return daoList;
    } else {
      throw Exception();
    }
  }
}
