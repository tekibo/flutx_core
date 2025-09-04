import 'dart:developer';
import 'package:flutx_core/flutx_core.dart';

List<PackageStruct> parseDeps({required dynamic nodes, bool isDev = false}) {
  List<PackageStruct> packages = [];
  if (nodes is Map) {
    nodes.forEach((key, value) {
      var isMap = value is Map;
      var isGit = value is Map && value.containsKey('git');

      var version = isMap
          ? value.toString()
          : isGit
          ? null
          : value.toString().replaceAll('^', '');
      var url = isGit ? value['git']['url'] : null;
      var ref = isGit ? value['git']['ref'] : null;
      var path = isGit ? value['git']['path'] : null;

      var formedPackage = PackageStruct(
        name: key,
        version: version,
        url: url,
        path: path,
        ref: ref,
        isDev: isDev,
        isGit: isGit,
      );
      packages.add(formedPackage);
    });
  } else {
    log('No section found.');
  }
  return packages;
}

String getPackageDetails({required String package, bool returnName = false}) {
  final int group = returnName ? 1 : 2;

  if (Rgx.isCopiedFromPubDevButton(package)) {
    return Rgx.splitCopiedFromPubDevButton(package)?.group(group).trim() ?? '';
  }
  if (Rgx.isCopiedFromPubDevDirectly(package)) {
    return Rgx.splitCopiedFromPubDevDirectly(package).group(group).trim() ?? '';
  }
  if (Rgx.isSelfWritten(package)) {
    return Rgx.splitSelfWritten(package).group(group).trim() ?? '';
  }
  return '';
}

String toSnakeCase(String input) {
  RegExp exp = RegExp(r'(?<!^)(?=[A-Z])');
  return input.split(exp).join('_').toLowerCase();
}
