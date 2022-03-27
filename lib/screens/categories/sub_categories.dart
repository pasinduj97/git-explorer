import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({Key? key}) : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: const Color(0xff251F34),
          title: const Text("Sub Category"),
        )
    );
  }

}