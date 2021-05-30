import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riafy_test/models/DemoModel.dart';
import 'package:riafy_test/providers/Api.dart';
import 'package:riafy_test/providers/Const.dart';
import 'package:riafy_test/providers/DbHelper.dart';
import 'package:riafy_test/scoped-models/MainModel.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  final MainModel model;

  const DashboardScreen({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DemoModel> feedList = [];
  final dbHelper = DbHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }

  void callApi() {
    widget.model.GETMETHODCALL(
        api: Api.DEMO_API,
        fun: (List<dynamic> map,bool isSuccess) {
          //if(!map.containsKey(Const.STATUS)){
          map.forEach((element) {
            feedList.add(new DemoModel.fromJson(element));
          });
          //}
          setState(() {
            feedList;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.photo_camera,
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Instagram",
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            Stack(
              children: [
                //Icon(CupertinoIcons.s,color: Colors.black,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    "assets/send.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, "/bookmark");
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffc32c37),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "10",
                          style: TextStyle(fontSize: 7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 1,
            )
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (feedList != null && feedList.length != 0)
                  ? ListView.builder(
                      itemCount: feedList.length,
                      itemBuilder: (context, i) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage:
                                        NetworkImage(feedList[i].lowThumbnail),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    feedList[i].channelname,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Icon(Icons.more_vert),
                                  SizedBox(
                                    width: 6,
                                  )
                                ],
                              ),
                            ),
                            Image.network(
                              feedList[i].highThumbnail,
                              //height: 200,
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    CupertinoIcons.heart,
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  InkWell(
                                    onTap: () {
//                                      http://cookbookrecipes.in/test.php
                                      Navigator.pushNamed(context, "/cmnt");
                                    },
                                    child: Icon(
                                      CupertinoIcons.conversation_bubble,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Image.asset(
                                    "assets/send.png",
                                    height: 18,
                                    width: 18,
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () {
                                        //isChecked
                                        setState(() {
                                          feedList[i].isChecked =
                                              !feedList[i].isChecked;
                                          insertTable(feedList[i].toJson());
                                        });
                                      },
                                      child: Icon((!feedList[i].isChecked)
                                          ? Icons.bookmark_border
                                          : Icons.bookmark)),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: ExpandableText(
                                feedList[i].title,
                                expandText: 'more',
                                collapseText: 'show less',
                                maxLines: 1,
                                linkColor: Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    )
                  : Container(
                      height: size.height - 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  insertTable(Map<String, dynamic> row) async {
    final id = await dbHelper.insert(DbHelper.BOOKMARK, row);
    print('inserted row id: $id');
  }

}

