abstract class StringValidator {
  bool isValid(String string);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String string) {
    if (string == null) return false;
    return string.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();

  final String emailInVaildErrorText = 'Email can not be empty.';
  final String passwordInVaildErrorText = 'Password can not be empty.';
}
