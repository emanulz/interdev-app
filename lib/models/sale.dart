import 'package:flutter/material.dart';
import './client.dart';
import './cart.dart';

class Sale {
  final String id;
  final int consecutive;
  final Cart cart;
  final Client client;
  final String extras;
  final String pay;
  final String payTypes;
  final String saleType;
  final double saleTotal;
  final double balance;
  final String returnsCollection;
  final String user;
  final String presaleId;
  final bool isExempt;
  final int tpLocalId;
  final String currencyCode;
  final double exchangeRate;
  final String created;
  final String updated;
  final DateTime date;

  Sale({
    @required this.id,
    @required this.consecutive,
    this.client,
    this.cart,
    this.extras,
    this.pay,
    this.payTypes,
    this.saleType,
    this.saleTotal,
    this.balance,
    this.returnsCollection,
    this.user,
    this.presaleId,
    this.isExempt,
    this.tpLocalId,
    this.currencyCode,
    this.exchangeRate,
    this.created,
    this.updated,
    this.date,
  });
}
