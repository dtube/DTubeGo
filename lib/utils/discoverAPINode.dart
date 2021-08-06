import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:http/http.dart' as http;

import 'dart:collection';

Future<String> discoverAPINode() async {
  var _nodes = AppConfig.apiNodes;
  Map<String, int> _nodeResponses = {};
  Map<String, int> _sortedApiNodesByResponseTime = {};

  for (var node in _nodes) {
    var _beforeRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;
    var response = await http
        .get(Uri.parse(node + '/count'))
        .timeout(Duration(seconds: 1), onTimeout: () {
      // Time has run out, do what you wanted to do.
      return http.Response('Error', 500); // Replace 500 with your http code.
    });
    if (response.statusCode == 200) {
      var _afterRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;

      _nodeResponses[node] =
          _afterRequestMicroSeconds - _beforeRequestMicroSeconds;
    }
  }
  _sortedApiNodesByResponseTime = SplayTreeMap.from(_nodeResponses,
      (key1, key2) => _nodeResponses[key1]!.compareTo(_nodeResponses[key2]!));
  return _sortedApiNodesByResponseTime.entries.toList()[0].key;
}
