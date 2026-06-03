import 'package:flutter/material.dart';

// Shared data models
class AgencyPartnerData {
  String title;
  Map<String, String> details;

  AgencyPartnerData({required this.title, required this.details});
}

class ExecutionElementData {
  String title;
  Map<String, String> details;

  ExecutionElementData({required this.title, required this.details});
}

class DocumentData {
  String label;
  bool isUploaded;
  bool isEditable;
  String? base64File;

  DocumentData({
    required this.label,
    this.isUploaded = false,
    this.isEditable = false,
    this.base64File,
  });
}
// Shared UI components (public)
// class DropdownField extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final VoidCallback? onTap;

//   const DropdownField({
//     required this.label,
//     required this.value,
//     required this.icon,
//     this.onTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: Theme.of(context).textTheme.labelLarge),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: onTap,
//           child: Container(

//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(12),

//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   color: Theme.of(context).colorScheme.primary,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text(value)),
//                 const Icon(Icons.arrow_drop_down, color: Colors.grey),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const DropdownField({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = value.toLowerCase().contains('select');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: 6),

        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.6),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      color: isPlaceholder ? Theme.of(context).hintColor : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: Theme.of(context).hintColor.withOpacity(0.9),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MultiSelectDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> selectedNames;
  final Function(BuildContext context) onTap;

  const MultiSelectDropdownField({
    required this.label,
    required this.hint,
    required this.selectedNames,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => onTap(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.08),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: selectedNames.isEmpty
                        ? [
                            Text(
                              hint,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).hintColor.withOpacity(0.5),
                                  ),
                            ),
                          ]
                        : selectedNames.map((name) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                name,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            );
                          }).toList(),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: Theme.of(context).hintColor.withOpacity(0.9),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DisplayField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const DisplayField({
    required this.label,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).hintColor, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class EditableDetailCard extends StatelessWidget {
//   final String title;
//   final Map<String, String> details;
//   final VoidCallback? onDelete;

//   const EditableDetailCard({
//     required this.title,
//     required this.details,
//     this.onDelete,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController titleController = TextEditingController(
//       text: title,
//     );
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(
//                     labelStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                     hintText: "Title",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 12,
//                     ),
//                   ),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               if (onDelete != null)
//                 IconButton(
//                   onPressed: onDelete,
//                   icon: const Icon(Icons.delete_outline, color: Colors.red),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...details.entries.map((entry) {
//             final controller = TextEditingController(text: entry.value);
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   labelStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 12,
//                   ),
//                   labelText: entry.key,
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
class EditableDetailCard extends StatelessWidget {
  final String title;
  final Map<String, String> details;
  final VoidCallback? onDelete;

  const EditableDetailCard({
    required this.title,
    required this.details,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  // 🔹 Common Decoration
  InputDecoration _decoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      labelStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 12,
      ),

      hintStyle: TextStyle(
        color: Theme.of(context).hintColor.withOpacity(0.6),
        fontSize: 12,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.08),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: title);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.06),
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: titleController,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: _decoration(context, "Title"),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                ),
            ],
          ),

          const SizedBox(height: 8),

          ResponsiveRow(
            children: details.entries.map((entry) {
              final controller = TextEditingController(text: entry.value);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(fontSize: 12),
                      decoration: _decoration(context, entry.key),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class FileCard extends StatelessWidget {
  final String label;
  final bool isUploaded;
  final VoidCallback? onUpload;

  const FileCard({
    required this.label,
    required this.isUploaded,
    this.onUpload,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Left: document icon
          Icon(
            Icons.insert_drive_file_outlined,
            color: Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 14),

          // Label
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          // Green checkmark (only when uploaded)
          if (isUploaded) ...[
            const Icon(Icons.check_circle, color: Colors.green, size: 22),
            const SizedBox(width: 10),
          ],

          // Upload / re-upload icon button
          GestureDetector(
            onTap: onUpload,
            child: Icon(
              Icons.upload, // ← upload icon as requested
              color: const Color(0xFF2D3A8C), // dark navy, matches screenshot
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;

  const ActionCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class DropdownBottomSheet extends StatelessWidget {
  final String type;
  final List<Map<String, dynamic>> options; // ✅ FIXED
  final Function(int id, String name) onSelect;

  const DropdownBottomSheet({
    required this.type,
    required this.options,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    type == "Brand"
                        ? Icons.branding_watermark
                        : type == "Product"
                        ? Icons.category
                        : Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  type == "Brand"
                      ? "Select Brand"
                      : type == "Product"
                      ? "Select Product"
                      : type == "Medium"
                      ? "Select Medium"
                      : type == "Agency"
                      ? "Select Agency"
                      : "Select Status",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(indent: 24, endIndent: 24, height: 32),

          /// ✅ GRID LIST
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final item = options[index];

                final int id = item['id'] ?? 0;
                final String name = item['name'] ?? '';

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelect(id, name), // ✅ FIXED
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.12),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLowest,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.10),
                            child: Text(
                              name.isNotEmpty ? name[0] : "?",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const ResponsiveRow({
    Key? key,
    required this.children,
    this.spacing = 10.0,
    this.runSpacing = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children.map((child) {
          if (child is Expanded || child is Flexible) {
            // Strip out Expanded/Flexible for Column layout so they just take natural height
            final innerChild = (child as dynamic).child as Widget;
            return Padding(
              padding: EdgeInsets.only(bottom: runSpacing),
              child: innerChild,
            );
          }
          if (child is SizedBox &&
              child.width != null &&
              child.height == null) {
            return const SizedBox.shrink(); // Ignore horizontal spacers in Column
          }
          return Padding(
            padding: EdgeInsets.only(bottom: runSpacing),
            child: child,
          );
        }).toList(),
      );
    }

    // Desktop/Tablet -> Use original Row layout
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: children);
  }
}

class MultiSelectBottomSheet extends StatefulWidget {
  final String type;
  final List<Map<String, dynamic>> options;
  final List<int> selectedIds;
  final Function(List<int> ids, List<String> names) onSelect;

  const MultiSelectBottomSheet({
    required this.type,
    required this.options,
    required this.selectedIds,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<MultiSelectBottomSheet> createState() => _MultiSelectBottomSheetState();
}

class _MultiSelectBottomSheetState extends State<MultiSelectBottomSheet> {
  late List<int> _currentSelectedIds;

  @override
  void initState() {
    super.initState();
    _currentSelectedIds = List.from(widget.selectedIds);
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_currentSelectedIds.contains(id)) {
        _currentSelectedIds.remove(id);
      } else {
        _currentSelectedIds.add(id);
      }
    });
  }

  void _confirmSelection() {
    final selectedNames = widget.options
        .where((opt) => _currentSelectedIds.contains(opt['id']))
        .map((opt) => opt['name'] as String)
        .toList();
    widget.onSelect(_currentSelectedIds, selectedNames);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.checklist_rtl_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Select Multiple ${widget.type}s",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _confirmSelection();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const Divider(indent: 24, endIndent: 24, height: 32),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final item = widget.options[index];
                final int id = item['id'] ?? 0;
                final String name = item['name'] ?? '';
                final bool isSelected = _currentSelectedIds.contains(id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.12),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05)
                        : Theme.of(context).colorScheme.surfaceContainerLowest,
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (val) => _toggleSelection(id),
                    title: Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),
                    activeColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectDropdownPopup extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final List<int> selectedIds;
  final Function(List<int> ids, List<String> names) onSelect;
  final VoidCallback? onClose;

  const MultiSelectDropdownPopup({
    required this.options,
    required this.selectedIds,
    required this.onSelect,
    this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  State<MultiSelectDropdownPopup> createState() =>
      _MultiSelectDropdownPopupState();
}

class _MultiSelectDropdownPopupState extends State<MultiSelectDropdownPopup> {
  late List<int> _currentSelectedIds;

  @override
  void initState() {
    super.initState();
    _currentSelectedIds = List.from(widget.selectedIds);
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_currentSelectedIds.contains(id)) {
        _currentSelectedIds.remove(id);
      } else {
        _currentSelectedIds.add(id);
      }
    });

    // Automatically trigger onSelect on every change to behave more like a realtime dropdown
    final selectedNames = widget.options
        .where((opt) => _currentSelectedIds.contains(opt['id']))
        .map((opt) => opt['name'] as String)
        .toList();
    widget.onSelect(_currentSelectedIds, selectedNames);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Options",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              InkWell(
                onTap: widget.onClose ?? () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget.options.length,
            itemBuilder: (context, index) {
              final item = widget.options[index];
              final int id = item['id'] ?? 0;
              final String name = item['name'] ?? '';
              final bool isSelected = _currentSelectedIds.contains(id);

              return InkWell(
                onTap: () => _toggleSelection(id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05)
                        : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black87,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
