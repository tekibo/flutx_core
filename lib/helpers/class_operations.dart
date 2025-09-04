import 'package:flutx_core/flutx_core.dart';

class ClassGenerator {
  final ClassStructure classStruct;
  final String packageName;

  ClassGenerator(this.classStruct, this.packageName);

  String _getFieldType(ClassFieldStructure field) {
    final base = field.isList ? 'List<${field.fieldType}>' : field.fieldType;
    return field.isNullable ? '$base?' : base;
  }

  String _getNonNullableType(ClassFieldStructure field) {
    return field.isList ? 'List<${field.fieldType}>' : field.fieldType;
  }

  String _getBaseType(ClassFieldStructure field) {
    return field.fieldType;
  }

  String _getCustomTypeImports() {
    StringBuffer importBuffer = StringBuffer();
    final package = toSnakeCase(packageName);
    for (final field in classStruct.fields) {
      final type = toSnakeCase(field.fieldType);
      if (field.isCustomType) {
        importBuffer.writeln(
          "import 'package:$package/data/$ourAppName/models/$type.dart';",
        );
      }
    }
    return importBuffer.toString();
  }

  String generateClass() {
    final buffer = StringBuffer();

    buffer.writeln('// ignore_for_file: must_be_immutable\n');
    buffer.writeln("import 'package:hive_ce/hive.dart';");
    buffer.writeln("import 'package:equatable/equatable.dart';\n");
    buffer.writeln(_getCustomTypeImports());

    buffer.writeln(
      'class ${classStruct.className} extends HiveObject with EquatableMixin {',
    );

    // Fields
    for (final field in classStruct.fields) {
      final type = _getFieldType(field);
      final defaultValue =
          (field.defaultValue != null && field.defaultValue!.trim().isNotEmpty)
          ? ' = ${field.defaultValue}'
          : '';
      buffer.writeln('  final $type ${field.fieldName}$defaultValue;');
    }

    // Constructor
    buffer.writeln('  ${classStruct.className}({');
    for (final field in classStruct.fields) {
      if (field.defaultValue == null || field.defaultValue!.trim().isEmpty) {
        buffer.writeln('    required this.${field.fieldName},');
      }
    }
    buffer.writeln('  });\n');

    // Equatable props
    final propsFields = classStruct.fields.map((f) => f.fieldName).join(', ');
    buffer.writeln('  @override');
    buffer.writeln('  List<Object?> get props => [$propsFields];\n');

    // copyWith
    buffer.writeln('  ${classStruct.className} copyWith({');
    for (final field in classStruct.fields) {
      final type = _getNonNullableType(field);
      buffer.writeln('    $type? ${field.fieldName},');
    }
    buffer.writeln('  }) {');
    buffer.writeln('    return ${classStruct.className}(');
    for (final field in classStruct.fields) {
      if (field.isList) {
        buffer.writeln(
          '      ${field.fieldName}: ${field.fieldName} ?? (this.${field.fieldName} != null ? List<${_getBaseType(field)}>.from(this.${field.fieldName}!) : null),',
        );
      } else {
        buffer.writeln(
          '      ${field.fieldName}: ${field.fieldName} ?? this.${field.fieldName},',
        );
      }
    }
    buffer.writeln('    );');
    buffer.writeln('  }\n');

    buffer.writeln('}');

    return buffer.toString();
  }
}
