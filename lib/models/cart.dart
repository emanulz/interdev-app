import 'package:flutter/material.dart';
import './product.dart';

class CartItem {
  final String uuid;
  final String lote;
  final double discount;
  final double discountCurrency;
  final double exemptPercentage;
  final double priceToUse;
  final double qty;
  final double subTotalNoDiscount;
  final double subtotal;
  final double totalWithIv;
  final Product product;

  CartItem({
    @required this.uuid,
    this.lote,
    this.discount,
    this.discountCurrency,
    this.exemptPercentage,
    this.priceToUse,
    this.qty,
    this.subTotalNoDiscount,
    this.subtotal,
    this.totalWithIv,
    this.product
  });
}

class Cart {
  final List<CartItem> cartItems;
  final double cartExemptAmount;
  final bool cartHasItems;
  final cartItemActive;
  final double cartSubtotal;
  final double cartSubtotalNoDiscount;
  final double cartTaxes;
  final double cartTotal;
  final double discountTotal;
  final bool editable;
  final double globalDiscount;
  final double globalExemptPercentage;
  final bool isExempt;
  final bool isNull;
  final bool needsRecalc;
  final bool pays10Percent;
  final bool pays10Setted;
  final double returnedIVA;
  final double totalNotRounded;
  final String workOrder;
  final String workOrderId;

  Cart({
    this.cartItems,
    this.cartExemptAmount,
    this.cartHasItems,
    this.cartItemActive,
    this.cartSubtotal,
    this.cartSubtotalNoDiscount,
    this.cartTaxes,
    @required this.cartTotal,
    this.discountTotal,
    this.editable,
    this.globalDiscount,
    this.globalExemptPercentage,
    this.isExempt,
    this.isNull,
    this.needsRecalc,
    this.pays10Percent,
    this.pays10Setted,
    this.returnedIVA,
    this.totalNotRounded,
    this.workOrder,
    this.workOrderId,
  });
}
