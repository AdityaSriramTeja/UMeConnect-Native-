import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ume_connect/models/firebaseUser.dart';
import 'package:ume_connect/pages/otherProfileScreen.dart';
import 'package:ume_connect/style/style.dart';
import 'package:ume_connect/widgets/avatar.dart';
import 'package:ume_connect/widgets/topRecommededUsers.dart';
import 'package:get/get.dart';

///搜索页
class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  PageController _pageController = PageController();
  SearchPageController _searchPageController = Get.put(SearchPageController());
  late TextEditingController textcontroller;
  @override
  void initState() {
    textcontroller = TextEditingController();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_bottomBarLayout) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: _getAppBarLayout(),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          _getSearchRecordLayout(),
          _getGuessLayout(),
          _getRankingBarLayout(),
          _getPageLayout(),
        ],
      ),
    );
  }

  //appbar
  _getAppBarLayout() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: textcontroller,
              decoration: InputDecoration(
                hintText: 'Search users',
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
              onChanged: (text) {
                EasyDebounce.debounce(
                    'debound1', // <-- An ID for this particular debouncer
                    Duration(seconds: 3), // <-- The debounce duration
                    () => setState(() {
                          name = text.toLowerCase().trim();
                        }) // <-- The target method
                    );

                //filter(text);
              },
            ),
          ),
        ],
      ),
    );
  }

  _getSearchRecordLayout() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 240,
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                color: ColorPlate.darkGray,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: (name.trim() != "" && name.length >= 3)
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .where("searchIndex", arrayContains: name)
                          .where('username',
                              isNotEqualTo: firebaseuser!.displayName)
                          .limit(5)
                          .snapshots()
                      : null,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                            "Enter atleast 3 characters of the person you want to search"),
                      );
                    } else if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Center(child: CircularProgressIndicator());
                      default:
                        return new ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return new ListTile(
                              leading:
                                  Avatar.small(url: document['profile pic']),
                              title: new Text(
                                document['username'],
                                style: TextStyle(fontSize: 15),
                              ),
                              onTap: () {
                                setState(() {
                                  textcontroller.clear();
                                  name = "";
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherProfilePage(
                                              name: document['username'],
                                              profilePic:
                                                  document['profile pic'],
                                              posts: document['posts'],
                                              followers: document['followers'],
                                              following: document['following'],
                                              email: document['email'],
                                              uid: document['uid'],
                                            )));
                              },
                            );
                          }).toList(),
                        );
                    }
                  })),
          SizedBox(
            height: 20,
          ),
          Text(
            'Clear Search',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                color: Colors.grey.withAlpha(100),
                height: 0.05,
              )),
        ],
      ),
    );
  }

  //猜你想搜
  _getGuessLayout() {
    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: AspectRatio(
          aspectRatio: 4.0,
          child: Container(
            decoration: BoxDecoration(
              color: ColorPlate.darkGray,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              'Hellooo =)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.1),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
    /*
    List<String> guessList = [
      '大师姐健身',
      '短剧创作者扶持',
      '刘亦菲路演',
      '抖来跳舞',
      '蔡依林美杜莎',
      '李子柒中国风'
    ];
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  '猜你想搜',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Expanded(child: SizedBox()),
                Text(
                  '换一换',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(
                  width: 5,
                ),
                //   Image.asset('assets/images/exchange.webp',color: ColorRes.color_2,width: 18,height: 18,)
              ],
            ),
            SizedBox(
              height: 15,
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: guessList.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6,
              ),
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        guessList[index],
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      //Image.asset(
                      //  index % 2 == 0
                      //      ? 'assets/images/tag_hot.webp'
                      //      : 'assets/images/tag_recomment.webp',
                      //  width: 18,
                      //  height: 18,
                      //  )
                      Text("sup")
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey.withAlpha(100),
              height: 0.05,
            ),
          ],
        ),
      ),
    );
    */
  }

  ///获取榜单的bar

  _getRankingBarLayout() {
    return SliverToBoxAdapter(
      child: SearchRankingBarWidget(
        onClick: (index) {
          _pageController.animateToPage(index,
              duration: Duration(microseconds: 200), curve: Curves.linear);
        },
      ),
    );
  }

  ///获取排行榜
  _getPageLayout() {
    return SliverToBoxAdapter(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: PageView.builder(
            controller: _pageController,
            //   itemCount: 5,
            //TODO change item count when adding more tabs
            itemCount: 2,
            onPageChanged: (index) {
              _searchPageController.setIndexSelectedRank(index);
            },
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return SearchHotRankWidget();
                //   return Text("hi");
                case 1:
                  return SearchHotRankWidget();
                //    return SearchStarRankWidget();
                //     case 2:
                //    return SearchLivingRankWidget();
                //      case 3:
                //  return SearchMusicRankWidget();
                //     case 4:
                //  return SearchBrandRankWidget();
                default:
                  return Container();
              }
            }),
      ),
    );
  }
}

