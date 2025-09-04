import 'dart:developer';

import 'package:path/path.dart' as p;
import 'package:flutx_core/flutx_core.dart';
import 'package:yaml_edit/yaml_edit.dart';

class PackageEditor {
  final String dir;
  late YamlEditor _editor;
  late FileEditor _fileEditor;

  PackageEditor({required this.dir}) {
    _fileEditor = FileEditor(filepath: p.join(dir, 'pubspec.yaml'));
    _editor = YamlEditor(_fileEditor.content());
  }

  void save() {
    _fileEditor.write(_editor.toString());
  }

  String getVersion() {
    var node = _editor.parseAt(['version']).value;

    return node[1].toString();
  }

  void addPackage({required String package, bool isDev = false}) {
    final path = isDev ? 'dev_dependencies' : 'dependencies';
    final name = getPackageDetails(package: package, returnName: true);
    final version = getPackageDetails(package: package, returnName: false);

    final isNameBlank = name == '';

    if (isNameBlank) {
      throw Exception('Package name is blank');
    }

    final isVersionBlank = version == '';

    if (isVersionBlank) {
      _editor.update([path], name);
    } else {
      _editor.update([path, name], version);
    }
    save();
  }

  void update({
    required String name,
    required String version,
    bool isDev = false,
  }) {
    final path = isDev ? 'dev_dependencies' : 'dependencies';

    if (name == '') {
      throw Exception('Package name is blank');
    }

    if (version == '') {
      throw Exception('Package version is blank');
    }

    _editor.update([path, name], version);

    save();
  }

  void addFromGit({
    required String name,
    required String url,
    String? ref,
    String? path,
    bool isDev = false,
  }) {
    final gitMap = <String, dynamic>{'url': url};

    if (ref != null) gitMap['ref'] = ref;
    if (path != null) gitMap['path'] = path;

    final value = {'git': gitMap};

    final nodeName = isDev ? 'dev_dependencies' : 'dependencies';

    _editor.update([nodeName, name], value);
    save();
  }

  void remove({required String package, bool isDev = false}) {
    var nodeName = isDev ? 'dev_dependencies' : 'dependencies';

    _editor.remove([nodeName, package]);
    save();
  }

  List<PackageStruct> listDevPackages() {
    try {
      final devDepNode = _editor.parseAt(['dev_dependencies']).value;
      return parseDeps(nodes: devDepNode, isDev: true);
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  List<PackageStruct> _listPackages() {
    try {
      final depNode = _editor.parseAt(['dependencies']).value;
      return parseDeps(nodes: depNode, isDev: false);
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  List<PackageStruct> listAllPackages({bool excludeDevs = false}) {
    List<PackageStruct> packages = [];
    packages.addAll(_listPackages());
    if (!excludeDevs) packages.addAll(listDevPackages());
    return packages;
  }
}
