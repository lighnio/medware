import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medware/components/custom_buttton.dart';
import 'package:medware/components/custom_textfield.dart';

class InventoryAdd extends StatefulWidget {
  const InventoryAdd({super.key});

  @override
  State<InventoryAdd> createState() => _InventoryAddState();
}

class _InventoryAddState extends State<InventoryAdd> {
  TextEditingController _genericName = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _provider = TextEditingController();
  TextEditingController _stock = TextEditingController();
  TextEditingController _unitaryPrice = TextEditingController();
  TextEditingController _expDate = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _lote = TextEditingController();
  TextEditingController _notes = TextEditingController();
  TextEditingController _registry = TextEditingController();

  Future addMed() async {
    if (_genericName.text.isEmpty ||
        _name.text.isEmpty ||
        _provider.text.isEmpty ||
        _stock.text.isEmpty ||
        _unitaryPrice.text.isEmpty ||
        _expDate.text.isEmpty ||
        _description.text.isEmpty ||
        _lote.text.isEmpty ||
        _registry.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No puede haber campos vacios.'),
        ),
      );
      return null;
    }
    String dd, mm, yy;
    [dd, mm, yy] = _expDate.text.split('/');

    var med = {
      "name": _name.text,
      "genericName": _genericName.text,
      "provider": _provider.text,
      "stockPerUnit": int.parse(_stock.text),
      "unitaryPrice": int.parse(_unitaryPrice.text),
      "expireDate": DateTime.parse('$yy-$mm-$dd'),
      "categories": ["Libre venta"],
      "description": _description.text,
      "entryDate": FieldValue.serverTimestamp(),
      "isControled": true,
      "loteNumber": _lote.text,
      "notes": _notes.text,
      "registryName": _registry.text,
    };

    await FirebaseFirestore.instance.collection('meds').add(med);

    _genericName.clear();
    _name.clear();
    _provider.clear();
    _stock.clear();
    _unitaryPrice.clear();
    _expDate.clear();
    _description.clear();
    _lote.clear();
    _notes.clear();
    _registry.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  CustomTextField(_genericName, 'Nombre Generico'),
                  const SizedBox(height: 10),
                  CustomTextField(_name, 'Nombre Formal'),
                  const SizedBox(height: 10),
                  CustomTextField(_provider, 'Proveedor'),
                  const SizedBox(height: 10),
                  CustomTextField(_stock, 'Stock',
                      inputType: TextInputType.number),
                  const SizedBox(height: 10),
                  CustomTextField(_unitaryPrice, 'Precio',
                      inputType: TextInputType.number),
                  const SizedBox(height: 10),
                  CustomTextField(_expDate, 'Fecha de expiracion: 20/12/2023'),
                  const SizedBox(height: 10),
                  CustomTextField(_description, 'Descripcion'),
                  const SizedBox(height: 10),
                  CustomTextField(_lote, 'Lote'),
                  const SizedBox(height: 10),
                  CustomTextField(_notes, 'Notas'),
                  const SizedBox(height: 10),
                  CustomTextField(_registry, 'Codigo de Registro'),
                  const SizedBox(height: 10),
                  CustomButton('Agregar Medicamento', addMed)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