class SearchPageController extends GetxController {
  var indexSelectedRank = 0.obs;

  void setIndexSelectedRank(int index) {
    indexSelectedRank.value = index;
  }
}

class SearchRankingBarWidget extends StatefulWidget {
  ValueChanged<int> onClick;
  SearchRankingBarWidget({Key? key, required this.onClick}) : super(key: key);

  @override
  _SearchRankingBarWidgetState createState() {
    return _SearchRankingBarWidgetState();
  }
}

class _SearchRankingBarWidgetState extends State<SearchRankingBarWidget> {
  SearchPageController _searchPageController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _searchPageController.setIndexSelectedRank(0);
                  widget.onClick(0);
                });
              },
              child: Text(
                'Recommended Users',
                //   gradient: _searchPageController.indexSelectedRank.value == 0?LinearGradient(colors: [Color.fromARGB(255, 237, 157, 88), Color.fromARGB(255, 243, 70, 107),])
                //     :LinearGradient(colors: [ColorRes.color_2,ColorRes.color_2]),
                style: TextStyle(
                    color: _searchPageController.indexSelectedRank.value == 0
                        ? Colors.white
                        : Colors.grey,
                    fontWeight:
                        _searchPageController.indexSelectedRank.value == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: _searchPageController.indexSelectedRank.value == 0
                        ? 18
                        : 16),
              ),
            ),

            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _searchPageController.setIndexSelectedRank(1);
                  widget.onClick(1);
                });
              },
              child: Text(
                'Recent Search',
                style: TextStyle(
                    color: _searchPageController.indexSelectedRank.value == 1
                        ? Colors.white
                        : Colors.grey,
                    fontWeight:
                        _searchPageController.indexSelectedRank.value == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: _searchPageController.indexSelectedRank.value == 1
                        ? 18
                        : 16),
              ),
            ),
            //TODO removing features for the search user screen
            /*
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _searchPageController.setIndexSelectedRank(2);
                  widget.onClick(2);
                });
              },
              
              child: Text(
                '直播榜',
                style: TextStyle(
                    color: _searchPageController.indexSelectedRank.value == 2
                        ? Colors.white
                        : Colors.grey,
                    fontWeight:
                        _searchPageController.indexSelectedRank.value == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: _searchPageController.indexSelectedRank.value == 2
                        ? 18
                        : 16),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _searchPageController.setIndexSelectedRank(3);
                  widget.onClick(3);
                });
              },
              child: Text(
                '音乐榜',
                style: TextStyle(
                    color: _searchPageController.indexSelectedRank.value == 3
                        ? Colors.white
                        : Colors.grey,
                    fontWeight:
                        _searchPageController.indexSelectedRank.value == 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: _searchPageController.indexSelectedRank.value == 3
                        ? 18
                        : 16),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _searchPageController.setIndexSelectedRank(4);
                  widget.onClick(4);
                });
              },
              child: Text(
                '品牌榜',
                style: TextStyle(
                    color: _searchPageController.indexSelectedRank.value == 4
                        ? Colors.white
                        : Colors.grey,
                    fontWeight:
                        _searchPageController.indexSelectedRank.value == 4
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: _searchPageController.indexSelectedRank.value == 4
                        ? 18
                        : 16),
              ),
              
            ),
            */
          ],
        ),
      ),
    );
  }
}
