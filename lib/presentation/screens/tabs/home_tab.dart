import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shop_spectrum/firebase/firestore.dart';
import 'package:shop_spectrum/presentation/widgets/index.dart';
import 'package:shop_spectrum/presentation/widgets/my_list_tile.dart';
import 'package:shop_spectrum/utils/constant/index.dart';

class HomeTab extends StatefulWidget {
  final String userName;
  const HomeTab({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirestoreDatabase database = FirestoreDatabase();

  final postSomethingController = TextEditingController();

  void postMessage() {
    if (postSomethingController.text.isNotEmpty) {
      String message = postSomethingController.text;
      database.addPost(widget.userName, message);
    }
    postSomethingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: (30 / Dimensions.designHeight).h),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: (100 / Dimensions.designHeight).h,
                        width: (350 / Dimensions.designWidth).w,
                        color: Colors.white,
                        child: CustomTextField(
                          controller: postSomethingController,
                          onChanged: (p0) {},
                          borderRadius: 25,
                          hintText: 'Say Something ...',
                        ),
                      ),
                      SizeBox(
                        height: (30 / Dimensions.designHeight).h,
                      ),
                      GradientButton(
                        onTap: postMessage,
                        text: 'Post',
                        width: (350 / Dimensions.designWidth).w,
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: database.getPostsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading posts."),
                    );
                  }

                  final posts = snapshot.data?.docs;

                  if (snapshot.hasData && posts != null && posts.isNotEmpty) {
                    return Container(
                      height: (600 / Dimensions.designHeight).h,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post =
                              posts[index].data() as Map<String, dynamic>?;

                          if (post != null) {
                            String message = post['PostMessage'] ?? '';
                            String userEmail = post['UserEmail'] ?? '';
                            DateTime timestamp =
                                (post['TimeStamp'] as Timestamp?)?.toDate() ??
                                    DateTime.now();

                            return MyListTile(
                                title: widget.userName, subTitle: message);
                          } else {
                            // Handle the case where the document data is null or doesn't have expected fields.
                            return Container();
                          }
                        },
                      ),
                    );
                  } else {
                    print("No Posts. Post Something!!!");
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Text("No Posts. Post Something!!!"),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
