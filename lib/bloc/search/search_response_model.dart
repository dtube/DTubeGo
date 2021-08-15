class ApiResultModel {
  late String status;
  late int totalResults;
  late List<SearchResult> searchResults;

  ApiResultModel(
      {required this.status,
      required this.totalResults,
      required this.searchResults});

  ApiResultModel.fromJson(List<dynamic> json) {
//    status = json['status'];

    totalResults = json.length;
    searchResults = [];
    json.forEach((v) {
      searchResults.add(new SearchResult.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    data['searchresults'] = this.searchResults.map((v) => v.toJson()).toList();

    return data;
  }
}

class SearchResult {
  late String sId;
  late String name;

  SearchResult({required this.sId, required this.name});

  SearchResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;

    return data;
  }
}
