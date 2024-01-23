// import 'package:flutter/material.dart';

// class Menu extends StatelessWidget {
//   const Menu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MenuAnchor(
//       anchorTapClosesMenu: true,
//       builder: (
//         context,
//         MenuController controller,
//         Widget? child,
//       ) {
//         return IconButton(
//           onPressed: () {
//             if (controller.isOpen) {
//               controller.close();
//             } else {
//               controller.open();
//             }
//           },
//           icon: const Icon(Icons.more_vert_outlined),
//           hoverColor: Colors.pink,
//           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//         );
//       },
//       onOpen: () => isInMenu.value = true,
//       onClose: () => isInMenu.value = false,
//       menuChildren: [
//         ..._getMenuItems(context).map((menuItem) {
//           return MenuItemButton(
//             onPressed: () => menuItem.onTap(tabId),
//             child: Text(menuItem.title),
//           );
//         }),
//       ],
//     );
//   }
// }
