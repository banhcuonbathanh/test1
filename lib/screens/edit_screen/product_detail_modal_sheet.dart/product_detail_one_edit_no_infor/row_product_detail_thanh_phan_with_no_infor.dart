import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled1/size_config.dart';

class RowProductDetailThanhPhanNoInform extends StatefulWidget {
  final TextEditingController thanhPhanController;
  final WidgetRef ref;
  final String? serverThanhPhan;
  RowProductDetailThanhPhanNoInform({
    Key? key,
    required this.serverThanhPhan,
    required this.ref,
    required this.thanhPhanController,
  }) : super(key: key);
  @override
  State<RowProductDetailThanhPhanNoInform> createState() =>
      _RowProductNameState();
}

class _RowProductNameState extends State<RowProductDetailThanhPhanNoInform> {
  bool isShowTextFormField = true;
  bool productNameInput = true;
  @override
  void initState() {
    //  kiem tra d/k de hien restaurantName
    if (widget.serverThanhPhan != null) {
      isShowTextFormField = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isUserInputFuncfalseName = () {
      setState(() {
        productNameInput = false;
      });
    };
    var isUserInputFuncTrueName = () {
      setState(() {
        productNameInput = true;
      });
    };

    return Row(
      children: [
        if (isShowTextFormField)
          Container(
            // color: Colors.blue,
            height: getProportionateScreenHeight(25),
            width: getProportionateScreenWidth(150),
            child: buildTextFormFieldTenSanPham(
              ref: widget.ref,
              tenSanPhamController: widget.thanhPhanController,
              isUserInputFuncfalseName: isUserInputFuncfalseName,
              isUserInputFuncTrueName: isUserInputFuncTrueName,
              productNameInput: productNameInput,
            ),
          ),
        // --------------------------------------
        if (!isShowTextFormField)
          Container(
            alignment: Alignment.centerLeft,
            height: getProportionateScreenHeight(25),
            width: getProportionateScreenWidth(150),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isShowTextFormField = true;
                  widget.thanhPhanController.text = '';
                });
              },
              child: Text(
                  widget.thanhPhanController.text != ''
                      ? widget.thanhPhanController.text
                      : widget.serverThanhPhan!,
                  style: TextStyle(fontSize: getProportionateScreenHeight(14))),
            ),
          ),
      ],
    );
  }
}

Widget buildTextFormFieldTenSanPham({
  required TextEditingController tenSanPhamController,
  required WidgetRef ref,
  required Function isUserInputFuncfalseName,
  required Function isUserInputFuncTrueName,
  required bool productNameInput,
}) {
  return TextFormField(
    style: TextStyle(fontSize: getProportionateScreenHeight(14)),
    controller: tenSanPhamController,
    keyboardType: TextInputType.emailAddress,
    onChanged: (value) {
      isUserInputFuncTrueName();
    },
    onSaved: (value) {
      tenSanPhamController.text = value!;
    },
    decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(1),
            vertical: getProportionateScreenHeight(1)),
        hintText: 'Thành Phần',
        hintStyle:
            TextStyle(color: productNameInput ? Colors.black : Colors.red)),
    validator: (value) {
      if (value!.isEmpty) {
        isUserInputFuncfalseName();
        return;
      }

      return null;
    },
  );
}
