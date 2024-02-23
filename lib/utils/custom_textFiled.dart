import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  bool? isShowPassword;
  bool? isShowIcon;
  IconData? iconData;
  int? maxLine;

  final String? Function(String?)? validator;
  TextInputType textInputType;
  TextInputType keyBoardType;

  CustomTextFormFiled(
      {Key? key,
        required this.labelText,
        required this.controller,
        this.isShowPassword,
        this.isShowIcon,
        this.iconData,
        this.maxLine,
        required this.textInputType,
        required this.keyBoardType,
        this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        maxLines: maxLine ?? 1,
        validator: validator ?? (value) {},
        controller: controller,
        keyboardType: keyBoardType,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          labelStyle: const TextStyle(

              fontWeight: FontWeight.normal,
              color: Colors.grey),
          contentPadding: const EdgeInsets.only(
              left: 10, top: 10, bottom: 10, right: 0),

        ),
      ),
    );
  }
}
