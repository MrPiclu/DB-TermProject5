import 'dart:async';
import 'package:flutter/material.dart';

class AsyncDynamicHeightContainer extends StatefulWidget {
  final String imgUrl;

  const AsyncDynamicHeightContainer({super.key, required this.imgUrl});

  @override
  AsyncDynamicHeightContainerState createState() => AsyncDynamicHeightContainerState();
}

class AsyncDynamicHeightContainerState extends State<AsyncDynamicHeightContainer> {
  get url => widget.imgUrl;

  Future<Size> getImageSize(url) async {
    final Completer<Size> completer = Completer();

    // 네트워크 이미지를 로드하고 크기를 계산
    final Image image = Image.network(url);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) {
          final Size size = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
          completer.complete(size);
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        child: FutureBuilder<Size>(
          future: getImageSize(url), // 이미지 크기 로드
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 이미지 로딩 중
              return Container(
                  child: Center(
                      child: CircularProgressIndicator()
                  )
              );
            } else if (snapshot.hasError) {
              // 이미지 로드 실패
              return Center(child: Text("Failed to load image"));
            } else if (snapshot.hasData) {
              // 이미지 로드 완료
              final Size size = snapshot.data!;
              final double aspectRatio = size.width / size.height;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 510,
                ),
                child: Container(
                  width: aspectRatio * 510,

                  decoration: BoxDecoration(
                  ),
                  child: AspectRatio(
                        aspectRatio: aspectRatio, // 이미지의 가로/세로 비율 적용
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // image: DecorationImage(
                            //   image: NetworkImage(url),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          child: Image.network(url, fit: BoxFit.fitHeight, key: ValueKey(url),
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child; // 이미지를 정상적으로 로드했을 때 표시
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null, // 진행 상태를 표시
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Center(
                                child: Text('Image failed to load'),
                              );
                            },
                          ),

                        ),
                      ),
                ),
              );
            }
            return SizedBox(); // 기본 빈 상태
          },
        ),
      );
  }
}
