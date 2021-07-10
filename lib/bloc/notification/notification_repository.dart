import 'package:dtube_togo/bloc/notification/notification_response_model.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class NotificationRepository {
  Future<List<AvalonNotification>> getNotifications(
      String apiNode, List<int> notificationTypes, String applicationUser);
}

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<List<AvalonNotification>> getNotifications(String apiNode,
      List<int> notificationTypes, String applicationUser) async {
    // handling notification types
    var response = await http.get(Uri.parse(apiNode +
        AppConfig.notificationFeedUrl
            .replaceAll("##USERNAME", applicationUser)));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      // filter here for specfic notification types
      List<AvalonNotification> posts =
          ApiResultModel.fromJson(data).notifications;
      return posts;
    } else {
      throw Exception();
    }
  }
}
