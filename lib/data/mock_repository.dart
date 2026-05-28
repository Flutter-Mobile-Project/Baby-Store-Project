import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/branch.dart';

class MockRepository {
  Future<List<Branch>> loadBranches() async {
    final data = await rootBundle.loadString('assets/mock/branches.json');
    final List<dynamic> jsonList = json.decode(data);

    return jsonList.map((e) => Branch.fromJson(e)).toList();
  }
}
