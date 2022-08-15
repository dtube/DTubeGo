class HiveConfig {
  // hivesigner config
  static String hiveSignerCallbackUrlScheme = 'dtubego';
  static String hiveSignerRedirectUrlHTMLEncoded =
      hiveSignerCallbackUrlScheme + '%3A%2F%2Foauth2redirect';
  static String hiveSignerAccessTokenUrl =
      'https://hivesigner.com/oauth2/authorize?client_id=dtubemobile&redirect_uri=${hiveSignerRedirectUrlHTMLEncoded}&scope=vote,comment';

  static String hiveSignerBroadcastAddress =
      'https://hivesigner.com/api/broadcast';
}
