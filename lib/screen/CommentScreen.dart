import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riafy_test/models/CmntModel.dart';
import 'package:riafy_test/providers/Api.dart';
import 'package:riafy_test/scoped-models/MainModel.dart';

class CommentScreen extends StatefulWidget {
  final MainModel model;

  const CommentScreen({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<CmntModel> model = [];
  bool isSuccess;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.GETMETHODCALL(
        api: Api.CMNT_API,
        fun: (dynamic res, bool isSuccess) {
          if (isSuccess) {
            dynamic map=jsonDecode(res);
            map.forEach((element) {
              model.add(new CmntModel.fromJson(element));
              setState(() {
                model;
              });
            });
          } else {
            setState(() {
              this.isSuccess = isSuccess;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        //automaticallyImplyLeading: false,
        titleSpacing: 3,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0,
      ),
      body: Container(
        height: size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (model != null && model.length != 0)
                  ? ListView.builder(
                      itemCount: model.length,
                      itemBuilder: (context, i) {

                        return ListTile(title: Text(model[i].username),subtitle: Text(model[i].comments));
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    )
                  : Container(
                      height: size.height - 100,
                      child: Center(
                        child: (isSuccess == null)
                            ? CircularProgressIndicator()
                            : isSuccess
                                ? null
                                : Text(
                                    "Data not found",
                                    style: TextStyle(color: Colors.black),
                                  ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
