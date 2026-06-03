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

  void _showMultiSelectDropdown(BuildContext fieldCtx, String type) {
    List<dynamic> options = [];
    List<int> selectedIds = [];

    if (vm.dropDownStatus.status == Status.completed) {
      switch (type) {
        case 'Vendor':
          options = vm.agencyList;
          selectedIds = vm.selectedAgencies
              .map((e) => e.agencyID ?? 0)
              .toList();
          break;
        case 'Medium':
          options = vm.mediumList;
          selectedIds = vm.selectedMediums.map((e) => e.mediumID ?? 0).toList();
          break;
      }
    }

    final RenderBox renderBox = fieldCtx.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final overlay = Overlay.of(fieldCtx).context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (c) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => overlayEntry?.remove(),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: size.width,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(fieldCtx).cardColor,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(fieldCtx).dividerColor.withOpacity(0.1),
                  ),
                ),
                child: MultiSelectDropdownPopup(
                  options: options.map((e) {
                    return {
                      "id": type == 'Vendor' ? e.agencyID : e.mediumID,
                      "name": type == 'Vendor' ? e.agencyName : e.mediumName,
                    };
                  }).toList(),
                  selectedIds: selectedIds,
                  onClose: () => overlayEntry?.remove(),
                  onSelect: (List<int> ids, List<String> names) {
                    if (type == 'Vendor') {
                      final selected = vm.agencyList
                          .where((e) => ids.contains(e.agencyID))
                          .toList();
                      vm.setSelectedAgencies(selected);
                    } else if (type == 'Medium') {
                      final selected = vm.mediumList
                          .where((e) => ids.contains(e.mediumID))
                          .toList();
                      vm.setSelectedMediums(selected);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(fieldCtx).insert(overlayEntry!);
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: vm,
      builder: (context, _) {
        final status = vm.dropDownStatus.status;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    // ── Row 1: Brand + Sub Brand + Campaign Name + Vendor ──
                    ResponsiveRow(
                      children: [
                        Expanded(
                          child: _DropdownSelectField<dynamic>(
                            label: 'Brand Name',
                            icon: Icons.branding_watermark,
                            value: vm.selectedBrand,
                            hintText: 'Select Brand',
                            items: vm.brandList,
                            getItemId: (b) => b.brandID as int?,
                            getItemLabel: (b) => b.brandName as String? ?? '',
                            onChanged: (val) {
                              if (val != null) vm.setSelectedBrand(val);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DropdownSelectField<dynamic>(
                            label: 'Sub Brand Name',
                            icon: Icons.category,
                            value: null, // Placeholder for future Sub Brand API
                            hintText: 'Select Sub Brand',
                            items: [],
                            getItemId: (p) => null,
                            getItemLabel: (p) => '',
                            onChanged: (val) {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StyledTextField(
                            label: 'Campaign Name',
                            icon: Icons.campaign,
                            initialValue: vm.activityList.isNotEmpty
                                ? vm.activityList.first.campaignName ?? ''
                                : '',
                            onChanged: vm.setCampaignName,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Activity ID",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 34,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  vm.activityList.isNotEmpty
                                      ? vm.activityList.first.activityID ??
                                            'N/A'
                                      : 'N/A',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Row 2: Medium + Vehicle + Activity Status + Activity ID ──
                    ResponsiveRow(
                      children: [
                        Expanded(
                          child: MultiSelectDropdownField(
                            label: 'Medium',
                            hint: 'Select Mediums',
                            selectedNames: vm.selectedMediums
                                .map((e) => e.mediumName ?? '')
                                .toList(),
                            onTap: (fieldCtx) =>
                                _showMultiSelectDropdown(fieldCtx, 'Medium'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StyledTextField(
                            label: 'Vehicle',
                            icon: Icons.directions_car,
                            initialValue: vm.vehicle,
                            onChanged: vm.setVehicle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DropdownSelectField<dynamic>(
                            label: 'Activity Status',
                            icon: Icons.info_outline,
                            value: vm.selectedStatus,
                            hintText: 'Select Status',
                            items: vm.statusList,
                            getItemId: (s) => s.activityStatusID as int?,
                            getItemLabel: (s) =>
                                s.activityStatusName as String? ?? '',
                            onChanged: (val) {
                              if (val != null) vm.setSelectedStatus(val);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MultiSelectDropdownField(
                            label: 'Vendor Name',
                            hint: 'Select Vendors',
                            selectedNames: vm.selectedAgencies
                                .map((e) => e.agencyName ?? '')
                                .toList(),
                            onTap: (fieldCtx) =>
                                _showMultiSelectDropdown(fieldCtx, 'Vendor'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Row 3: Document Date + Date From + Date To + Save Button ──
                    ResponsiveRow(
                      children: [
                        Expanded(
                          child: _DatePickerField(
                            label: 'Document Date',
                            value: vm.documentDate.isNotEmpty
                                ? vm.documentDate
                                : _formatDate(DateTime.now()),
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DatePickerField(
                            label: 'Date From',
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DatePickerField(
                            label: 'Date To',
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
                        const SizedBox(width: 10),
                        if (showActions) ...[
                          Expanded(
                            child: SizedBox(
                              height: 34,
                              child: CustomButton(
                                text: 'Save',
                                onPressed:
                                    vm.isFormValid &&
                                        vm.updateStatus.status != Status.loading
                                    ? () async {
                                        await vm.submitActivity();
                                        if (vm.updateStatus.status ==
                                            Status.completed) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Saved! Activity ID: ${vm.activityList.isNotEmpty ? vm.activityList.first.activityID ?? 'New' : 'Created'}',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          vm.clearFormFields();
                                          if (onSaved != null) onSaved!();
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ] else ...[
                          const Expanded(child: SizedBox()),
                        ],
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
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 34,
          child: TextFormField(
            controller: _controller,
            onChanged: widget.onChanged,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Icon(
                widget.icon,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
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
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 11,
                      color: isPlaceholder
                          ? Theme.of(context).hintColor
                          : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit_calendar_outlined,
                  size: 14,
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

// ─────────────────────────────────────────────────────────────────────────────
// _DropdownSelectField
// Generic dropdown select that accepts a list of objects and selectors
// ─────────────────────────────────────────────────────────────────────────────

class _DropdownSelectField<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<T> items;
  final String hintText;
  final int? Function(T) getItemId;
  final String Function(T) getItemLabel;
  final ValueChanged<T?> onChanged;

  const _DropdownSelectField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.hintText,
    required this.getItemId,
    required this.getItemLabel,
    required this.onChanged,
  });

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
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          child: DropdownButtonFormField<T>(
            value: items.contains(value) ? value : null,
            isExpanded: true,
            menuMaxHeight: 300,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            hint: Text(
              hintText,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).hintColor,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Theme.of(context).hintColor,
            ),
            items: items.map((e) {
              return DropdownMenuItem<T>(
                value: e,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        getItemLabel(e),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}


// import 'package:activity_tracker/components/components.dart';
// import 'package:activity_tracker/data/remote/response/status.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'shared_widgets.dart';

// class ActivityFormSection extends StatelessWidget {
//   final ActivityDashViewModel vm;
//   final bool showActions;
//   final VoidCallback? onSaved;

//   const ActivityFormSection({
//     Key? key,
//     required this.vm,
//     this.showActions = true,
//     this.onSaved,
//   }) : super(key: key);

//   // ─── Dropdown sheet ──────────────────────────────────────────────────────

//   void _showDropdown(BuildContext context, String type) {
//     List<dynamic> options = [];

//     if (vm.dropDownStatus.status == Status.completed) {
//       switch (type) {
//         case 'Brand':   options = vm.brandList;   break;
//         case 'Product': options = vm.productList;  break;
//         case 'Status':  options = vm.statusList;   break;
//       }
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => DropdownBottomSheet(
//         type: type,
//         options: options.map((e) {
//           return {
//             'id': type == 'Brand'
//                 ? e.brandID
//                 : type == 'Product'
//                     ? e.productID
//                     : e.activityStatusID,
//             'name': type == 'Brand'
//                 ? e.brandName
//                 : type == 'Product'
//                     ? e.productName
//                     : e.activityStatusName,
//           };
//         }).toList(),
//         onSelect: (int id, String name) {
//           if (type == 'Brand') {
//             vm.setSelectedBrand(vm.brandList.firstWhere((e) => e.brandID == id));
//           } else if (type == 'Product') {
//             vm.setSelectedProduct(vm.productList.firstWhere((e) => e.productID == id));
//           } else {
//             vm.setSelectedStatus(vm.statusList.firstWhere((e) => e.activityStatusID == id));
//           }
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }

//   // ─── Date picker ─────────────────────────────────────────────────────────

//   Future<void> _pickDate(
//     BuildContext context, {
//     required DateTime? initialDate,
//     required ValueChanged<String> onDateSelected,
//   }) async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate ?? now,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: Theme.of(ctx).colorScheme.copyWith(
//                 primary: AppColors.primary1,
//               ),
//         ),
//         child: child!,
//       ),
//     );

//     if (picked != null) {
//       final formatted =
//           '${picked.year}-'
//           '${picked.month.toString().padLeft(2, '0')}-'
//           '${picked.day.toString().padLeft(2, '0')}';
//       onDateSelected(formatted);
//     }
//   }

//   DateTime? _parseDate(String? value) {
//     if (value == null || value == 'N/A' || value.isEmpty) return null;
//     try {
//       final parts = value.split('-');
//       if (parts.length != 3) return null;
//       return DateTime(
//         int.parse(parts[0]),
//         int.parse(parts[1]),
//         int.parse(parts[2]),
//       );
//     } catch (_) {
//       return null;
//     }
//   }

//   // ─── Build ───────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: vm,
//       builder: (context, _) {
//         final status = vm.dropDownStatus.status;

//         if (status == Status.loading) {
//           return const _LoadingState();
//         }
//         if (status == Status.error) {
//           return _ErrorState(message: vm.dropDownStatus.message ?? 'Unknown error');
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Section label ──────────────────────────────────────────
//             const _SectionSubtitle('Basic Information'),
//             const SizedBox(height: 12),

//             // ── Row 1: Brand + Product ─────────────────────────────────
//             _WebRow(
//               children: [
//                 DropdownField(
//                   label: 'Brand Type',
//                   value: vm.selectedBrand?.brandName ?? 'Select Brand',
//                   icon: Icons.branding_watermark_outlined,
//                   onTap: () => _showDropdown(context, 'Brand'),
//                 ),
//                 DropdownField(
//                   label: 'Product Type',
//                   value: vm.selectedProduct?.productName ?? 'Select Product',
//                   icon: Icons.category_outlined,
//                   onTap: () => _showDropdown(context, 'Product'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),

//             // ── Row 2: Campaign Name + Status ──────────────────────────
//             _WebRow(
//               children: [
//                 _StyledTextField(
//                   label: 'Campaign Name',
//                   icon: Icons.campaign_outlined,
//                   initialValue: vm.activityList.isNotEmpty
//                       ? vm.activityList.first.campaignName ?? ''
//                       : '',
//                   onChanged: vm.setCampaignName,
//                 ),
//                 DropdownField(
//                   label: 'Status Type',
//                   value: vm.selectedStatus?.activityStatusName ?? 'Select Status',
//                   icon: Icons.info_outline_rounded,
//                   onTap: () => _showDropdown(context, 'Status'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             const _SectionSubtitle('Dates'),
//             const SizedBox(height: 12),

//             // ── Row 3: ActivityID + Document Date ──────────────────────
//             _WebRow(
//               children: [
//                 DisplayField(
//                   label: 'Activity ID',
//                   value: vm.activityList.isNotEmpty
//                       ? vm.activityList.first.activityID ?? 'N/A'
//                       : 'N/A',
//                   icon: Icons.tag_rounded,
//                 ),
//                 _DatePickerField(
//                   label: 'Document Date',
//                   value: vm.documentDate.isNotEmpty
//                       ? vm.documentDate
//                       : (vm.activityList.isNotEmpty
//                           ? vm.activityList.first.documentDate ?? 'Select Date'
//                           : 'Select Date'),
//                   icon: Icons.calendar_today_outlined,
//                   onTap: () => _pickDate(
//                     context,
//                     initialDate: _parseDate(
//                       vm.documentDate.isNotEmpty
//                           ? vm.documentDate
//                           : vm.activityList.isNotEmpty
//                               ? vm.activityList.first.documentDate
//                               : null,
//                     ),
//                     onDateSelected: vm.setDocumentDate,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),

//             // ── Row 4: Period From + Period To ─────────────────────────
//             _WebRow(
//               children: [
//                 _DatePickerField(
//                   label: 'Period From',
//                   value: vm.periodFrom.isNotEmpty
//                       ? vm.periodFrom
//                       : (vm.activityList.isNotEmpty
//                           ? vm.activityList.first.activityPeriodFrom ?? 'Select Date'
//                           : 'Select Date'),
//                   icon: Icons.date_range_outlined,
//                   onTap: () => _pickDate(
//                     context,
//                     initialDate: _parseDate(
//                       vm.periodFrom.isNotEmpty
//                           ? vm.periodFrom
//                           : vm.activityList.isNotEmpty
//                               ? vm.activityList.first.activityPeriodFrom
//                               : null,
//                     ),
//                     onDateSelected: vm.setPeriodFrom,
//                   ),
//                 ),
//                 _DatePickerField(
//                   label: 'Period To',
//                   value: vm.periodTo.isNotEmpty
//                       ? vm.periodTo
//                       : (vm.activityList.isNotEmpty
//                           ? vm.activityList.first.activityPeriodTo ?? 'Select Date'
//                           : 'Select Date'),
//                   icon: Icons.date_range_outlined,
//                   onTap: () => _pickDate(
//                     context,
//                     initialDate: _parseDate(
//                       vm.periodTo.isNotEmpty
//                           ? vm.periodTo
//                           : vm.activityList.isNotEmpty
//                               ? vm.activityList.first.activityPeriodTo
//                               : null,
//                     ),
//                     onDateSelected: vm.setPeriodTo,
//                   ),
//                 ),
//               ],
//             ),

//             // ── Action Buttons ─────────────────────────────────────────
//             if (showActions) ...[
//               const SizedBox(height: 20),
//               const Divider(color: AppColors.darkBorder1, height: 1),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _PrimaryActionButton(
//                       label: 'Save Section',
//                       icon: Icons.check_rounded,
//                       enabled: vm.isFormValid &&
//                           vm.updateStatus.status != Status.loading,
//                       isLoading: vm.updateStatus.status == Status.loading,
//                       onTap: () async {
//                         await vm.submitActivity();
//                         if (vm.updateStatus.status == Status.completed) {
//                           _showSnackbar(
//                             context,
//                             '✓ Saved! Activity ID: ${vm.activityList.isNotEmpty ? vm.activityList.first.activityID ?? 'New' : 'Created'}',
//                             isSuccess: true,
//                           );
//                           vm.clearFormFields();
//                           onSaved?.call();
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   _SkipButton(onTap: onSaved),
//                 ],
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }

//   void _showSnackbar(BuildContext context, String msg, {bool isSuccess = true}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isSuccess ? AppColors.success : AppColors.error1,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // _StyledTextField
// // ─────────────────────────────────────────────────────────────────────────────

// class _StyledTextField extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final String initialValue;
//   final ValueChanged<String> onChanged;

//   const _StyledTextField({
//     required this.label,
//     required this.icon,
//     required this.initialValue,
//     required this.onChanged,
//   });

//   @override
//   State<_StyledTextField> createState() => _StyledTextFieldState();
// }

// class _StyledTextFieldState extends State<_StyledTextField> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.initialValue);
//   }

//   @override
//   void didUpdateWidget(_StyledTextField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.initialValue != widget.initialValue &&
//         _controller.text != widget.initialValue) {
//       _controller.text = widget.initialValue;
//       _controller.selection =
//           TextSelection.collapsed(offset: _controller.text.length);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: AppColors.darkTextSecondary1,
//             letterSpacing: 0.2,
//           ),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: _controller,
//           onChanged: widget.onChanged,
//           style: const TextStyle(fontSize: 14, color: AppColors.lightTextPrimary1),
//           decoration: InputDecoration(
//             prefixIcon: Icon(widget.icon, size: 16, color: AppColors.primary),
//             prefixIconConstraints:
//                 const BoxConstraints(minWidth: 40, minHeight: 40),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
//             filled: true,
//             fillColor: AppColors.colorGrey,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: AppColors.darkBorder1),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: AppColors.darkBorder1),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
//             ),
//             hintStyle: const TextStyle(color: AppColors.lightTextSecondary1, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // _DatePickerField
// // ─────────────────────────────────────────────────────────────────────────────

// class _DatePickerField extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final VoidCallback onTap;

//   const _DatePickerField({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isPlaceholder = value == 'Select Date' || value == 'N/A';

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: AppColors.secondary1,
//             letterSpacing: 0.2,
//           ),
//         ),
//         const SizedBox(height: 6),
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
//             decoration: BoxDecoration(
//               color: AppColors.info1,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: AppColors.darkBorder1),
//             ),
//             child: Row(
//               children: [
//                 Icon(icon, size: 16, color: AppColors.primary),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: isPlaceholder
//                           ? AppColors.lightTextPrimary1
//                           : AppColors.primary1,
//                     ),
//                   ),
//                 ),
//                 const Icon(Icons.edit_calendar_outlined,
//                     size: 14, color: AppColors.lightTextPrimary1),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Private helpers
// // ─────────────────────────────────────────────────────────────────────────────

// class _WebRow extends StatelessWidget {
//   final List<Widget> children;
//   const _WebRow({required this.children});

//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width >= 600;

//     if (isWide) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: children
//             .map((c) => Expanded(child: c))
//             .toList()
//             .expand((e) => [e, const SizedBox(width: 14)])
//             .toList()
//           ..removeLast(),
//       );
//     }

//     return Column(
//       children: children
//           .expand((c) => [c, const SizedBox(height: 12)])
//           .toList()
//         ..removeLast(),
//     );
//   }
// }

// class _SectionSubtitle extends StatelessWidget {
//   final String text;
//   const _SectionSubtitle(this.text);

//   @override
//   Widget build(BuildContext context) => Text(
//         text,
//         style: const TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//           color: AppColors.lightTextSecondary1,
//           letterSpacing: 1.0,
//         ),
//       );
// }

// class _PrimaryActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool enabled;
//   final bool isLoading;
//   final VoidCallback? onTap;

//   const _PrimaryActionButton({
//     required this.label,
//     required this.icon,
//     this.enabled = true,
//     this.isLoading = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: ElevatedButton.icon(
//         onPressed: enabled ? onTap : null,
//         icon: isLoading
//             ? const SizedBox(
//                 width: 14,
//                 height: 14,
//                 child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white),
//               )
//             : Icon(icon, size: 16),
//         label: Text(
//           label,
//           style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           disabledBackgroundColor: AppColors.darkBorder1,
//           elevation: 0,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
// }

// class _SkipButton extends StatelessWidget {
//   final VoidCallback? onTap;
//   const _SkipButton({this.onTap});

//   @override
//   Widget build(BuildContext context) => SizedBox(
//         height: 44,
//         child: OutlinedButton(
//           onPressed: onTap,
//           style: OutlinedButton.styleFrom(
//             foregroundColor: AppColors.secondary1,
//             side: const BorderSide(color: AppColors.darkBorder1),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           child: const Text(
//             'Skip',
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//           ),
//         ),
//       );
// }

// class _LoadingState extends StatelessWidget {
//   const _LoadingState();

//   @override
//   Widget build(BuildContext context) => const Padding(
//         padding: EdgeInsets.symmetric(vertical: 32),
//         child: Center(
//           child: CircularProgressIndicator(color: AppColors.primary),
//         ),
//       );
// }

// class _ErrorState extends StatelessWidget {
//   final String message;
//   const _ErrorState({required this.message});

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.warning1,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: AppColors.error1.withOpacity(0.3)),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.error_outline_rounded,
//                 color: AppColors.error1, size: 18),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                     fontSize: 13, color: AppColors.error1),
//               ),
//             ),
//           ],
//         ),
//       );
// }