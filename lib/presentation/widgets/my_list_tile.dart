import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:shop_spectrum/utils/constant/index.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final String subTitle;
  const MyListTile({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isLiked = false;
  int likesCount = 0;
  bool isCommenting = false;
  TextEditingController commentController = TextEditingController();
  List<String> comments = [];

  void onLikeClicked() {
    setState(() {
      if (isLiked) {
        likesCount -= 1;
      } else {
        likesCount += 1;
      }
      isLiked = !isLiked;
    });
  }

  void onCommentClicked() {
    setState(() {
      isCommenting = !isCommenting;
    });
  }

  void onSendCommentClicked() {
    String comment = commentController.text;
    setState(() {
      comments.add(comment);
    });

    // Clear the text field after sending the comment
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.only(
            left: (21 / Dimensions.designWidth).w,
            right: (21 / Dimensions.designWidth).w,
            top: (10 / Dimensions.designHeight).h),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.all(
                  Radius.circular((20 / Dimensions.designWidth).w))),
          child: Padding(
            padding: EdgeInsets.only(
                left: (15 / Dimensions.designWidth).w,
                right: (15 / Dimensions.designWidth).w,
                top: (10 / Dimensions.designHeight).h,
                bottom: (10 / Dimensions.designHeight).h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyles.primaryBold.copyWith(
                    color: Colors.black,
                    fontSize: (20 / Dimensions.designWidth).w,
                  ),
                ),
                Text(
                  widget.subTitle,
                  style: TextStyles.primaryBold.copyWith(
                    color: Colors.black54,
                    fontSize: (10 / Dimensions.designWidth).w,
                  ),
                ),
                SizeBox(
                  height: (10 / Dimensions.designHeight).h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$likesCount Like${likesCount != 1 ? 's' : ''}',
                      style: TextStyles.primaryBold.copyWith(
                        color: Colors.black54,
                        fontSize: (15 / Dimensions.designWidth).w,
                      ),
                    ),
                    Text(
                      '${comments.length} Comment${comments.length != 1 ? 's' : ''}',
                      style: TextStyles.primaryBold.copyWith(
                        color: Colors.black54,
                        fontSize: (15 / Dimensions.designWidth).w,
                      ),
                    ),
                    Text(
                      '0 Share',
                      style: TextStyles.primaryBold.copyWith(
                        color: Colors.black54,
                        fontSize: (15 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                SizeBox(
                  height: (10 / Dimensions.designHeight).h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: onLikeClicked,
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: isLiked ? Colors.blue : Colors.black38,
                            size: (20 / Dimensions.designWidth).w,
                          ),
                          SizedBox(
                              width: (5 / Dimensions.designWidth)
                                  .w), // Optional spacing between icon and text
                          Text(
                            'Like',
                            style: TextStyles.primaryBold.copyWith(
                              color: isLiked ? Colors.blue : Colors.black38,
                              fontSize: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: onCommentClicked,
                      child: Row(
                        children: [
                          Icon(
                            Icons.comment,
                            color: Colors.black38,
                            size: (20 / Dimensions.designWidth).w,
                          ),
                          SizedBox(
                              width: (5 / Dimensions.designWidth)
                                  .w), // Optional spacing between icon and text
                          Text(
                            'Comment',
                            style: TextStyles.primaryBold.copyWith(
                              color: Colors.black54,
                              fontSize: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.black38,
                            size: (20 / Dimensions.designWidth).w,
                          ),
                          SizedBox(
                              width: (5 / Dimensions.designWidth)
                                  .w), // Optional spacing between icon and text
                          Text(
                            'Share',
                            style: TextStyles.primaryBold.copyWith(
                              color: Colors.black54,
                              fontSize: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizeBox(
                  height: (10 / Dimensions.designHeight).h,
                ),
                if (comments.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: comments.map((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(comment),
                      );
                    }).toList(),
                  ),
                if (isCommenting)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: (10 / Dimensions.designHeight).h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizeBox(
                          width: (10 / Dimensions.designWidth).w,
                        ),
                        ElevatedButton(
                          onPressed: onSendCommentClicked,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: Text(
                            'Send',
                            style: TextStyles.primaryBold.copyWith(
                              color: Colors.white,
                              fontSize: (15 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
