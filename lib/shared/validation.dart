class Validation {
  static isPhoneValid(String phone) {
    final regexPhone = RegExp(r'^[0-9]+$');
    return regexPhone.hasMatch(phone);
  }

  static isPassValid(String pass) {
    return pass.length > 5;
  }

  static isDisplayName(String name){
    final regexName = RegExp(r'^[a-zA-Z]+$');
    return regexName.hasMatch(name) && name.length > 5;
  }
}
