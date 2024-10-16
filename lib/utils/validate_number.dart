String? validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, llena este campo';
  }
  final number = int.tryParse(value);

  if (number == null) {
    return 'Por favor, ingresa un número válido';
  }
  return null;
}
