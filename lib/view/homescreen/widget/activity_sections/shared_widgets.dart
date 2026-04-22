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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(value)),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
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
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(value)),
            ],
          ),
        ),
      ],
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(
      text: title,
    );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...details.entries.map((entry) {
            final controller = TextEditingController(text: entry.value);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: entry.key,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            );
          }).toList(),
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
    return 
    Container(
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
              Icons.upload,                        // ← upload icon as requested
              color: const Color(0xFF2D3A8C),      // dark navy, matches screenshot
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
