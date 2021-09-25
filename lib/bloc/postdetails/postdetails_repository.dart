import 'package:dtube_go/bloc/postdetails/postdetails_response_model.dart';

import 'package:dtube_go/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class PostRepository {
  Future<Post> getPost(
      String apiNode, String author, String link, String applicationUser);
}

class PostRepositoryImpl implements PostRepository {
  @override
  Future<Post> getPost(String apiNode, String author, String link,
      String applicationUser) async {
    var response = await http.get(Uri.parse(apiNode +
        AppConfig.postDataUrl
            .replaceAll("##AUTHOR", author)
            .replaceAll("##LINK", link)));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      Post post = ApiResultModel.fromJson(data, applicationUser).post;
      return post;
    } else {
      throw Exception();
    }
  }
}
