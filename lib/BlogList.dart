import 'package:flutter/material.dart';

class BlogTile extends StatelessWidget {
  String imgUrl, title, des;

  BlogTile({required this.imgUrl, required this.title, required this.des});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.4),
                borderRadius: BorderRadius.circular(6)),
          ),
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), Text(des)],
            ),
          )
        ],
      ),
    );
  }
}
