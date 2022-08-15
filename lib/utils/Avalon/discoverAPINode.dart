import 'package:dtube_go/res/Config/APINodesConfigValues.dart';
import 'package:http/http.dart' as http;

import 'dart:collection';

// Automatic node descovery based on their response time to request /count
Future<String> discoverAPINode() async {
  var _nodes = APINodeConfig.apiNodes;
  int _retries = 0;
  //if we are using experimental features aka not merged PRs then this will get executed
  if (APINodeConfig.useDevNodes) {
    _nodes = APINodeConfig.apiNodesDev;
  }

  Map<String, int> _nodeResponses = {};
  Map<String, int> _sortedApiNodesByResponseTime = {};
  // as long as we do not have received any response within the configured timeout
  // TODO: do this only for X times and then responde to the user about missing internet or blockchain issues
  do {
    _retries =
        _retries + 1; // every retry of the node list will increase the timeout
    // check response time of each node
    for (var node in _nodes) {
      print("checking " + node);
      try {
        var _beforeRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;
        var response = await http.get(Uri.parse(node + '/count')).timeout(
            Duration(
                milliseconds:
                    APINodeConfig.nodeDescoveryTimeout.inMilliseconds *
                        _retries), onTimeout: () {
          // timeout occured
          return http.Response('Error', 500);
        });

        if (response.statusCode == 200) {
          // node responded
          // save responsetime to list
          var _afterRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;
          print(_afterRequestMicroSeconds);

          _nodeResponses[node] =
              _afterRequestMicroSeconds - _beforeRequestMicroSeconds;
        }
      } catch (e) {}
    }
  } while (_nodeResponses.length ==
      0); // as long as no node responded in specified timeout
// sort all responses by their response time
  _sortedApiNodesByResponseTime = SplayTreeMap.from(_nodeResponses,
      (key1, key2) => _nodeResponses[key1]!.compareTo(_nodeResponses[key2]!));

  print("using " + _sortedApiNodesByResponseTime.entries.toList()[0].key);
  // pick quickest node
  return _sortedApiNodesByResponseTime.entries.toList()[0].key;
}
