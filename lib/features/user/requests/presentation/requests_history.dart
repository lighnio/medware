import 'package:flutter/material.dart';

class RequestsHistory extends StatefulWidget {
  const RequestsHistory({super.key});

  @override
  State<RequestsHistory> createState() => _RequestsHistoryState();
}

class _RequestsHistoryState extends State<RequestsHistory> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Requests History'),
    );
  }
}
