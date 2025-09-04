import 'package:path/path.dart' as p;
import 'package:yaml_edit/yaml_edit.dart';
import 'package:flutx_core/flutx_core.dart';

class DeployEditor {
  final String dir;
  final String packageName;
  late YamlEditor _editor;
  late FileEditor _fileEditor;

  DeployEditor({required this.dir, required this.packageName}) {
    _fileEditor = FileEditor(filepath: p.join(dir, 'deploy.yaml'));
    _editor = YamlEditor(_fileEditor.content());
  }

  void _save() => _fileEditor.write(_editor.toString());

  /// Helper: inserts only non-null values
  Map<String, dynamic> _filter(Map<String, dynamic> values) => {
    for (var e in values.entries)
      if (e.value != null) e.key: e.value,
  };

  void init({
    VersionStrategy? versionStrategy,
    // android
    String? androidCredentialsFile,
    String? androidPackageName,
    TrackName? androidTrackName,
    String? androidWhatsNew,
    String? androidFlavor,
    String? androidGeneratedFileName,
    // ios
    String? iosIssuerId,
    String? iosKeyId,
    String? iosPrivateKeyPath,
    String? iosBundleId,
    String? iosWhatsNew,
    String? iosFlavor,
    String? iosGeneratedFileName,
    bool? iosAutoIncrementMarketingVersion,
  }) {
    final yaml = _filter({
      'common': _filter({'versionStrategy': versionStrategy}),
      'android': _filter({
        'credentialsFile': androidCredentialsFile,
        'packageName': androidPackageName,
        'trackName': androidTrackName,
        'whatsNew': androidWhatsNew,
        'flavor': androidFlavor,
        'generatedFileName': androidGeneratedFileName,
      }),
      'ios': _filter({
        'issuerId': iosIssuerId,
        'keyId': iosKeyId,
        'privateKeyPath': iosPrivateKeyPath,
        'bundleId': iosBundleId,
        'whatsNew': iosWhatsNew,
        'flavor': iosFlavor,
        'generatedFileName': iosGeneratedFileName,
        'autoIncrementMarketingVersion': iosAutoIncrementMarketingVersion,
      }),
    });

    _editor.update([], yaml);
    _save();
  }
}
