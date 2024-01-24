// import 'package:flutter/material.dart';

// class SimpleDialog extends StatelessWidget {
//   const SimpleDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomDialog.show(
//       context: context,
//       title: Text('Delete ${tab.title}'),
//       content: SizedBox(
//         height: 20,
//         child: Text(
//           "Are you sure you want to delete ${tab.title} and all it's data?",
//         ),
//       ),
//       actions: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             OutlinedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             gap10,
//             ElevatedButton(
//               onPressed: () {
//                 context.read<HomeBloc>().add(
//                       HomeEvent.onLongPressedDeleteTab(
//                         tab.id,
//                       ),
//                     );
//                 if (Navigator.canPop(context)) {
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         )
//       ],
//     );
//     ;
//   }
// }
