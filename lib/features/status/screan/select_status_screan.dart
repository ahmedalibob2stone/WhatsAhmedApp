import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/add_massage_for_status.dart';

class SelectStatusScreen extends ConsumerWidget {
  final File file;

  const SelectStatusScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: AddMessageForStatus(file: file),
        ),
      ),
    );
  }
}
