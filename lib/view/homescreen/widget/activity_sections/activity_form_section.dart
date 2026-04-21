import 'package:activity_tracker/components/components.dart';
import 'package:activity_tracker/data/remote/response/api_response.dart';
import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class ActivityFormSection extends StatelessWidget {
  final ActivityDashViewModel vm;
  final bool showActions;
  final VoidCallback? onSaved;

  const ActivityFormSection({
    Key? key,
    required this.vm,
    this.showActions = true,
    this.onSaved,
  }) : super(key: key);

  void _showDropdown(BuildContext context, String type) {
    List<dynamic> options = [];

    if (vm.dropDownStatus.status == Status.completed) {
      switch (type) {
        case 'Brand':
          options = vm.brandList;
          break;
        case 'Product':
          options = vm.productList;
          break;
        case 'Status':
          options = vm.statusList;
          break;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (c) => DropdownBottomSheet(
        type: type,
        options: options.map((e) {
          return {
            "id": type == 'Brand'
                ? e.brandID
                : type == 'Product'
                ? e.productID
                : e.activityStatusID,
            "name": type == 'Brand'
                ? e.brandName
                : type == 'Product'
                ? e.productName
                : e.activityStatusName,
          };
        }).toList(),
        onSelect: (int id, String name) {
          if (type == 'Brand') {
            vm.setSelectedBrand(
              vm.brandList.firstWhere((e) => e.brandID == id),
            );
          }
          if (type == 'Product') {
            vm.setSelectedProduct(
              vm.productList.firstWhere((e) => e.productID == id),
            );
          }
          if (type == 'Status') {
            vm.setSelectedStatus(
              vm.statusList.firstWhere((e) => e.activityStatusID == id),
            );
          }
          Navigator.pop(c);
        },
      ),
    );
  }

  /// Opens a Material DatePicker and calls [onDateSelected] with dd-MM-yyyy
  Future<void> _pickDate(
    BuildContext context, {
    required DateTime? initialDate,
    required ValueChanged<String> onDateSelected,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: Theme.of(context).primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted =
  '${picked.year}-'
  '${picked.month.toString().padLeft(2, '0')}-'
  '${picked.day.toString().padLeft(2, '0')}';
      // final formatted =
      //     '${picked.day.toString().padLeft(2, '0')}-'
      //     '${picked.month.toString().padLeft(2, '0')}-'
      //     '${picked.year}';
      onDateSelected(formatted);
    }
  }

  /// Parses dd-MM-yyyy → DateTime for the picker's initialDate
  DateTime? _parseDate(String? value) {
    if (value == null || value == 'N/A' || value.isEmpty) return null;
    try {
      final parts = value.split('-');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: vm,
      builder: (context, _) {
        final status = vm.dropDownStatus.status;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: status == Status.loading
              ? const Center(child: CircularProgressIndicator())
              : status == Status.error
              ? Text("Error: ${vm.dropDownStatus.message ?? ''}")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Row 1: Brand + Product ────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: DropdownField(
                            label: 'Brand Type',
                            value:
                                vm.selectedBrand?.brandName ?? 'Select Brand',
                            icon: Icons.branding_watermark,
                            onTap: () => _showDropdown(context, 'Brand'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownField(
                            label: 'Product Type',
                            value:
                                vm.selectedProduct?.productName ??
                                'Select Product',
                            icon: Icons.category,
                            onTap: () => _showDropdown(context, 'Product'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Row 2: Campaign Name (TextField) + Status ─────────
                    Row(
                      children: [
                        Expanded(
                          // ✅ Editable TextField
                          child: _StyledTextField(
                            label: 'Campaign Name',
                            icon: Icons.campaign,
                            initialValue: vm.activityList.isNotEmpty
                                ? vm.activityList.first.campaignName ?? ''
                                : '',
                            onChanged: vm.setCampaignName,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownField(
                            label: 'Status Type',
                            value:
                                vm.selectedStatus?.activityStatusName ??
                                'Select Status',
                            icon: Icons.info_outline,
                            onTap: () => _showDropdown(context, 'Status'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Row 3: ActivityID (read-only) + Document Date (picker) ──
                    Row(
                      children: [
                        Expanded(
                          child: DisplayField(
                            label: 'ActivityID',
                            value: vm.activityList.isNotEmpty
                                ? vm.activityList.first.activityID ?? 'N/A'
                                : 'N/A',
                            icon: Icons.tag,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          // ✅ Tappable date picker
                          child: _DatePickerField(
                            label: 'Document Date',
                            value: vm.documentDate.isNotEmpty
                                ? vm.documentDate
                                : (vm.activityList.isNotEmpty
                                      ? vm.activityList.first.documentDate ??
                                            'Select Date'
                                      : 'Select Date'),
                            icon: Icons.calendar_today,
                            onTap: () => _pickDate(
                              context,
                              initialDate: _parseDate(
                                vm.documentDate.isNotEmpty
                                    ? vm.documentDate
                                    : (vm.activityList.isNotEmpty
                                          ? vm.activityList.first.documentDate
                                          : null),
                              ),
                              onDateSelected: vm.setDocumentDate,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Row 4: Period From + Period To (both pickers) ─────
                    Row(
                      children: [
                        Expanded(
                          // ✅ Tappable date picker
                          child: _DatePickerField(
                            label: 'Period From',
                            value: vm.periodFrom.isNotEmpty
                                ? vm.periodFrom
                                : (vm.activityList.isNotEmpty
                                      ? vm
                                                .activityList
                                                .first
                                                .activityPeriodFrom ??
                                            'Select Date'
                                      : 'Select Date'),
                            icon: Icons.date_range,
                            onTap: () => _pickDate(
                              context,
                              initialDate: _parseDate(
                                vm.periodFrom.isNotEmpty
                                    ? vm.periodFrom
                                    : (vm.activityList.isNotEmpty
                                          ? vm
                                                .activityList
                                                .first
                                                .activityPeriodFrom
                                          : null),
                              ),
                              onDateSelected: vm.setPeriodFrom,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          // ✅ Tappable date picker
                          child: _DatePickerField(
                            label: 'Period To',
                            value: vm.periodTo.isNotEmpty
                                ? vm.periodTo
                                : (vm.activityList.isNotEmpty
                                      ? vm
                                                .activityList
                                                .first
                                                .activityPeriodTo ??
                                            'Select Date'
                                      : 'Select Date'),
                            icon: Icons.date_range,
                            onTap: () => _pickDate(
                              context,
                              initialDate: _parseDate(
                                vm.periodTo.isNotEmpty
                                    ? vm.periodTo
                                    : (vm.activityList.isNotEmpty
                                          ? vm
                                                .activityList
                                                .first
                                                .activityPeriodTo
                                          : null),
                              ),
                              onDateSelected: vm.setPeriodTo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Action Buttons ────────────────────────────────────
                    if (showActions)
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Save',
                              onPressed:
                                  vm.isFormValid &&
                                      vm.updateStatus.status != Status.loading
                                  ? () async {
                                      print(
                                        "Submitting activity-------------${status}",
                                      );
                                      await vm.submitActivity();
                                      if (vm.updateStatus.status ==
                                          Status.completed) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              ' Saved! Activity ID: ${vm.activityList.isNotEmpty ? vm.activityList.first.activityID ?? 'New' : 'Created'}',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        vm.clearFormFields(); // Reset form
                                        if (onSaved != null) onSaved!();
                                      }
                                    }
                                  : null,
                              // child: Text('Save & Start Flow'),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              gradientColors: [
                                Colors.grey.shade300,
                                Colors.grey.shade400,
                              ],
                              onPressed: () {},
                              text: 'Skip',
                              // child: Text('Skip to Details'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StyledTextField
// ─────────────────────────────────────────────────────────────────────────────

class _StyledTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _StyledTextField({
    required this.label,
    required this.icon,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<_StyledTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_StyledTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync when API data arrives after first build
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          onChanged: widget.onChanged,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              size: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DatePickerField
// ─────────────────────────────────────────────────────────────────────────────

class _DatePickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = value == 'Select Date' || value == 'N/A';

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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isPlaceholder ? Theme.of(context).hintColor : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit_calendar_outlined,
                  size: 16,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




// import 'package:activity_tracker/data/remote/response/status.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'shared_widgets.dart';

// class ActivityFormSection extends StatelessWidget {
//   final ActivityDashViewModel vm;

//   const ActivityFormSection({Key? key, required this.vm}) : super(key: key);

//   // ✅ FIX: Removed StatefulWidget + initState entirely.
//   // getActivityDropDownDetails() is now called from EditActivityScreen's
//   // initState via WidgetsBinding.addPostFrameCallback — no duplicate calls.

//   void _showDropdown(BuildContext context, String type) {
//     List<dynamic> options = [];

//     if (vm.dropDownStatus.status == Status.completed) {
//       switch (type) {
//         case 'Brand':
//           options = vm.brandList;
//           break;
//         case 'Product':
//           options = vm.productList;
//           break;
//         case 'Status':
//           options = vm.statusList;
//           break;
//       }
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (c) => DropdownBottomSheet(
//         type: type,
//         options: options.map((e) {
//           return {
//             "id": type == 'Brand'
//                 ? e.brandID
//                 : type == 'Product'
//                 ? e.productID
//                 : e.activityStatusID,
//             "name": type == 'Brand'
//                 ? e.brandName
//                 : type == 'Product'
//                 ? e.productName
//                 : e.activityStatusName,
//           };
//         }).toList(),
//         onSelect: (int id, String name) {
//           if (type == 'Brand') {
//             vm.setSelectedBrand(
//               vm.brandList.firstWhere((e) => e.brandID == id),
//             );
//           }
//           if (type == 'Product') {
//             vm.setSelectedProduct(
//               vm.productList.firstWhere((e) => e.productID == id),
//             );
//           }
//           if (type == 'Status') {
//             vm.setSelectedStatus(
//               vm.statusList.firstWhere((e) => e.activityStatusID == id),
//             );
//           }
//           Navigator.pop(c);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ FIX: AnimatedBuilder listens to vm (ChangeNotifier) directly.
//     // Whenever notifyListeners() fires (loading → completed → error),
//     // only this widget rebuilds — no setState needed.
//     return AnimatedBuilder(
//       animation: vm,
//       builder: (context, _) {
//         final status = vm.dropDownStatus.status;

//         return Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: status == Status.loading
//               ? const Center(child: CircularProgressIndicator())
//               : status == Status.error
//               ? Text("Error: ${vm.dropDownStatus.message ?? ''}")
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DropdownField(
//                             label: 'Brand Type',
//                             value:
//                                 vm.selectedBrand?.brandName ?? 'Select Brand',
//                             icon: Icons.branding_watermark,
//                             onTap: () => _showDropdown(context, 'Brand'),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: DropdownField(
//                             label: 'Product Type',
//                             value: vm.selectedProduct?.productName ??
//                                 'Select Product',
//                             icon: Icons.category,
//                             onTap: () => _showDropdown(context, 'Product'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DisplayField(
//                             label: 'Campaign Name',
//                             value: vm.activityList.isNotEmpty
//                                 ? vm.activityList.first.campaignName ?? 'N/A'
//                                 : 'N/A',
//                             icon: Icons.campaign,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: DropdownField(
//                             label: 'Status Type',
//                             value: vm.selectedStatus?.activityStatusName ??
//                                 'Select Status',
//                             icon: Icons.info_outline,
//                             onTap: () => _showDropdown(context, 'Status'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DisplayField(
//                             label: 'ActivityID',
//                             value: vm.activityList.isNotEmpty
//                                 ? vm.activityList.first.activityID ?? 'N/A'
//                                 : 'N/A',
//                             icon: Icons.tag,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: DisplayField(
//                             label: 'Document Date',
//                             value: vm.activityList.isNotEmpty
//                                 ? vm.activityList.first.documentDate ?? 'N/A'
//                                 : 'N/A',
//                             icon: Icons.calendar_today,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DisplayField(
//                             label: 'Period From',
//                             value: vm.activityList.isNotEmpty
//                                 ? vm.activityList.first.activityPeriodFrom ??
//                                     'N/A'
//                                 : 'N/A',
//                             icon: Icons.date_range,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: DisplayField(
//                             label: 'Period To',
//                             value: vm.activityList.isNotEmpty
//                                 ? vm.activityList.first.activityPeriodTo ?? 'N/A'
//                                 : 'N/A',
//                             icon: Icons.date_range,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // TODO: Submit API
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                             ),
//                             child: const Text('Save & Start Flow'),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () {},
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                             ),
//                             child: const Text('Skip to Details'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//         );
//       },
//     );
//   }
// }