// import 'package:flutter/material.dart';

// class SelectableImageWidget extends StatelessWidget {
//   final String image;
//   final bool isSelected;
//   final Function(int) onSelect;

//   SelectableImageWidget(
//       {required this.image, required this.isSelected, required this.onSelect});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               image,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         // if (isSelected)

//         Positioned(
//           top: 0,
//           right: 0,
//           child: IconButton(
//             padding: EdgeInsets.zero,
//             onPressed: () => onSelect(image.id),
//             icon: Icon(
//                 isSelected
//                     ? Icons.check_circle
//                     : Icons.check_circle_outline_outlined,
//                 color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// }
