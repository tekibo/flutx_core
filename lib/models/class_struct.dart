import 'package:flutx_core/models/class_field_struct.dart';

class ClassStructure {
  final String className;
  final List<ClassFieldStructure> fields;

  ClassStructure({required this.className, required this.fields});
}
