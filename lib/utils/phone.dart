String digitsOnly(String value) => value.replaceAll(RegExp(r'\D'), '');

bool isIndianMobile(String digits) => RegExp(r'^[6-9]\d{9}$').hasMatch(digits);

String formatIndianMobile(String digits) {
  if (digits.length != 10) return digits;
  return '${digits.substring(0, 5)} ${digits.substring(5)}';
}

String maskIndianMobile(String digits) {
  if (digits.length != 10) return digits;
  return '+91 ${digits.substring(0, 2)}••• ${digits.substring(7)}';
}
