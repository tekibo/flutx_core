import 'package:flutx_core/models/class_field_struct.dart';

class ClassStruct {
  final String className;
  final List<ClassFieldStruct> fields;

  ClassStruct({required this.className, required this.fields});
}
