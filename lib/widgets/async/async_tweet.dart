// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class AsyncTweetContainer extends StatefulWidget {
//   final String imgUrl;
//
//   const AsyncTweetContainer({super.key, required this.imgUrl});
//
//   @override
//   AsyncTweetContainerState createState() => AsyncTweetContainerState();
// }
//
// class AsyncTweetContainerState extends State<AsyncTweetContainer> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//         child: FutureBuilder<Size>(
//           future: getImageSize(url), // 이미지 크기 로드
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               // 이미지 로딩 중
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               // 이미지 로드 실패
//               return Center(child: Text("Failed to load image"));
//             } else if (snapshot.hasData) {
//               // 이미지 로드 완료
//               final Size size = snapshot.data!;
//               final double aspectRatio = size.width / size.height;
//
//               return ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxHeight: 510,
//                 ),
//                 child: Container(
//                   width: aspectRatio * 510,
//
//                   decoration: BoxDecoration(
//                   ),
//                   child: AspectRatio(
//                         aspectRatio: aspectRatio, // 이미지의 가로/세로 비율 적용
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               image: NetworkImage(url),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                 ),
//               );
//             }
//             return SizedBox(); // 기본 빈 상태
//           },
//         ),
//       );
//   }
// }
