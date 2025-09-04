import 'package:flutx_core/flutx_core.dart';
import 'package:path/path.dart' as p;
import 'package:dart_style/dart_style.dart';

class ClassEditor {
  final String dir;
  final String packageName;
  late List<ClassStructure> classes;
  final List<dynamic> data;
  late FileEditor _hiveFileEditor;
  late DartFormatter _formatter;

  ClassEditor({
    required this.dir,
    required this.packageName,
    required this.data,
  }) {
    final hiveFilePath = p.join(dir, 'lib', 'hive', 'hive_adapters.dart');
    _hiveFileEditor = FileEditor(filepath: hiveFilePath);
    _formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    );
    classes = convertToClasses(data);
  }

  String _format(String code) {
    return _formatter.format(code);
  }

  void _saveClass({required String code, required String className}) {
    var formattedClassName = toSnakeCase(className);
    var filePath = p.join(
      dir,
      'lib',
      'data',
      ourAppName,
      'models',
      formattedClassName,
    );
    FileEditor classFileEditor = FileEditor(filepath: filePath);
    classFileEditor.write(code);
  }

  void _saveHiveAdapter(String code) {
    _hiveFileEditor.write(code);
  }

  String _generateHiveAdapters() {
    StringBuffer hiveBuffer = StringBuffer();
    hiveBuffer.writeln("import 'package:hive_ce/hive.dart';");
    for (ClassStructure classVal in classes) {
      hiveBuffer.writeln(
        "import 'package:${toSnakeCase(packageName)}/data/flutX/models/${toSnakeCase(classVal.className)}.dart';",
      );
    }
    hiveBuffer.writeln("part 'hive_adapters.g.dart';");
    hiveBuffer.writeln("@GenerateAdapters([");
    for (ClassStructure classVal in classes) {
      hiveBuffer.writeln("  AdapterSpec<${classVal.className}>(),");
    }
    hiveBuffer.writeln("])");
    hiveBuffer.writeln("class HiveAdapters {}");
    return hiveBuffer.toString();
  }

  void generate() {
    ClassGenerator classGenerator;
    for (ClassStructure classVal in classes) {
      classGenerator = ClassGenerator(classVal, packageName);
      String classCode = classGenerator.generateClass();
      _saveClass(code: _format(classCode), className: classVal.className);
    }
    String hiveAdaptersCode = _generateHiveAdapters();
    _saveHiveAdapter(_format(hiveAdaptersCode));
  }
}
