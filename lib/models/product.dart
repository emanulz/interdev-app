import 'package:flutter/material.dart';

class Product {
  final String id;
  final String code;
  final String description;
  final bool isService;
  final String unit;
  final bool fractioned;
  final String department;
  final String subdepartment;
  final String barcode;
  final String internalBarcode;
  final String supplierCode;
  final String model;
  final String partNumber;
  final String brandCode;
  final bool inventoryEnabled;
  final double inventoryMinimum;
  final double inventoryMaximum;
  final bool inventoryNegative;
  final String inventoryExistent;
  final double cost;
  final bool costBased;
  final bool useCoinRound;
  final double utility1;
  final double utility2;
  final double utility3;
  final double price;
  final double price1;
  final double price2;
  final double price3;
  final double sellPrice;
  final double sellPrice1;
  final double sellPrice2;
  final double sellPrice3;
  final bool askPrice;
  final bool useTaxes;
  final double taxes;
  final String taxCode;
  final double predDiscount;
  final double maxRegularDiscount;
  final double maxSaleDiscount;
  final String taxCodeIVA;
  final String rateCodeIVA;
  final double taxesIVA;
  final double factorIVA;
  final bool isUsed;
  final bool onSale;
  final bool isActive;
  final bool consignment;
  final bool generic;

  Product({
    @required this.id,
    @required this.code,
    @required this.description,
    this.isService,
    this.unit,
    this.fractioned,
    this.department,
    this.subdepartment,
    this.barcode,
    this.internalBarcode,
    this.supplierCode,
    this.model,
    this.partNumber,
    this.brandCode,
    this.inventoryEnabled,
    this.inventoryMinimum,
    this.inventoryMaximum,
    this.inventoryNegative,
    this.inventoryExistent,
    this.cost,
    this.costBased,
    this.useCoinRound,
    this.utility1,
    this.utility2,
    this.utility3,
    this.price,
    this.price1,
    this.price2,
    this.price3,
    this.sellPrice,
    this.sellPrice1,
    this.sellPrice2,
    this.sellPrice3,
    this.askPrice,
    this.useTaxes,
    this.taxes,
    this.taxCode,
    this.predDiscount,
    this.maxRegularDiscount,
    this.maxSaleDiscount,
    this.taxCodeIVA,
    this.rateCodeIVA,
    this.taxesIVA,
    this.factorIVA,
    this.isUsed,
    this.onSale,
    this.isActive,
    this.consignment,
    this.generic
  });
}
