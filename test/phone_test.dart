import 'package:aagaaz_institute/utils/phone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts a 10-digit Indian mobile number', () {
    expect(isIndianMobile('9876543210'), isTrue);
    expect(isIndianMobile('6123456789'), isTrue);
    expect(isIndianMobile('5123456789'), isFalse);
    expect(isIndianMobile('987654321'), isFalse);
    expect(digitsOnly('+91 98765-43210'), '9876543210');
    expect(maskIndianMobile('9876543210'), '+91 98••• 210');
  });
}
