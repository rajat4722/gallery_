// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';

// class GalleryScreen extends StatefulWidget {
//   const GalleryScreen({Key? key}) : super(key: key);

//   @override
//   State<GalleryScreen> createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {
//   final PagingController<int, String> _pagingController =
//       PagingController(firstPageKey: 1);
//   late PhotoViewGalleryController _galleryController;

//   @override
//   void initState() {
//     super.initState();
//     _galleryController = PhotoViewGalleryController();
//     _pagingController.addPageRequestListener((pageKey) {
//       // Fetch images from the API
//       fetchImages(pageKey);
//     });
//   }

//   Future<void> fetchImages(int pageKey) async {
//     var request = http.Request(
//       'GET',
//       Uri.parse('https://picsum.photos/v2/list?page=$pageKey&limit=20'),
//     );

//     try {
//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final List<String> images =
//             (jsonDecode(await response.stream.bytesToString()) as List)
//                 .map((item) => item['download_url'].toString())
//                 .toList();

//         // Append the fetched images to the page
//         final isLastPage = images.length < 20;
//         if (isLastPage) {
//           _pagingController.appendLastPage(images);
//         } else {
//           _pagingController.appendPage(images, pageKey + 1);
//         }
//       } else {
//         print('Error: ${response.reasonPhrase}');
//         _pagingController.error = response.reasonPhrase ?? 'Unknown error';
//       }
//     } catch (error) {
//       print('Error: $error');
//       _pagingController.error = error;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text(
//           'Gallery',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: PagedGridView<int, String>(
//         pagingController: _pagingController,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//         ),
//         builderDelegate: PagedChildBuilderDelegate<String>(
//           itemBuilder: (context, item, index) {
//             return GestureDetector(
//               onTap: () {
//                 _showImagePopup(context, _pagingController.itemList!, index);
//               },
//               child: Hero(
//                 tag: 'photo$index',
//                 child: AnimatedBuilder(
//                   animation: _galleryController.photoViewController,
//                   builder: (context, child) {
//                     return PhotoView(
//                       imageProvider: NetworkImage(item),
//                       controller: _galleryController.photoViewController,
//                       minScale: PhotoViewComputedScale.contained * 0.8,
//                       maxScale: PhotoViewComputedScale.covered * 2,
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//           firstPageProgressIndicatorBuilder: (context) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//           newPageProgressIndicatorBuilder: (context) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _showImagePopup(
//       BuildContext context, List<String> images, int initialIndex) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           insetPadding: EdgeInsets.zero,
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: PhotoViewGallery.builder(
//               itemCount: images.length,
//               builder: (context, index) {
//                 return PhotoViewGalleryPageOptions(
//                   imageProvider: NetworkImage(images[index]),
//                   minScale: PhotoViewComputedScale.contained * 0.8,
//                   maxScale: PhotoViewComputedScale.covered * 2,
//                   heroAttributes: PhotoViewHeroAttributes(tag: 'photo$index'),
//                 );
//               },
//               backgroundDecoration: const BoxDecoration(
//                 color: Colors.black,
//               ),
//               // pageController: _galleryController,
//               pageController: PageController(initialPage: initialIndex),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class PhotoViewGalleryController {
//   get photoViewController =>item;
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 1);
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      // Fetch images from the API
      fetchImages(pageKey);
    });
  }

  Future<void> fetchImages(int pageKey) async {
    var request = http.Request(
      'GET',
      Uri.parse('https://picsum.photos/v2/list?page=$pageKey&limit=20'),
    );

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final List<String> images =
            (jsonDecode(await response.stream.bytesToString()) as List)
                .map((item) => item['download_url'].toString())
                .toList();

        // Append the fetched images to the page
        final isLastPage = images.length < 20;
        if (isLastPage) {
          _pagingController.appendLastPage(images);
        } else {
          _pagingController.appendPage(images, pageKey + 1);
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        _pagingController.error = response.reasonPhrase ?? 'Unknown error';
      }
    } catch (error) {
      print('Error: $error');
      _pagingController.error = error;
    }
  }

  bool isZoomed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Gallery',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PagedGridView<int, String>(
        pagingController: _pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        builderDelegate: PagedChildBuilderDelegate<String>(
          itemBuilder: (context, item, index) {
            return GestureDetector(
              onTap: () {
                // // Open a popup with the selected image
                final itemList = _pagingController.itemList;
                if (itemList != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => _buildPhotoViewGallery(
                          images: itemList, initialIndex: index),
                    ),
                  );
                }
              },
              onTapDown: (details) {
                // Zoom out slightly on tap down
                setState(() {
                  _scale = 0.95; // Adjust the zoom factor as needed
                });
              },
              onTapUp: (details) {
                // Reset zoom back to 1 on tap up
                setState(() {
                  _scale = 1.0;
                });
              },
              child: Transform.scale(
                scale: _scale,
                child: Hero(
                  tag: item,
                  child: Image.network(
                    item,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          firstPageProgressIndicatorBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          newPageProgressIndicatorBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhotoViewGallery(
      {required List<String> images, required int initialIndex}) {
    return PhotoViewGallery.builder(
      itemCount: images.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(images[index]),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          heroAttributes: PhotoViewHeroAttributes(tag: 'photo$index'),
          // onTapUp: (_, __, ___) {
          //   // Reset zoom back to 1 on tap up
          //   setState(() {
          //     _scale = 1.0;
          //   });
          // },
        );
      },
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
      pageController: PageController(initialPage: initialIndex),
      // pageController: _galleryController,
    );
  }
}

class PhotoViewGalleryController {}
