import 'package:flutter/foundation.dart';

class Employee{
  final int? id;
  final String eName;
  final String eAddress;
  final String ePhNo;
  final String eDOB;
  final String eImage;

  const Employee({this.id,required this.eName,required this.eAddress,required this.ePhNo,required this.eDOB,required this.eImage});

  factory Employee.fromJson(Map<String,dynamic> json) => Employee(
      id: json['id'],
      eName: json['eName'],
      eAddress: json['eAddress'],
      ePhNo: json['ePhNo'],
      eDOB: json['eDOB'],
      eImage: json['eImage']
  );

  Map<String,dynamic> toJson()=>{
    'id':id,
    'eName':eName,
    'eAddress': eAddress,
    'ePhNo': ePhNo,
    'eDOB': eDOB,
    'eImage': eImage
  };
}