import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:activity_tracker/view/homescreen/widget/activity_card.dart';
import 'package:activity_tracker/view/homescreen/widget/activity_sections/shared_widgets.dart' hide FileCard;
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorisationDocsSection extends StatefulWidget {
  final VoidCallback? onSaved;
  final VoidCallback? onSkip;

  const AuthorisationDocsSection({
    Key? key,
    this.onSaved,
    this.onSkip,
  }) : super(key: key);

  @override
  State<AuthorisationDocsSection> createState() =>
      _AuthorisationDocsSectionState();
}

class _AuthorisationDocsSectionState
    extends State<AuthorisationDocsSection> {

  List<DocumentData> _docs = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDocs();
    });
  }

  /// ✅ FETCH VIEW DATA
  Future<void> _fetchDocs() async {
    final vm = context.read<ActivityDashViewModel>();

    await vm.fetchAuthorisationDocs();

    setState(() {
      _docs = vm.authDocsList.map((e) {
        return DocumentData(
          label: e.authDescription ?? "No Name",
          isUploaded: true,
          isEditable: false,
        );
      }).toList();
    });
  }

  /// ➕ ADD DOC
  void _addDoc() {
    setState(() {
      _docs.add(
        DocumentData(
          label: '',
          isUploaded: false,
          isEditable: true,
        ),
      );
    });
  }

  /// 📤 UPLOAD ONLY (NO VIEW / NO DOWNLOAD)
  Future<void> _handleUpload(int index) async {
  final vm = context.read<ActivityDashViewModel>();
  final doc = _docs[index];

  if (doc.label.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter document name")),
    );
    return;
  }

  try {
    final result = await FilePicker.pickFiles(
      withData: true,
    );

    if (result == null) return;

    final file = result.files.first;

    Uint8List? bytes = file.bytes;

    /// ✅ FIX
    if (bytes == null && file.path != null) {
      bytes = await File(file.path!).readAsBytes();
    }

    if (bytes == null) {
      throw Exception("File bytes still null");
    }

    final base64File = base64Encode(bytes);
    final ext = file.extension ?? '';

    final success = await vm.uploadDocument(
      activityId: 40,
      userId: "5",
      description: doc.label,
      fileBytes: base64File,
      fileExt: ext,
    );

    if (success) {
      setState(() {
        doc.isUploaded = true;
        doc.isEditable = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${doc.label} uploaded")),
      );
    } else {
      throw Exception("Upload failed");
    }
  } catch (e) {
    debugPrint("Upload Error: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Upload Failed")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Consumer<ActivityDashViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoadingAuthDocs) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            ..._docs.asMap().entries.map((entry) {
              final i = entry.key;
              final doc = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),

                /// ✏️ EDIT MODE
                child: doc.isEditable
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                onChanged: (val) => doc.label = val,
                                decoration: const InputDecoration(
                                  hintText: "Enter document name",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                if (doc.label.trim().isEmpty) return;

                                setState(() {
                                  doc.isEditable = false;
                                });
                              },
                            )
                          ],
                        ),
                      )

                    /// 📁 FILE CARD (NO VIEW CLICK)
                    : FileCard(
                        label: doc.label,
                        isUploaded: doc.isUploaded,

                        /// 🔥 ONLY UPLOAD ALLOWED
                        onUpload: doc.isUploaded
                            ? null   // ❌ disable click after upload
                            : () => _handleUpload(i),
                      ),
              );
            }),

            const SizedBox(height: 4),

            /// ➕ ADD DOC
            TextButton.icon(
              onPressed: _addDoc,
              icon: Icon(Icons.add_circle_outline, color: primary),
              label: Text(
                'Add New Authorisation Doc',
                style: TextStyle(color: primary),
              ),
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onSkip,
                    child: const Text('Skip to Next'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onSaved,
                    child: const Text('Save & Next'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}



// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:activity_tracker/view/homescreen/widget/activity_sections/shared_widgets.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';


// class AuthorisationDocsSection extends StatefulWidget {
//   final VoidCallback? onSaved;
//   final VoidCallback? onSkip;

//   const AuthorisationDocsSection({
//     Key? key,
//     this.onSaved,
//     this.onSkip,
//   }) : super(key: key);

//   @override
//   State<AuthorisationDocsSection> createState() =>
//       _AuthorisationDocsSectionState();
// }

// class _AuthorisationDocsSectionState
//     extends State<AuthorisationDocsSection> {

//   List<DocumentData> _docs = [];

//   @override
//   void initState() {
//     super.initState();

//     /// ✅ FETCH VIEW DATA
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchDocs();
//     });
//   }

//   Future<void> _fetchDocs() async {
//     final vm = context.read<ActivityDashViewModel>();

//     await vm.fetchAuthorisationDocs();

//     /// ✅ MAP API → UI MODEL
//     setState(() {
//       _docs = vm.authDocsList.map((e) {
//         return DocumentData(
//           label: e.authDescription ?? "",
//           isUploaded: true,
//           isEditable: false,
//           base64File: e.fileInputAuth,
//         );
//       }).toList();
//     });
//   }

//   /// ➕ ADD NEW DOC
//   void _addDoc() {
//     setState(() {
//       _docs.add(
//         DocumentData(
//           label: '',
//           isUploaded: false,
//           isEditable: true,
//         ),
//       );
//     });
//   }

//   /// 📤 UPLOAD
//   Future<void> _handleUpload(int index) async {
//     final vm = context.read<ActivityDashViewModel>();
//     final doc = _docs[index];

//     if (doc.label.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enter document name")),
//       );
//       return;
//     }

//     try {
//       final result = await FilePicker.pickFiles(withData: true);

//       if (result == null) return;

//       final file = result.files.first;

//       if (file.bytes == null) {
//         throw Exception("File bytes null");
//       }

//       final base64File = base64Encode(file.bytes!);
//       final ext = file.extension ?? '';

//       final success = await vm.uploadDocument(
//         activityId: 40,
//         userId: "5",
//         description: doc.label,
//         fileBytes: base64File,
//         fileExt: ext,
//       );

//       if (success) {
//         setState(() {
//           doc.isUploaded = true;
//           doc.isEditable = false;
//           doc.base64File = base64File;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("${doc.label} uploaded")),
//         );
//       } else {
//         throw Exception("Upload failed");
//       }
//     } catch (e) {
//       debugPrint("Upload Error: $e");

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Upload Failed")),
//       );
//     }
//   }

//   /// 📂 OPEN FILE
//   Future<void> _openFile(String? base64Data) async {
//     try {
//       if (base64Data == null || base64Data.isEmpty) return;

//       Uint8List bytes = base64Decode(base64Data);

//       final dir = await getTemporaryDirectory();
//       final file = File("${dir.path}/auth_doc.xlsx");

//       await file.writeAsBytes(bytes);

//       await OpenFile.open(file.path);
//     } catch (e) {
//       debugPrint("File open error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).colorScheme.primary;

//     return Consumer<ActivityDashViewModel>(
//       builder: (context, vm, child) {
//         if (vm.isLoadingAuthDocs) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 16),

//             /// 📄 DOCUMENT LIST
//             ..._docs.asMap().entries.map((entry) {
//               final i = entry.key;
//               final doc = entry.value;

//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),

//                 /// ✏️ EDIT MODE
//                 child: doc.isEditable
//                     ? Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 14, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 autofocus: true,
//                                 onChanged: (val) => doc.label = val,
//                                 decoration: const InputDecoration(
//                                   hintText: "Enter document name",
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.check),
//                               onPressed: () {
//                                 if (doc.label.trim().isEmpty) return;

//                                 setState(() {
//                                   doc.isEditable = false;
//                                 });
//                               },
//                             )
//                           ],
//                         ),
//                       )

//                     /// 📁 NORMAL CARD
//                     : FileCard(
//                         label: doc.label,
//                         isUploaded: doc.isUploaded,

//                         /// 🔥 VIEW / UPLOAD
//                         onUpload: () {
//                           if (doc.isUploaded) {
//                             _openFile(doc.base64File);
//                           } else {
//                             _handleUpload(i);
//                           }
//                         },
//                       ),
//               );
//             }),

//             const SizedBox(height: 4),

//             /// ➕ ADD DOC
//             TextButton.icon(
//               onPressed: _addDoc,
//               icon: Icon(Icons.add_circle_outline, color: primary),
//               label: Text(
//                 'Add New Authorisation Doc',
//                 style: TextStyle(color: primary),
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// ACTION BUTTONS
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: widget.onSkip,
//                     child: const Text('Skip to Next'),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: widget.onSaved,
//                     child: const Text('Save & Next'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


// // import 'dart:convert';
// // import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'shared_widgets.dart';

// // class AuthorisationDocsSection extends StatefulWidget {
// //   final VoidCallback? onSaved;
// //   final VoidCallback? onSkip;

// //   const AuthorisationDocsSection({
// //     Key? key,
// //     this.onSaved,
// //     this.onSkip,
// //   }) : super(key: key);

// //   @override
// //   State<AuthorisationDocsSection> createState() =>
// //       _AuthorisationDocsSectionState();
// // }

// // class _AuthorisationDocsSectionState
// //     extends State<AuthorisationDocsSection> {
// //   final List<DocumentData> _docs = [
// //     DocumentData(label: 'Plan', isUploaded: true),
// //     DocumentData(label: 'Estimate', isUploaded: true),
// //     DocumentData(label: 'PO', isUploaded: true),
// //   ];

// //   /// ✅ ADD NEW DOC
// //   void _addDoc() {
// //     setState(() {
// //       _docs.add(
// //         DocumentData(
// //           label: '',
// //           isUploaded: false,
// //           isEditable: true,
// //         ),
// //       );
// //     });
// //   }

// //   /// ✅ UPLOAD API + FILE PICKER
// //   Future<void> _handleUpload(int index) async {
// //     final vm = context.read<ActivityDashViewModel>();
// //     final doc = _docs[index];

// //     if (doc.label.trim().isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please enter document name")),
// //       );
// //       return;
// //     }

// //     try {
// //       /// 📂 PICK FILE
// //   final result = await FilePicker.pickFiles(withData: true);

// //       if (result == null) return;

// //       final file = result.files.first;

// //       if (file.bytes == null) {
// //         throw Exception("File data is null");
// //       }

// //       final base64File = base64Encode(file.bytes!);
// //       final ext = file.extension ?? '';

// //       final success = await vm.uploadDocument(
// //         activityId: 40, 
// //         userId: "5",  
// //         description: doc.label,
// //         fileBytes: base64File,
// //         fileExt: ext,
// //       );

// //       if (success) {
// //         setState(() {
// //           doc.isUploaded = true;
// //           doc.isEditable = false;
// //         });

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("${doc.label} uploaded successfully")),
// //         );
// //       } else {
// //         throw Exception("Upload failed from API");
// //       }
// //     } catch (e) {
// //       debugPrint("Upload Error: $e");

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Upload Failed")),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final primary = Theme.of(context).colorScheme.primary;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         const SizedBox(height: 16),

