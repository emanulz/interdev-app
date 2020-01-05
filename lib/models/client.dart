import 'package:flutter/material.dart';

class Client {
  final String id;
  final String code;
  final String name;
  final String lastName;
  final String idType;
  final String idNum;
  final String idForeigner;
  final String province;
  final String canton;
  final String district;
  final String town;
  final String otherAddress;
  final String phoneNumber;
  final String cellphoneNumber;
  final String faxNumber;
  final String email;
  final String categoryId;
  final double predDiscount;
  final double maxDiscount;
  final int predPriceList;
  final bool paysTaxes;
  final double balance;
  final bool hasCredit;
  final bool isBlocked;
  final double creditLimit;
  final int creditDays;
  final String observations;
  final String localData;
  // CONSTRUCTOR
  Client({
    this.id,
    this.code,
    @required this.name,
    this.lastName,
    @required this.idType,
    this.idNum,
    this.idForeigner,
    this.province,
    this.canton,
    this.district,
    this.town,
    this.otherAddress,
    this.phoneNumber,
    this.cellphoneNumber,
    this.faxNumber,
    this.email,
    this.categoryId,
    this.predDiscount,
    this.maxDiscount,
    this.predPriceList,
    this.paysTaxes,
    this.balance,
    this.hasCredit,
    this.isBlocked,
    this.creditLimit,
    this.creditDays,
    this.observations,
    this.localData
  });
}
