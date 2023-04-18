import 'package:dtube_go/res/Config/APINodesConfigValues.dart';
import 'package:http/http.dart' as http;

import 'dart:collection';

// Automatic node discovery based on their response time to request /count
Future<String> discoverAPINode() async {
  var _nodes = APINodeConfig.apiNodes;
  int _retries = 0;
  //if we are using experimental features aka not merged PRs then this will get executed
  if (APINodeConfig.useDevNodes) {
    _nodes = APINodeConfig.apiNodesDev;
  }

  Map<String, int> _nodeResponses = {};
  Map<String, int> _sortedApiNodesByResponseTime = {};
  Map<String, int> _ApiNodesOnError = {};
  // as long as we do not have received any response within the configured timeout
  // TODO: do this only for X times and then responde to the user about missing internet or blockchain issues
  do {
    _retries =
        _retries + 1; // every retry of the node list will increase the timeout
    // check response time of each node
    for (var node in _nodes) {
      if (_ApiNodesOnError.containsKey(node) && _nodes.length > _ApiNodesOnError.length) {
        continue;
      } else if (_nodes.length == _ApiNodesOnError.length) {
        break;
      }
      print("checking " + node);
      try {
        var _beforeRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;
        var response = await http.get(Uri.parse(node + '/count')).timeout(
            Duration(
                milliseconds:
                    APINodeConfig.nodeDiscoveryTimeout.inMilliseconds *
                        _retries), onTimeout: () {
          // timeout occurred
          return http.Response('Error', 408);
        });
        if (response.statusCode >= 400 && response.statusCode != 408) {
          print(node + ": " + response.statusCode.toString());
          _ApiNodesOnError[node] = -1;
        } else if (response.statusCode == 200) {
          // node responded
          // save responsetime to list
          var _afterRequestMicroSeconds = DateTime.now().microsecondsSinceEpoch;
          print(_afterRequestMicroSeconds);

          _nodeResponses[node] =
              _afterRequestMicroSeconds - _beforeRequestMicroSeconds;
        }
      } catch (e) {
      }
      if (_retries > 20) {
        break;
      }
    }
  } while (_nodeResponses.length ==
      0 && _nodes.length > _ApiNodesOnError.length); // as long as no node responded in specified timeout
// sort all responses by their response time
  _sortedApiNodesByResponseTime = SplayTreeMap.from(_nodeResponses,
      (key1, key2) => _nodeResponses[key1]!.compareTo(_nodeResponses[key2]!));

  print("using " + _sortedApiNodesByResponseTime.entries.toList()[0].key);
  // pick quickest node
  return _sortedApiNodesByResponseTime.entries.toList()[0].key;
}
