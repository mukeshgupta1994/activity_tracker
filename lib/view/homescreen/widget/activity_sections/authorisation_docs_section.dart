import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:activity_tracker/view/homescreen/widget/activity_card.dart';
import 'package:activity_tracker/view/homescreen/widget/activity_sections/shared_widgets.dart' hide FileCard;
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/components/components.dart';

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
            ResponsiveRow(
              children: [
                const Expanded(child: SizedBox()),
                const SizedBox(width: 10),
                const Expanded(child: SizedBox()),
                const SizedBox(width: 10),
                const Expanded(child: SizedBox()),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: CustomButton(
                      onPressed: widget.onSaved,
                      text: 'Save',
                    ),
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





