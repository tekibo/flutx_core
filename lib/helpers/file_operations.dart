import 'dart:io';
import 'package:path/path.dart' as p;

class FileEditor {
  late File _file;

  FileEditor({required String filepath}) {
    _file = File(filepath);
    if (!_file.existsSync()) {
      _file.createSync(recursive: true);
    }
  }

  String content() {
    return _file.readAsStringSync();
  }

  void write(String newContent) {
    _file.writeAsStringSync(newContent);
  }
}

class FileFinder {
  late Directory _dir;

  FileFinder({required String dir}) {
    _dir = Directory(dir);
    if (!_dir.existsSync()) {
      throw Exception('File does not exist');
    }
  }

  List<File?> find({String? name, String? extension, bool recursive = false}) {
    assert(
      name != null || extension != null,
      'name or extension must be provided',
    );

    if (name != null && extension == null) {
      return _dir
          .listSync(recursive: recursive)
          .where((e) => e is File && p.basename(e.path) == name)
          .toList()
          .cast<File>();
    }

    if (extension != null && name == null) {
      return _dir
          .listSync(recursive: recursive)
          .where((e) => e is File && p.extension(e.path) == extension)
          .toList()
          .cast<File>();
    }

    if (name != null && extension != null) {
      return _dir
          .listSync(recursive: recursive)
          .where(
            (e) =>
                e is File &&
                p.basename(e.path) == name &&
                p.extension(e.path) == extension,
          )
          .toList()
          .cast<File>();
    }

    return [];
  }
}
