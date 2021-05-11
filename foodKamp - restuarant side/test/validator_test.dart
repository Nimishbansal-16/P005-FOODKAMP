import 'package:flutter_test/flutter_test.dart';
import 'package:canteen_food_ordering_app/validator.dart';

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
  test('Category Test', () {
    final validator = Validator();
    expect(validator.validateCategory(''), CategoryValidationResults.EMPTY_CATEGORY);
    expect(validator.validateCategory('ab'), CategoryValidationResults.NON_VALID);
    expect(validator.validateCategory('MESS'), CategoryValidationResults.VALID);
  });

  test('Itemname Test', () {
    final validator = Validator();
    expect(validator.validatename(''), ItemnameValidationResults.EMPTY_ITEM);
    expect(validator.validatename('ab'), ItemnameValidationResults.NON_VALID);
    expect(validator.validatename('POHA'), ItemnameValidationResults.VALID);
  });

  test('Itemprice Test', () {
    final validator = Validator();
    expect(validator.validatePrice(''), ItempriceValidationResults.EMPTY_ITEM);
    expect(validator.validatePrice('-3'), ItempriceValidationResults.NON_VALID);
    expect(validator.validatePrice('100'), ItempriceValidationResults.VALID);
  });

  test('Item Quantity Test', () {
    final validator = Validator();
    expect(validator.validateqty(''), ItemQuantityValidationResults.EMPTY_ITEM);
    expect(validator.validateqty('-3'), ItemQuantityValidationResults.NON_VALID);
    expect(validator.validateqty('100'), ItemQuantityValidationResults.VALID);
  });
  test('Itempreptime Test', () {
    final validator = Validator();
    expect(validator.validatepreptime(''), ItempreptimeValidationResults.EMPTY_ITEM);
    expect(validator.validatepreptime('-3'), ItempreptimeValidationResults.NON_VALID);
    expect(validator.validatepreptime('30'), ItempreptimeValidationResults.VALID);
  });
}
