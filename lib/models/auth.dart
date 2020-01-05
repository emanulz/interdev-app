import 'package:flutter/material.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  // CONSTRUCTOR
  User({
    this.id,
    this.firstName,
    this.lastName,
    @required this.username,
    this.email
  });
}

class UserProfile {
  final int id;
  final String avatar;
  final int activeLocalId;
  final String code;
  final String pin;
  final int taxPayerId;
  final String taxpayerLocals;
  final int user;
  // CONSTRUCTOR
  UserProfile({
    this.id,
    this.avatar,
    this.activeLocalId,
    this.code,
    this.pin,
    this.taxPayerId,
    this.taxpayerLocals,
    this.user
  });
}

class Local {
  final int id;
  final String name;
  final String receiptAddress;
  final String longAddress;
  final String phoneNumber;
  final int taxpayerId;
  final String email;
  // CONSTRUCTOR
  Local({
    this.id,
    this.name,
    this.receiptAddress,
    this.longAddress,
    this.phoneNumber,
    this.taxpayerId,
    this.email
  });
}

class TaxPayer {
  final int id;
  final String idNumber;
  final String idType;
  final String legalName;
  // CONSTRUCTOR
  TaxPayer({
    this.id,
    this.idNumber,
    this.idType,
    this.legalName
  });
}

class ConnectionData {
  final String api;
  final String username;
  final String password;
  // CONSTRUCTOR
  ConnectionData({
    @required this.api,
    @required this.username,
    @required this.password
  });
}
