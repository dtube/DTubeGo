import 'package:dtube_go/res/appConfigValues.dart';
import 'package:http/http.dart' as http;

import 'dart:collection';

// Automatic node descovery based on their response time to request /count
Future<String> discoverAPINode() async {
  var _nodes = AppConfig.apiNodes;
  //if we are using experimental features aka not merged PRs then this will get executed
  if (AppConfig.useDevNodes) {
    _nodes = AppConfig.apiNodesDev;
  }

  Map<String, int> _nodeResponses = {};
  Map<String, int> _sortedApiNodesByResponseTime = {};
  // as long as we do not have received any response within the configured timeout
  // TODO: do this only for X times and then responde to the user about missing internet or blockchain issues
  do {
    // check response time of each node
    for (var node in _nodes) {
      print("checking " + node);
      try {
        var _beforeRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;
        var response = await http
            .get(Uri.parse(node + '/count'))
            .timeout(AppConfig.nodeDescoveryTimeout, onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
        });
        if (response.statusCode == 200) {
          var _afterRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;

          _nodeResponses[node] =
              _afterRequestMicroSeconds - _beforeRequestMicroSeconds;
        }
      } catch (e) {}
    }
    // sort all responses by their response time
    _sortedApiNodesByResponseTime = SplayTreeMap.from(_nodeResponses,
        (key1, key2) => _nodeResponses[key1]!.compareTo(_nodeResponses[key2]!));
  } while (_sortedApiNodesByResponseTime.entries.toList().isEmpty);

  print("using " + _sortedApiNodesByResponseTime.entries.toList()[0].key);
  // pick quickest node
  return _sortedApiNodesByResponseTime.entries.toList()[0].key;
}
