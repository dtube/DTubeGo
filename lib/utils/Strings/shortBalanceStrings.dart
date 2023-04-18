String shortDTC(int dtcBalance) {
  double _dtcBalanceK = dtcBalance / 100000;
  String result = "";

  if (_dtcBalanceK < 1) {
    result = (dtcBalance / 100).toStringAsFixed(1) + ' ';
  } else if (_dtcBalanceK >= 1000) {
    result = (_dtcBalanceK / 1000).toStringAsFixed(1) + 'M';
  } else {
    result = _dtcBalanceK.toStringAsFixed(1) + 'K';
  }

  return result;
}

String shortVP(int vpBalance) {
  double _vpBalanceK = vpBalance / 1000;
  String result = "";
  if (vpBalance > 1000) {
    if (_vpBalanceK >= 1000000) {
      result = (_vpBalanceK / 1000000).toStringAsFixed(1) + 'B';
    } else if (_vpBalanceK >= 1000) {
      result = (_vpBalanceK / 1000).toStringAsFixed(1) + 'M';
    } else {
      result = _vpBalanceK.toStringAsFixed(1) + 'K';
    }
  } else {
    result = vpBalance.toStringAsFixed(1) + ' ';
  }
  return result;
}
