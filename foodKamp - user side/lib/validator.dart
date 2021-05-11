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

enum NameValidationResults{
  VALID,
  NON_VALID,
  EMPTY_NAME,
}

enum WalletValidationResults{
  VALID,
  NON_VALID,
}

enum OrderValidationResults{
  VALID,
  NON_VALID,
}

enum AddMoneyValidationResults{
  VALID,
  NON_VALID,
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

  WalletValidationResults validateWallet(String wallet) {
    if (int.tryParse(wallet)<0) {
      return WalletValidationResults.NON_VALID;
    }
    return WalletValidationResults.VALID;
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

  OrderValidationResults validateOrder(String order) {
    if (int.tryParse(order)<=0) {
      return OrderValidationResults.NON_VALID;
    }
    return OrderValidationResults.VALID;
  }

  AddMoneyValidationResults validateAddMoney(String amount) {
    if (int.tryParse(amount)<100 || int.tryParse(amount)>1000) {
      return AddMoneyValidationResults.NON_VALID;
    }
    return AddMoneyValidationResults.VALID;
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