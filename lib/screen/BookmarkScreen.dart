import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riafy_test/models/DemoModel.dart';
import 'package:riafy_test/providers/Api.dart';
import 'package:riafy_test/providers/Const.dart';
import 'package:riafy_test/providers/DbHelper.dart';
import 'package:riafy_test/scoped-models/MainModel.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkScreen extends StatefulWidget {
  final MainModel model;

  const BookmarkScreen({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<DemoModel> feedList = [];
  final dbHelper = DbHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatabaseCount();
  }


    getDatabaseCount() async {
      feedList = await dbHelper.getRegData();
      setState(() {
        feedList;
      });
    }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookmarks",
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

