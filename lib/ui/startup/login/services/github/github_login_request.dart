class GitHubLoginRequest {
  String clientId;
  String clientSecret;
  String code;

  GitHubLoginRequest(
      {required this.clientId, required this.clientSecret, required this.code});

  dynamic toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code,
      };
}
