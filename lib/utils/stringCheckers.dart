bool isPasswordCompliant(String password, int minLength) {
  // password compliant is:
  // at least minLength
  // at least 1 special character
  // at least 1 upper case character
  // at least 1 lower case character
  // at least 1 number

  if (password == null || password.isEmpty) {
    return false;
  }

  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(new RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
  bool hasSpecialCharacters =
      password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = password.length >= minLength;

  return hasDigits &
      hasUppercase &
      hasLowercase &
      hasSpecialCharacters &
      hasMinLength;
}

String checkPasswordCompliance(String password, int minLength) {
  // password compliant is:
  // at least minLength
  // at least 1 special character
  // at least 1 upper case character
  // at least 1 lower case character
  // at least 1 number
  if (password == null || password.isEmpty) {
    password = "";
  }

  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  bool hasDigits = password.contains(new RegExp(r'[0-9]'));
  bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
  bool hasSpecialCharacters =
      password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = password.length >= minLength;

  String result = !hasMinLength
      ? "The password should be at least 8 characters long. "
      : "";
  result = result +
      (!hasDigits || !hasSpecialCharacters
          ? "The password has to contain at least 1 number and 1 special character. "
          : "");
  result = result +
      (!hasUppercase || !hasLowercase
          ? "The password has to contain lowercase and uppercase letters."
          : "");

  return result;
}
