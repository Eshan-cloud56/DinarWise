double? parseLocalizedAmount(String value) {
  const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
  const persianDigits = '۰۱۲۳۴۵۶۷۸۹';
  var normalized = value.trim().replaceAll('٫', '.').replaceAll('٬', '');
  for (var index = 0; index < 10; index++) {
    normalized = normalized
        .replaceAll(arabicDigits[index], '$index')
        .replaceAll(persianDigits[index], '$index');
  }
  return double.tryParse(normalized);
}
