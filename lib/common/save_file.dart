import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveReport(String type, var bytes) async {
// Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();
  Directory appDocDirectory = await getApplicationDocumentsDirectory();

  String dateTimeHash =
      DateTime.now().toIso8601String().replaceAll(RegExp('[^0-9]'), '');

  final report = await File('${appDocDirectory.path}/$dateTimeHash.xlsx')
      .writeAsBytes(bytes);

  UploadTask uploadTask =
      storageRef.child('$type/$dateTimeHash.xlsx').putFile(report);

  uploadTask
      .then((p0) => print('Finished'))
      .catchError((onError) => print('Error: ${onError.toString()}'));
}
