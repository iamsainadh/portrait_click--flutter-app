import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:portrait_click/provider/user_provider.dart';
import 'package:portrait_click/screens/comment_screen.dart';
import 'package:portrait_click/services/firestore_service.dart';
import 'package:portrait_click/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class PortraitPoster extends StatefulWidget {
  final snap;
  const PortraitPoster({super.key, this.snap});

  @override
  State<PortraitPoster> createState() => _PortraitPosterState();
}

class _PortraitPosterState extends State<PortraitPoster> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreService().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    Future<bool> onLikeButtonTapped(bool isLiked) async {
      FireStoreService().likePost(
        widget.snap['postId'].toString(),
        userProvider.getUser.uid,
        widget.snap['likes'],
      );
      return !isLiked;
    }

    return Column(children: [
      SizedBox(
        height: mHeight / 90,
      ),
      //Screen

      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Container(
              width: mWidth / 1.05,
              height: mHeight / 1.32,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //User Profile Image and Username
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(widget.snap["profImage"].toString()),
                      ),
                      SizedBox(
                        width: mWidth / 23,
                      ),
                      Text(
                        widget.snap["username"].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: widget.snap['uid'].toString() ==
                                  userProvider.getUser.uid
                              ? IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.ellipsisVertical,
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Wrap(children: [
                                          ListView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shrinkWrap: true,
                                              children: [
                                                'Delete',
                                              ]
                                                  .map(
                                                    (e) => InkWell(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                        child: Text(e),
                                                      ),
                                                      onTap: () {
                                                        deletePost(
                                                          widget.snap['postId']
                                                              .toString(),
                                                        );
                                                        // remove the dialog box
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  )
                                                  .toList()),
                                        ]);
                                      },
                                    );
                                  },
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mHeight / 100,
                  ),

                  //Image Section

                  Card(
                    elevation: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    shadowColor: Colors.black,
                    child: Container(
                      width: mWidth / 1,
                      height: mHeight / 1.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.snap["postUrl"].toString(),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mHeight / 90,
                  ),

                  SizedBox(
                    height: mHeight / 35,
                    width: mWidth / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(widget.snap["description"].toString()),
                    ),
                  ),
                  SizedBox(
                    height: mHeight / 90,
                  ),
                  //Icons Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      badges.Badge(
                        badgeContent: Text("${widget.snap['likes'].length}"),
                        child: LikeButton(
                            onTap: onLikeButtonTapped,
                            likeBuilder: (bool isLiked) {
                              return FaIcon(
                                widget.snap['likes'].contains(
                                            userProvider.getUser.uid) ||
                                        isLiked
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: widget.snap['likes'].contains(
                                            userProvider.getUser.uid) ||
                                        isLiked
                                    ? Colors.redAccent
                                    : Colors.black,
                              );
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CommentsScreen(
                                      postId: widget.snap['postId'].toString()),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: badges.Badge(
                            badgeContent: Text("$commentLen"),
                            child: const FaIcon(FontAwesomeIcons.comment)),
                      ),
                      const FaIcon(FontAwesomeIcons.bookmark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
