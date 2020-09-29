class Validation {
  static isPhoneValid(String phone) {
    final regexPhone = RegExp(r'^[0-9]+$');
    return regexPhone.hasMatch(phone) && phone.length > 8;
  }

  static isNumber(String number) {
    final regexPhone = RegExp(r'^[0-9]+$');
    return regexPhone.hasMatch(number);
  }

  static isPassValid(String pass) {
    return pass.length > 5;
  }

  static isDisplayName(String name) {
    final regexName = RegExp(r'^[a-zA-Z]+$');
    return name.length > 3;
  }
}
