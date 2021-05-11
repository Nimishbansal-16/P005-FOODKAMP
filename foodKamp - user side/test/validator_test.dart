
import 'package:canteen_food_ordering_app/validator.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  test('Password Test', () {
    final validator = Validator();

    expect(validator.validatePassword(''), PasswordValidationResults.EMPTY_PASSWORD);
    expect(validator.validatePassword('passw'), PasswordValidationResults.TOO_SHORT);
    expect(validator.validatePassword('validPass'), PasswordValidationResults.VALID);

  });

  test('Email Test', () {
    final validator = Validator();
    expect(validator.validateEmail(''), EmailValidationResults.EMPTY_EMAIL);
    expect(validator.validateEmail('devan'), EmailValidationResults.NON_VALID);
    expect(validator.validateEmail('validemail@gmail.com'), EmailValidationResults.VALID);
  });

  test('Phone Test', () {
    final validator = Validator();
    expect(validator.validatePhone(''), PhoneValidationResults.EMPTY_Phone);
    expect(validator.validatePhone('9301258'), PhoneValidationResults.NON_VALID);
    expect(validator.validatePhone('9301258689'), PhoneValidationResults.VALID);
  });

  test('Name Test', () {
    final validator = Validator();
    expect(validator.validateName(''), NameValidationResults.EMPTY_NAME);
    expect(validator.validateName('ab'), NameValidationResults.NON_VALID);
    expect(validator.validateName('Devansh'), NameValidationResults.VALID);
  });
  test('Add Money Test', () {
    final validator = Validator();
    expect(validator.validateAddMoney('10'), AddMoneyValidationResults.NON_VALID);
    expect(validator.validateAddMoney('2000'), AddMoneyValidationResults.NON_VALID);
    expect(validator.validateAddMoney('200'), AddMoneyValidationResults.VALID);
  });

  test('Order Test', () {
    final validator = Validator();
    expect(validator.validateOrder('47'), OrderValidationResults.VALID);
    expect(validator.validateOrder('0'), OrderValidationResults.NON_VALID);
  });

  test('Wallet Test', () {
    final validator = Validator();
    expect(validator.validateWallet('100'), WalletValidationResults.VALID);
    expect(validator.validateWallet('-2'), WalletValidationResults.NON_VALID);
  });
}
