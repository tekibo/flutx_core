class ClassFieldStructure {
  final String fieldName;
  final String fieldType;
  final String? defaultValue;
  final bool isNullable;
  final bool isList;
  final bool isCustomType;

  ClassFieldStructure({
    required this.fieldName,
    required this.fieldType,
    this.defaultValue,
    this.isNullable = false,
    this.isList = false,
    this.isCustomType = false,
  });
}
