enum PasswordValidationResults {
  VALID,
  TOO_SHORT,
  EMPTY_PASSWORD,
}

enum EmailValidationResults {
  VALID,
  NON_VALID,
  EMPTY_EMAIL,
}

enum PhoneValidationResults{
  VALID,
  NON_VALID,
  EMPTY_Phone,
}

enum ItempriceValidationResults{
  VALID,
  NON_VALID,
  EMPTY_ITEM,
}

enum ItemQuantityValidationResults{
  VALID,
  NON_VALID,
  EMPTY_ITEM,
}

enum ItempreptimeValidationResults{
  VALID,
  NON_VALID,
  EMPTY_ITEM,
}

enum ItemnameValidationResults{
  VALID,
  NON_VALID,
  EMPTY_ITEM,
}
enum CategoryValidationResults{
  VALID,
  NON_VALID,
  EMPTY_CATEGORY,
}

enum NameValidationResults{
  VALID,
  NON_VALID,
  EMPTY_NAME,
}

class Validator {
  final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  PasswordValidationResults validatePassword(String password) {
    if (password.isEmpty) {
      return PasswordValidationResults.EMPTY_PASSWORD;
    }
    if (password.length < 6) {
      return PasswordValidationResults.TOO_SHORT;
    }
    return PasswordValidationResults.VALID;
  }

  EmailValidationResults validateEmail(String email) {
    if (email.isEmpty) {
      return EmailValidationResults.EMPTY_EMAIL;
    }
    if (!emailRegExp.hasMatch(email)) {
      return EmailValidationResults.NON_VALID;
    }
    return EmailValidationResults.VALID;
  }
  CategoryValidationResults validateCategory(String Category) {
    if (Category.isEmpty) {
      return CategoryValidationResults.EMPTY_CATEGORY;
    }
    if (Category.length < 3) {
      return CategoryValidationResults.NON_VALID;
    }
    return CategoryValidationResults.VALID;
  }
  ItemnameValidationResults validatename(String item) {
    if (item.isEmpty) {
      return ItemnameValidationResults.EMPTY_ITEM;
    }
    if (item.length < 3) {
      return ItemnameValidationResults.NON_VALID;
    }
    return ItemnameValidationResults.VALID;
  }
  PhoneValidationResults validatePhone(String phone) {
    if (phone.isEmpty) {
      return PhoneValidationResults.EMPTY_Phone;
    }
    if (phone.length != 10) {
      return PhoneValidationResults.NON_VALID;
    }
    return PhoneValidationResults.VALID;
  }
  ItempriceValidationResults validatePrice(String item) {
    if (item.isEmpty) {
      return ItempriceValidationResults.EMPTY_ITEM;
    }
    if (int.tryParse(item)<=0) {
      return ItempriceValidationResults.NON_VALID;
    }
    return ItempriceValidationResults.VALID;
  }
  ItemQuantityValidationResults validateqty(String item) {
    if (item.isEmpty) {
      return ItemQuantityValidationResults.EMPTY_ITEM;
    }
    if (int.tryParse(item) <= 0) {
      return ItemQuantityValidationResults.NON_VALID;
    }
    return ItemQuantityValidationResults.VALID;
  }
  ItempreptimeValidationResults validatepreptime(String item) {
    if (item.isEmpty) {
      return ItempreptimeValidationResults.EMPTY_ITEM;
    }
    if (int.tryParse(item) <= 0) {
      return ItempreptimeValidationResults.NON_VALID;
    }
    return ItempreptimeValidationResults.VALID;
  }
  NameValidationResults validateName(String Name) {
    if (Name.isEmpty) {
      return NameValidationResults.EMPTY_NAME;
    }
    if (Name.length < 3) {
      return NameValidationResults.NON_VALID;
    }
    return NameValidationResults.VALID;
  }

}