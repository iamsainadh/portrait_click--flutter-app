import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:portrait_click/screens/profilescreen.dart';
import 'package:portrait_click/widgets/customappbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: const CustomAppBar(title: "Search"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SearchBar(
              controller: searchController,
              hintText: "Search for user",
              onChanged: (String _) {
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 500,
              height: 500,
              child: isShowUsers
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'username',
                            isGreaterThanOrEqualTo: searchController.text,
                          )
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                PageTransition(
                                    child: ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                    ),
                                    type: PageTransitionType.leftToRight),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['imageUrl'],
                                  ),
                                  radius: 16,
                                ),
                                title: Text(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['username'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('datePublished')
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return MasonryGridView.count(
                          crossAxisCount: 3,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) => Image.network(
                            (snapshot.data! as dynamic).docs[index]['postUrl'],
                            fit: BoxFit.cover,
                          ),
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
