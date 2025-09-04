Core logical library for Flutx

## Features

- Generate dart classes using hive and equatable
- Automatically generate the hive adapters file
- Add and remove packages from pubspec.yaml
- Add deploy.yaml with all kinds of configurations

## Usage

```dart

// Dart class generator
String appDir = 'path/to/appDirectory';
List<ClassStruct> myClasses = [your classes];
String appName = 'myAwesomeApp';
ClassEditor classEditor = ClassEditor(dir: appDir, classes: myClasses, packageName: appName);
classEditor.generate();

// Package editor
PackageEditor manager = PackageEditor(dir: appDir);
manager.addPackage(package: 'fluent_ui: ^4.10.0');
manager.update(name: 'fluent_ui', version: '4.12.0');
manager.addFromGit(name:'flutx_core', url:'https://github.com:tekibo/flutx_core.git');
manager.remove(package:'provider');

// Make deployment file
DeployEditor deploy = DeployEditor(dir: appDir, packageName: appName);
deploy.init();
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
