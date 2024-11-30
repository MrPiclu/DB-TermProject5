import 'package:flutter/material.dart';

class UploadOverlay extends StatefulWidget {
  @override
  State<UploadOverlay> createState() => _UploadOverlayState();
}

class _UploadOverlayState extends State<UploadOverlay> {
  final GlobalKey _buttonKey = GlobalKey();
  final TextEditingController tweetPictureUploadController = TextEditingController();
  final TextEditingController tweetContentController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final List<OverlayEntry> overlays = [];
  String? imgUrl;
  bool hasImg = false;

  void addOverlay() {
    if (overlays.isNotEmpty) {
      removeOverlay();
    } else {
      overlays.add(overlayEntry);
      Overlay.of(context).insert(overlays.last);
    }
  }

  void removeOverlay() {
    if (overlays.isNotEmpty) overlays.removeLast().remove();
    setState(() {
      tweetPictureUploadController.clear();
    });
  }

  OverlayEntry get overlayEntry {
    final ValueNotifier<bool> errorNotifier = ValueNotifier<bool>(false);
    final RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    bool _hasText = false;
    bool _isSearchingImg = false;

    return OverlayEntry(
      opaque: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                // GestureDetector로 바깥 클릭 시 오버레이 닫기
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      removeOverlay();
                    },
                  ),
                ),
                Positioned(
                  top: offset.dy + size.height, // 버튼 바로 아래에 위치
                  left: offset.dx, // 버튼의 왼쪽 정렬
                  child: Container(
                    height: _isSearchingImg ? 300 : 120,
                    width: 210,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: formKey,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextFormField(
                                  controller: tweetPictureUploadController,
                                  validator: (val) => val == "" ? "Please enter" : null,
                                  onChanged: (val) {
                                    setState(() {
                                      _hasText = val.isNotEmpty;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Image Url..',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _hasText && _isSearchingImg
                                ? Center(child: Text("Loading Image...")) // Replace with image container
                                : SizedBox(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: errorNotifier,
                            builder: (context, hasError, child) {
                              return FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    if (hasError) {
                                      hasImg = false;
                                    } else if (_isSearchingImg) {
                                      hasImg = true;
                                      imgUrl = tweetPictureUploadController.text;
                                    } else {
                                      _isSearchingImg = true;
                                    }
                                  });
                                },
                                backgroundColor: _hasText ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                child: Icon(hasError ? Icons.error : hasImg ? Icons.check : Icons.search),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildUploadOverlay(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 119,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(radius: 25), // Example avatar
                const SizedBox(width: 13),
                Form(
                  key: formKey1,
                  child: Expanded(
                    child: TextFormField(
                      controller: tweetContentController,
                      validator: (val) => val == "" ? "Please enter" : null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "What's Happening",
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 45),
                IconButton(
                  key: _buttonKey,
                  onPressed: addOverlay,
                  icon: Icon(Icons.image),
                ),
                Expanded(child: Container()),
                FloatingActionButton(
                  onPressed: () {
                    print("Upload Tweet");
                  },
                  child: Icon(Icons.upload),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Section")),
      body: _buildUploadOverlay(context),
    );
  }
}
