import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class FeedRepository {
  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser,
      String? fromAuthor, String? fromLink);
  Future<List<FeedItem>> getHotFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getTrendingFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getNewFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getUserFeed(
    String apiNode,
    String username,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getNewFeedFiltered(
    String apiNode,
    String filterString,
    String applicationUser,
  );
  Future<List<FeedItem>> getMyFeedFiltered(
    String apiNode,
    String filterString,
    String applicationUser,
  );
}

class FeedRepositoryImpl implements FeedRepository {
  @override

//moments feeds

  Future<List<FeedItem>> getNewFeedFiltered(
    String apiNode,
    String filterString,
    String applicationUser,
  ) async {
    String _url = apiNode +
        AppConfig.newFeedUrlFiltered.replaceAll("##FILTERSTRING", filterString);

    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;

      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getMyFeedFiltered(
    String apiNode,
    String filterString,
    String applicationUser,
  ) async {
    String _url = apiNode +
        AppConfig.myFeedUrlFiltered
            .replaceAll("##USERNAME", applicationUser)
            .replaceAll("##FILTERSTRING", filterString);

    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  // common feeds

  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser,
      String? fromAuthor, String? fromLink) async {
    String _url = apiNode +
        AppConfig.myFeedUrlFirst.replaceAll("##USERNAME", applicationUser);
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.myFeedUrlMore
              .replaceAll("##USERNAME", applicationUser)
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }

    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getHotFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  ) async {
    String _url = apiNode + AppConfig.hotFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.hotFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getTrendingFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  ) async {
    String _url = apiNode + AppConfig.trendingFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.trendingFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getNewFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  ) async {
    String _url = apiNode + AppConfig.newFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.newFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;

      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getUserFeed(String apiNode, String username,
      String? fromAuthor, String? fromLink, String applicationUser) async {
    String _url = apiNode +
        AppConfig.accountFeedUrlFirst.replaceAll("##USERNAME", username);
    if (fromLink != null) {
      _url = apiNode +
          AppConfig.accountFeedUrlMore
              .replaceAll("##USERNAME", username)
              .replaceAll("##AUTHORNAME", username)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;
      return feed;
    } else {
      throw Exception();
    }
  }
}
