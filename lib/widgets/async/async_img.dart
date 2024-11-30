import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AsyncDynamicHeightContainer extends StatefulWidget {
  final String imgUrl;
  final ValueNotifier<bool> errorNotifier; // 에러 상태를 부모에게 전달

  const AsyncDynamicHeightContainer({super.key, required this.imgUrl, required this.errorNotifier});

  @override
  AsyncDynamicHeightContainerState createState() => AsyncDynamicHeightContainerState();
}

class AsyncDynamicHeightContainerState extends State<AsyncDynamicHeightContainer> with AutomaticKeepAliveClientMixin{
  get url => widget.imgUrl;
  late Future<Size> _imageSizeFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _imageSizeFuture = _getImageSize(widget.imgUrl);
  }

  Future<Size> _getImageSize(url) async {
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
    super.build(context);
    return Container(
        child: FutureBuilder<Size>(
          future: _imageSizeFuture, // 이미지 크기 로드
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.errorNotifier.value = true; // 에러 상태 업데이트
              });
              return Center(child: Text("Failed to load image"));
            } else if (snapshot.hasData) {
              // 이미지 로드 완료
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.errorNotifier.value = false; // 에러 상태 업데이트
              });
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
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.fitHeight, // 기존의 BoxFit 옵션 유지
                            placeholder: (BuildContext context, String url) {
                              return Center(
                                child: CircularProgressIndicator(), // 로딩 상태 표시
                              );
                            },
                            errorWidget: (BuildContext context, String url, dynamic error) {
                              return Center(
                                child: Text('Image failed to load'), // 에러 상태 표시
                              );
                            },
                          )

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