// //         /// 📄 DOCUMENT LIST
// //         ..._docs.asMap().entries.map((entry) {
// //           final i = entry.key;
// //           final doc = entry.value;

// //           return Padding(
// //             padding: const EdgeInsets.only(bottom: 12),

// //             /// 🔥 TEXTFIELD MODE
// //             child: doc.isEditable
// //                 ? Container(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 14, vertical: 10),
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade100,
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Expanded(
// //                           child: TextField(
// //                             autofocus: true,
// //                             onChanged: (val) => doc.label = val,
// //                             decoration: const InputDecoration(
// //                               hintText: "Enter document name",
// //                               border: InputBorder.none,
// //                             ),
// //                           ),
// //                         ),

// //                         /// ✅ CONFIRM NAME
// //                         IconButton(
// //                           icon: const Icon(Icons.check),
// //                           onPressed: () {
// //                             if (doc.label.trim().isEmpty) {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(
// //                                   content: Text("Enter valid name"),
// //                                 ),
// //                               );
// //                               return;
// //                             }

// //                             setState(() {
// //                               doc.isEditable = false;
// //                             });
// //                           },
// //                         )
// //                       ],
// //                     ),
// //                   )

// //                 /// 📁 NORMAL FILE CARD
// //                 : FileCard(
// //                     label: doc.label,
// //                     isUploaded: doc.isUploaded,
// //                     onUpload: () => _handleUpload(i),
// //                   ),
// //           );
// //         }),

// //         const SizedBox(height: 4),

// //         /// ➕ ADD NEW DOC
// //         TextButton.icon(
// //           onPressed: _addDoc,
// //           icon: Icon(Icons.add_circle_outline, color: primary, size: 20),
// //           label: Text(
// //             'Add New Authorisation Doc',
// //             style: TextStyle(
// //               color: primary,
// //               fontWeight: FontWeight.w600,
// //               fontSize: 14,
// //             ),
// //           ),
// //           style: TextButton.styleFrom(
// //             backgroundColor: primary.withOpacity(0.06),
// //             padding:
// //                 const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //           ),
// //         ),

// //         const SizedBox(height: 20),

// //         /// 🔘 ACTION BUTTONS
// //         Row(
// //           children: [
// //             Expanded(
// //               child: OutlinedButton(
// //                 onPressed: widget.onSkip,
// //                 child: const Text('Skip to Next'),
// //               ),
// //             ),
// //             const SizedBox(width: 14),
// //             Expanded(
// //               child: ElevatedButton(
// //                 onPressed: widget.onSaved,
// //                 child: const Text('Save & Next'),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }





