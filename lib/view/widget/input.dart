import 'dart:ui';

import 'package:careAsOne/constants/app_colors.dart';
import 'package:careAsOne/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DecoratedInputField extends StatelessWidget {
  final String name;
  final String? text;
  final String? hintText;
  final String? errorText;
  final IconData? icon;
  final bool? obscureText;
  final bool? isPasswordField;
  final bool? showPassword;
  final TextInputType? keyboard;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validations;
  final Function(String?)? onChange;
  final VoidCallback? onTapShowPass;
  final bool? showSuffixIcon;
  final suffixIcon;
  final TextEditingController? controller;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  DecoratedInputField({
    required this.name,
    this.text,
    this.hintText,
    this.errorText,
    this.icon,
    this.obscureText = false,
    this.isPasswordField = false,
    this.showPassword,
    this.keyboard = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validations,
    this.inputFormatters,
    this.onChange,
    this.onTapShowPass,
    this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.suffixIcon,
    this.showSuffixIcon = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.5),
        SubText(text!.toUpperCase(), size: 10.0),
        SizedBox(height: 5),
        FormBuilderTextField(
          focusNode: focusNode,
          autocorrect: false,
          name: name,
          controller: controller,
          obscureText: obscureText!,
          keyboardType: keyboard,
          textCapitalization: textCapitalization!,
          style: TextStyle(
            height: 1,
            color: AppColors.black.withOpacity(0.7),
          ),
          cursorColor: AppColors.green,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.only(top: 2, left: 7.5, bottom: 2),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                    color: AppColors.black.withOpacity(0.3), width: 0.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide:
                    BorderSide(color: AppColors.green.withOpacity(0.5))),
            // border: OutlineInputBorder(
            //   borderSide: BorderSide(color: Color(0xFFF0F0EF)),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   // borderSide: BorderSide(color: Color(0xFFF0F0EF)),
            //   borderSide: BorderSide(color: AppColors.green),
            // ),
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.black.withOpacity(0.3)),
            errorText: errorText,
            errorStyle: TextStyle(fontSize: 10),
          ),
          validator: validations,
          onChanged: onChange,

          // disabledBorder: new OutlineInputBorder(
          //   borderSide: BorderSide(color: Color(0xFFF0F0EF)),
          // ),
          //     suffixIcon:
          // InkWell(
          //   onTap: onTapShowPass,
          //   child: Container(
          //     height: 45,
          //     width: 45,
          //     child: Icon(
          //       !showPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
        ),

      ],
    );
  }
}

class BackgroundCard extends StatelessWidget {
  final double? height;
  final Color? color;
  final Widget? child;

  BackgroundCard({this.height, this.color = Colors.transparent, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      child: child,
    );
  }
}

class GenderField extends StatelessWidget {
  final List<String> genderList;

  GenderField(this.genderList);

  @override
  Widget build(BuildContext context) {
    String? select;
    Map<int, String> mappedGender = genderList.asMap();

    return StatefulBuilder(
      builder: (_, StateSetter setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender : ',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...mappedGender.entries.map(
                (MapEntry<int, String> mapEntry) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      groupValue: select,
                      value: genderList[mapEntry.key],
                      onChanged: (String? value) => setState(() => select = value!),
                    ),
                    Text(mapEntry.value)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final Function(String?)? onChange;
  final String? Function(String?)? validators;
  final suffixIcon;
  TextEditingController? controller;

  SearchField({this.onChange, this.validators, this.suffixIcon,this.controller});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'search',
      controller: controller,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: AppColors.black.withOpacity(0.5)),
      decoration: InputDecoration(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        focusColor: AppColors.black.withOpacity(0.5),
        hintText: 'SEARCH',
        hintStyle:
            TextStyle(color: AppColors.black.withOpacity(0.5), fontSize: 12.0),

        // size: 20.0, color: AppColors.black.withOpacity(0.5)),
        suffixIcon: suffixIcon,

        prefixIconConstraints: BoxConstraints(minWidth: 30.0),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.black.withOpacity(0.25))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.black.withOpacity(0.25))),
      ),
      onChanged: onChange,
      validator: validators,
    );
  }
}
