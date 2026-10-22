import 'package:grocipe/helper/utils/string_extension.dart';

mixin Validators {
  get phoneNumberRegExp => RegExp(
      r'^([0-9]( |-)?)?(\(?[0-9]{3}\)?|[0-9]{3})( |-)?([0-9]{3}( |-)?[0-9]{4}|[a-zA-Z0-9]{7})$');
  get emailRegExp => RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  get zipCodeRegExp => RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');

  get digitRegExp => RegExp(r'^[0-9]+$');

  String? validateEmail(String? value) {
    if (!emailRegExp.hasMatch(value.nullToEmpty.trim())) {
      return 'Invalid email';
    }
    return null;
  }

  String? validateNotNull(dynamic value) {
    if (value == null || value == "") {
      return 'field cannot be empty';
    }
    return null;
  }

  String? validateField(String? value) {
    if (value.isEmptyOrNull) {
      return 'field cannot be empty';
    }
    return null;
  }

  String? validateDigit(String? value) {
    if (!digitRegExp.hasMatch(value.nullToEmpty.trim())) {
      return 'Invalid number';
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null) return 'Enter value';
    value = value.replaceAll(",", "");
    if (num.tryParse(value) == null) {
      return "enter a valid number";
    }
    return null;
  }

  String? validateName(String? value) {
    if (value.nullToEmpty.length < 3) {
      return 'Entry is too short';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    value = value.nullToEmpty;
    if (value.startsWith('+234')) {
      if (value.length == 14) return null;
    }

    if (!phoneNumberRegExp.hasMatch(value.trim())) {
      return 'Invalid phone number';
    }
    return null;
  }

  String? validateComment(String? value) {
    value = value.nullToEmpty;
    if (value.isEmpty) return "Invalid comment";
    return null;
  }

  String? validateZip(String? value) {
    value = value.nullToEmpty;
    if (!zipCodeRegExp.hasMatch(value.trim())) {
      return 'invalid zip code';
    }
    return null;
  }

  String? validatePassword(String? value) {
    value = value.nullToEmpty;
    if (value.length < 8) {
      return 'password is too short';
    }
    RegExp capitalLetter = RegExp(r'^(?=.*[A-Z])');
    if (!capitalLetter.hasMatch(value)) {
      return "password needs atleast one capital letter";
    }
    RegExp specialChar = RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])');
    if (!specialChar.hasMatch(value)) {
      return "password needs at least one special character";
    }
    RegExp number = RegExp(r'^(?=.*\d)');
    if (!number.hasMatch(value)) {
      return "password needs at least one number";
    }
    return null;
  }

  String? validateConfirmPassword({String? passowrd, String? confirmPassword}) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Please enter Confirm Password";
    } else if (confirmPassword.toString() != passowrd) {
      return "Password does not match!";
    }
    return null;
  }

  String? validateCard(String input) {
    if (input.isEmpty) {
      return "Please enter a credit card number";
    }
    if (input.length < 8) {
      // No need to even proceed with the validation if it's less than 8 characters
      return "Not a valid credit card number";
    }

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return "You entered an invalid credit card number";
  }
}
