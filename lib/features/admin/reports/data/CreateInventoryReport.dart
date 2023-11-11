import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:medware/common/save_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

///XlsIO import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

Future<void> CreateInventoryReport(List meds, List reqs) async {
  //Creating a workbook.
  final Workbook workbook = Workbook(0);
  //Adding a Sheet with name to workbook.
  final Worksheet sheet1 = workbook.worksheets.addWithName('Inventario');
  sheet1.getRangeByName('A1:R100').cellStyle.backColor = '#FFFFFF';

  //Adding cell style.
  final Style style = workbook.styles.add('style');
  style.hAlign = HAlignType.center;
  style.vAlign = VAlignType.center;
  style.borders.all.lineStyle = LineStyle.thick;
  style.borders.all.color = '#000000';
  style.fontSize = 10;

  // Banner
  final banner = sheet1.getRangeByName('A1:K4');
  banner.merge();
  banner.cellStyle = style;
  banner.setText('MedWare');
  banner.cellStyle.fontName = 'Times New Roman';
  banner.cellStyle.fontSize = 48;
  banner.cellStyle.bold = true;

  // Report Title
  final title = sheet1.getRangeByName('C6:I7');
  title.merge();
  title.cellStyle = style;
  title.setText('Reporte de Inventario');
  title.cellStyle.fontSize = 14;
  title.cellStyle.bold = true;

  // Created By
  final createdBy = sheet1.getRangeByName('A10:B10');
  createdBy.merge();
  createdBy.cellStyle = style;
  createdBy.setText('Creado por');

  // Created By Name
  final createdByName = sheet1.getRangeByName('C10:E10');
  createdByName.merge();
  createdByName.cellStyle = style;
  createdByName
      .setText(FirebaseAuth.instance.currentUser?.email?.split('@')[0]);
  createdByName.cellStyle.bold = true;

  // Created By
  final generatedBy = sheet1.getRangeByName('G10:H10');
  generatedBy.merge();
  generatedBy.cellStyle = style;
  generatedBy.setText('Generado el');

  // Created By Name
  final generatedByTime = sheet1.getRangeByName('I10:K10');
  generatedByTime.merge();
  generatedByTime.cellStyle = style;
  generatedByTime.setText(
      DateTime.now().toIso8601String().replaceAll('T', ' ').split('.')[0]);
  generatedByTime.cellStyle.bold = true;

  // Variable Data Static
  final headerNumber = sheet1.getRangeByName('A13');
  headerNumber.setText('#');
  headerNumber.cellStyle = style;
  headerNumber.columnWidth = 3;
  headerNumber.cellStyle.bold = true;

  final headerId = sheet1.getRangeByName('B13');
  headerId.setText('ID');
  headerId.cellStyle = style;
  headerId.columnWidth = 17;
  headerId.cellStyle.bold = true;

  final headerGenericName = sheet1.getRangeByName('C13');
  headerGenericName.setText('Genérico');
  headerGenericName.cellStyle = style;
  headerGenericName.columnWidth = 22;
  headerGenericName.cellStyle.bold = true;

  final headerName = sheet1.getRangeByName('D13');
  headerName.setText('Nombre');
  headerName.cellStyle = style;
  headerName.columnWidth = 20;
  headerName.cellStyle.bold = true;

  final headerEntryDate = sheet1.getRangeByName('E13');
  headerEntryDate.setText('Fecha Entrada');
  headerEntryDate.cellStyle = style;
  headerEntryDate.columnWidth = 17;
  headerEntryDate.cellStyle.bold = true;

  final headerExpireDate = sheet1.getRangeByName('F13');
  headerExpireDate.setText('Fecha Caducidad');
  headerExpireDate.cellStyle = style;
  headerExpireDate.columnWidth = 17;
  headerExpireDate.cellStyle.bold = true;

  final headerStockPerUnit = sheet1.getRangeByName('G13');
  headerStockPerUnit.setText('Stock');
  headerStockPerUnit.cellStyle = style;
  headerStockPerUnit.columnWidth = 10;
  headerStockPerUnit.cellStyle.bold = true;

  final headerUnitaryPrice = sheet1.getRangeByName('H13');
  headerUnitaryPrice.setText('Precio p/u');
  headerUnitaryPrice.cellStyle = style;
  headerUnitaryPrice.columnWidth = 10;
  headerUnitaryPrice.cellStyle.bold = true;

  final headerRegistryName = sheet1.getRangeByName('I13');
  headerRegistryName.setText('Nombre del Registro');
  headerRegistryName.cellStyle = style;
  headerRegistryName.columnWidth = 20;
  headerRegistryName.cellStyle.bold = true;

  final headerProvider = sheet1.getRangeByName('J13');
  headerProvider.setText('Proveedor');
  headerProvider.cellStyle = style;
  headerProvider.columnWidth = 15;
  headerProvider.cellStyle.bold = true;

  final headerLoteNumber = sheet1.getRangeByName('K13');
  headerLoteNumber.setText('Número de Lote');
  headerLoteNumber.cellStyle = style;
  headerLoteNumber.columnWidth = 15;
  headerLoteNumber.cellStyle.bold = true;

  // Variable Data Headers
  int lineCounter = 14;

  for (var med in meds) {
    var medInfo = med.data();
    var requests = GetByMedId(reqs, med.id);

    final headerNumberVar = sheet1.getRangeByName('A$lineCounter');
    headerNumberVar.cellStyle = style;
    headerNumberVar.setText('${lineCounter - 13}');

    final headerIdVar = sheet1.getRangeByName('B$lineCounter');
    headerIdVar.cellStyle = style;
    headerIdVar.setText(med.id);

    final headerGenericNameVar = sheet1.getRangeByName('C$lineCounter');
    headerGenericNameVar.cellStyle = style;
    headerGenericNameVar.setText(medInfo['genericName']);

    final headerNameVar = sheet1.getRangeByName('D$lineCounter');
    headerNameVar.cellStyle = style;
    headerNameVar.setText(med['name']);

    final headerEntryDateVar = sheet1.getRangeByName('E$lineCounter');
    headerEntryDateVar.cellStyle = style;
    headerEntryDateVar.setText(med['entryDate']
        .toDate()
        .toIso8601String()
        .replaceAll('T', ' ')
        .split('.')[0]);

    final headerExpireDateVar = sheet1.getRangeByName('F$lineCounter');
    headerExpireDateVar.cellStyle = style;
    headerExpireDateVar.setText(med['expireDate']
        .toDate()
        .toIso8601String()
        .replaceAll('T', ' ')
        .split('.')[0]);

    final headerStockPerUnitVar = sheet1.getRangeByName('G$lineCounter');
    headerStockPerUnitVar.cellStyle = style;
    headerStockPerUnitVar.cellStyle.bold = true;
    headerStockPerUnitVar.setText('${medInfo['stockPerUnit']}');

    final headerUnitaryPriceVar = sheet1.getRangeByName('H$lineCounter');
    headerUnitaryPriceVar.cellStyle = style;
    headerUnitaryPriceVar.cellStyle.fontColor = '#FF0000';
    headerUnitaryPriceVar.setText('Q${medInfo['unitaryPrice']}');

    final headerRegistryNameVar = sheet1.getRangeByName('I$lineCounter');
    headerRegistryNameVar.cellStyle = style;
    headerRegistryNameVar.setText(medInfo['registryName']);

    final headerProviderVar = sheet1.getRangeByName('J$lineCounter');
    headerProviderVar.cellStyle = style;
    headerProviderVar.setText(medInfo['provider']);

    final headerLoteNumberVar = sheet1.getRangeByName('K$lineCounter');
    headerLoteNumberVar.cellStyle = style;
    headerLoteNumberVar.setText(medInfo['loteNumber']);

    requests.forEach((el) {
      lineCounter++;

      final request = sheet1.getRangeByName('C$lineCounter:K$lineCounter');
      request.merge();
      request.cellStyle = style;
      request.cellStyle.hAlign = HAlignType.left;
      request.rowHeight = 25;
      request.setText(
          'Pedido de: ${el["ownerId"]} el ${el["endedAt"].toDate().toIso8601String().replaceAll('T', ' ').split('.')[0]} por ${el["quantity"]} Unidades');
    });

    lineCounter++;
  }

  // End Line
  final footerLine = sheet1.getRangeByName('A$lineCounter:K$lineCounter');
  footerLine.merge();
  footerLine.cellStyle = style;
  footerLine.cellStyle.bold = true;
  footerLine.setText('*** Linea Final ***');

  // Processing and dispose
  final List<int> bytes = workbook.saveSync();
  workbook.dispose();

  // Save File
  await saveReport('inventory', bytes);
}

List GetByMedId(var data, String medId) {
  List allReqs = data.map((e) {
    List elem = e.data()['requests'].map((its) {
      if (its['endedAt'] != null) {
        List lstT = its['requestMeds']
            .map(
                (iits) => {...iits, 'ownerId': e.id, 'endedAt': its['endedAt']})
            .toList();
        return lstT;
      }

      return [];
    }).toList();

    return elem;
  }).toList();

  var cleanArray = [];

  for (var subarray in allReqs) {
    for (var subarray2 in subarray) {
      cleanArray.addAll(subarray2);
    }
  }

  return cleanArray.where((element) => element['id'] == medId).toList();
}
