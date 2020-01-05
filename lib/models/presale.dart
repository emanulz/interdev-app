import 'package:flutter/material.dart';
import './client.dart';
import './cart.dart';

class Presale {
  final String id;
  final int consecutive;
  final Cart cart;
  final Client client;
  final String extras;
  final bool closed;
  final bool billed;
  final bool destroyed;
  final bool isNull;
  final String presaleType;
  final double saleTotal;
  final double balance;
  final String user;
  final int tpLocalId;
  final String currencyCode;
  final double exchangeRate;
  final String created;
  final String updated;

  Presale({
    @required this.id,
    @required this.consecutive,
    this.client,
    this.cart,
    this.extras,
    this.closed,
    this.billed,
    this.destroyed,
    this.isNull,
    this.presaleType,
    this.saleTotal,
    this.balance,
    this.user,
    this.tpLocalId,
    this.currencyCode,
    this.exchangeRate,
    this.created,
    this.updated,
  });
}
