//String validators

class StringValidators {
  static final instance = StringValidators();

  /// Validate emails using the latest Regex standard.
  ///
  /// `val` - the value you want to match against.
  // ignore: prefer_function_declarations_over_variables
  final String? Function(String?)? emailValidator = (String? val) {
    final _emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (_emailRegEx.hasMatch(val!)) {
      return null;
    } else {
      return 'Please enter a valid email';
    }
  };

  /// Validate passwords for firbase which must be at least 8 characters long.
  ///
  /// `val` - the password to be checked
  // ignore: prefer_function_declarations_over_variables
  final String? Function(String? val)? passwordValidator = (String? val) {
    if (val == null) {
      return null;
    }
    //must be at least 8 characters
    if (val.length < 8) {
      return 'Please enter a password at least 8 characters long';
    } else {
      return null;
    }
  };
}
