class APINodeConfig {
// node discovery & api node configs

  static bool useDevNodes =
      false; //activate for new features which has not been integrated

  static List<String> apiNodesDev = [
    // development nodes for new features
    // 'https://dtube.club/mainnetapi',
    // 'https://testnetapi.avalonblocks.com',
    'https://testnet.dtube.fso.ovh'
  ];

  static List<String> apiNodes = [
    // common api nodes
    'https://avalon.d.tube',
    // 'https://dtube.club/mainnetapi',
    'https://api.avalonblocks.com',
    'https://dtube.fso.ovh'
  ];

// node discovery & api node configs
  static Duration nodeDiscoveryTimeout = Duration(milliseconds: 200);
}
