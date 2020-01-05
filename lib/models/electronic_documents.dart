import 'package:flutter/material.dart';

class ElectronicInvoice {
  final String id;
  final int saleConsecutive;
  final String numericKey;
  final String processHistory;
  final int processStatus;
  final String saleId;
  final String consecutiveNumbering;

  ElectronicInvoice({
    @required this.id,
    @required this.saleConsecutive,
    this.numericKey,
    this.processHistory,
    this.processStatus,
    this.saleId,
    this.consecutiveNumbering
  });
}

class ElectronicTicket {
  final String id;
  final int saleConsecutive;
  final String numericKey;
  final String processHistory;
  final int processStatus;
  final String saleId;
  final String consecutiveNumbering;

  ElectronicTicket({
    @required this.id,
    @required this.saleConsecutive,
    this.numericKey,
    this.processHistory,
    this.processStatus,
    this.saleId,
    this.consecutiveNumbering
  });
}
