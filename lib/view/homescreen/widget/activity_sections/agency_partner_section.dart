// import 'package:activity_tracker/components/custom_button.dart';
// import 'package:activity_tracker/data/remote/response/status.dart';
// import 'package:activity_tracker/res/app_colors.dart';
// import 'package:activity_tracker/view/homescreen/widget/activity_card.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'shared_widgets.dart';

// class AgencyPartnerSection extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   final VoidCallback? onSaved;

//   const AgencyPartnerSection({Key? key, required this.vm, this.onSaved})
//       : super(key: key);

//   @override
//   State<AgencyPartnerSection> createState() => _AgencyPartnerSectionState();
// }

// class _AgencyPartnerSectionState extends State<AgencyPartnerSection> {
//   // ─── Data ────────────────────────────────────────────────────────────────

//   final List<Map<String, String>> _partners = [
//     {
//       'Agency':      '',
//       'agencyID':    '',
//       'Description': '',
//       'Medium Type': '',
//       'mediumID':    '',
//       'Vehicle':     '',
//       'Spends':      '',
//     },
//   ];

//   Map<String, String> _emptyPartner() => {
//         'Agency':      '',
//         'agencyID':    '',
//         'Description': '',
//         'Medium Type': '',
//         'mediumID':    '',
//         'Vehicle':     '',
//         'Spends':      '',
//       };

//   // ─── Dropdowns ───────────────────────────────────────────────────────────

//   void _showAgencyDropdown(int index) {
//     if (widget.vm.dropDownStatus.status != Status.completed) return;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => DropdownBottomSheet(
//         type: 'Agency',
//         options: widget.vm.agencyList
//             .map((e) => {'id': e.agencyID, 'name': e.agencyName})
//             .toList(),
//         onSelect: (id, name) {
//           setState(() {
//             _partners[index]['Agency']   = name;
//             _partners[index]['agencyID'] = id.toString();
//           });
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }

//   void _showMediumDropdown(int index) {
//     if (widget.vm.dropDownStatus.status != Status.completed) return;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => DropdownBottomSheet(
//         type: 'Medium',
//         options: widget.vm.mediumList
//             .map((e) => {'id': e.mediumID, 'name': e.mediumName})
//             .toList(),
//         onSelect: (id, name) {
//           setState(() {
//             _partners[index]['Medium Type'] = name;
//             _partners[index]['mediumID']    = id.toString();
//           });
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }

//   // ─── Save ────────────────────────────────────────────────────────────────

//   Future<void> _save() async {
//     if (_partners.any((p) => p['Agency']!.isEmpty || p['Medium Type']!.isEmpty)) {
//       _showSnackbar('Please fill Agency and Medium Type for all partners.',
//           isError: true);
//       return;
//     }

//     await widget.vm.submitAgencyPartners(_partners);

//     if (widget.vm.agencyUpdateStatus.status == Status.completed) {
//       _showSnackbar('Agency partners saved successfully!');
//       widget.onSaved?.call();
//     } else {
//       _showSnackbar(
//         widget.vm.agencyUpdateStatus.message ?? 'Error saving data.',
//         isError: true,
//       );
//     }
//   }

//   void _showSnackbar(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError ? AppColors.error1 : AppColors.success,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   // ─── Build ───────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ── Partner cards ──────────────────────────────────────────────
//         ...List.generate(_partners.length, (i) => _PartnerCard(
//               index: i,
//               data: _partners[i],
//               canDelete: _partners.length > 1,
//               onDelete: () => setState(() => _partners.removeAt(i)),
//               onReset: () => setState(() => _partners[i] = _emptyPartner()),
//               onShowAgency: () => _showAgencyDropdown(i),
//               onShowMedium: () => _showMediumDropdown(i),
//               onChanged: (key, val) => setState(() => _partners[i][key] = val),
//             )),

//         const SizedBox(height: 12),

//         // ── Add button ─────────────────────────────────────────────────
//         _AddPartnerButton(
//           onTap: () => setState(() => _partners.add(_emptyPartner())),
//         ),

//         const SizedBox(height: 20),
//         const Divider(color: AppColors.darkBorder1, height: 1),
//         const SizedBox(height: 16),

//         // ── Save button ────────────────────────────────────────────────
//         SectionNavigationButtons(
//           onSave: _save,
//           onSkip: () {
            
//           },
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // _PartnerCard
// // ─────────────────────────────────────────────────────────────────────────────

// class _PartnerCard extends StatelessWidget {
//   final int index;
//   final Map<String, String> data;
//   final bool canDelete;
//   final VoidCallback onDelete;
//   final VoidCallback onReset;
//   final VoidCallback onShowAgency;
//   final VoidCallback onShowMedium;
//   final Function(String key, String val) onChanged;

//   const _PartnerCard({
//     required this.index,
//     required this.data,
//     required this.canDelete,
//     required this.onDelete,
//     required this.onReset,
//     required this.onShowAgency,
//     required this.onShowMedium,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.darkSurface1,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: AppColors.darkBorder1),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Card header ────────────────────────────────────────────
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
//               decoration: const BoxDecoration(
//                 color: AppColors.colorPrimaryGradientBegin,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
//                 border: Border(bottom: BorderSide(color: AppColors.darkBorder1)),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 28,
//                     height: 28,
//                     decoration: BoxDecoration(
//                       color: AppColors.primary1,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Center(
//                       child: Text(
//                         '${index + 1}',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   const Expanded(
//                     child: Text(
//                       'Agency Partner',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary1,
//                       ),
//                     ),
//                   ),
//                   if (!canDelete)
//                     _HeaderAction(
//                       icon: Icons.refresh_rounded,
//                       color: AppColors.lightTextPrimary1,
//                       tooltip: 'Reset',
//                       onTap: onReset,
//                     ),
//                   if (canDelete)
//                     _HeaderAction(
//                       icon: Icons.delete_outline_rounded,
//                       color: AppColors.error1,
//                       tooltip: 'Remove',
//                       onTap: onDelete,
//                     ),
//                 ],
//               ),
//             ),

//             // ── Fields ─────────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   // Agency + Medium dropdowns
//                   _WebFormRow(children: [
//                     DropdownField(
//                       label: 'Agency Partner',
//                       value: data['Agency']!.isNotEmpty
//                           ? data['Agency']!
//                           : 'Select Agency',
//                       icon: Icons.business_outlined,
//                       onTap: onShowAgency,
//                     ),
//                     DropdownField(
//                       label: 'Medium Type',
//                       value: data['Medium Type']!.isNotEmpty
//                           ? data['Medium Type']!
//                           : 'Select Medium Type',
//                       icon: Icons.radio_outlined,
//                       onTap: onShowMedium,
//                     ),
//                   ]),
//                   const SizedBox(height: 12),

//                   // Vehicle + Spends
//                   _WebFormRow(children: [
//                     _PartnerTextField(
//                       label: 'Vehicle',
//                       value: data['Vehicle']!,
//                       hint: 'e.g. Print, Digital...',
//                       icon: Icons.directions_car_outlined,
//                       onChanged: (v) => onChanged('Vehicle', v),
//                     ),
//                     _PartnerTextField(
//                       label: 'Spends (₹)',
//                       value: data['Spends']!,
//                       hint: '0.00',
//                       icon: Icons.currency_rupee_rounded,
//                       keyboardType: TextInputType.number,
//                       onChanged: (v) => onChanged('Spends', v),
//                     ),
//                   ]),
//                   const SizedBox(height: 12),

//                   // Description (full width)
//                   _PartnerTextField(
//                     label: 'Description',
//                     value: data['Description']!,
//                     hint: 'Describe the partner engagement...',
//                     icon: Icons.notes_rounded,
//                     maxLines: 2,
//                     onChanged: (v) => onChanged('Description', v),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // _PartnerTextField
// // ─────────────────────────────────────────────────────────────────────────────

// class _PartnerTextField extends StatefulWidget {
//   final String label;
//   final String value;
//   final String hint;
//   final IconData icon;
//   final int maxLines;
//   final TextInputType keyboardType;
//   final ValueChanged<String> onChanged;

//   const _PartnerTextField({
//     required this.label,
//     required this.value,
//     required this.hint,
//     required this.icon,
//     required this.onChanged,
//     this.maxLines = 1,
//     this.keyboardType = TextInputType.text,
//   });

//   @override
//   State<_PartnerTextField> createState() => _PartnerTextFieldState();
// }

// class _PartnerTextFieldState extends State<_PartnerTextField> {
//   late final TextEditingController _ctrl;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = TextEditingController(text: widget.value);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
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
//             color: AppColors.secondary1,
//             letterSpacing: 0.2,
//           ),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: _ctrl,
//           onChanged: widget.onChanged,
//           maxLines: widget.maxLines,
//           keyboardType: widget.keyboardType,
//           style: const TextStyle(fontSize: 14, color: AppColors.primary1),
//           decoration: InputDecoration(
//             hintText: widget.hint,
//             hintStyle: const TextStyle(fontSize: 13, color: AppColors.lightTextPrimary1),
//             prefixIcon: Icon(widget.icon, size: 16, color: AppColors.primary1),
//             prefixIconConstraints:
//                 const BoxConstraints(minWidth: 40, minHeight: 40),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
//             filled: true,
//             fillColor: AppColors.colorPrimaryGradientBegin,
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
//               borderSide:
//                   const BorderSide(color: AppColors.primary, width: 1.5),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // _AddPartnerButton
// // ─────────────────────────────────────────────────────────────────────────────

// class _AddPartnerButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _AddPartnerButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 13),
//         decoration: BoxDecoration(
//           color: AppColors.lightTextPrimary1,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//               color: AppColors.primary.withOpacity(0.2), width: 1.5),
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add_circle_outline_rounded,
//                 size: 16, color: AppColors.primary),
//             SizedBox(width: 8),
//             Text(
//               'Add Another Agency Partner',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Private helpers
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeaderAction extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String tooltip;
//   final VoidCallback onTap;

//   const _HeaderAction({
//     required this.icon,
//     required this.color,
//     required this.tooltip,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) => IconButton(
//         icon: Icon(icon, size: 18, color: color),
//         tooltip: tooltip,
//         onPressed: onTap,
//         padding: const EdgeInsets.all(6),
//         constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
//       );
// }

// class _WebFormRow extends StatelessWidget {
//   final List<Widget> children;
//   const _WebFormRow({required this.children});

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

import 'package:activity_tracker/components/custom_button.dart';
import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/view/homescreen/widget/activity_sections/shared_widgets.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';

class AgencyPartnerSection extends StatefulWidget {
  final ActivityDashViewModel vm;
  final VoidCallback? onSaved;
  const AgencyPartnerSection({Key? key, required this.vm, this.onSaved})
    : super(key: key);

  @override
  State<AgencyPartnerSection> createState() => _AgencyPartnerSectionState();
}

class _AgencyPartnerSectionState extends State<AgencyPartnerSection> {
  // ================= DROPDOWNS =================

  void _showMediumDropdown(BuildContext context, int index) {
    if (widget.vm.dropDownStatus.status != Status.completed) return;

    showModalBottomSheet(
      context: context,
      builder: (c) => DropdownBottomSheet(
        type: 'Medium',
        options: widget.vm.mediumList.map((e) {
          return {"id": e.mediumID, "name": e.mediumName};
        }).toList(),
        onSelect: (int id, String name) {
          setState(() {
            _agencyPartners[index]['Medium Type'] = name;
            _agencyPartners[index]['mediumID'] = id.toString(); // ✅ FIX
          });
          Navigator.pop(c);
        },
      ),
    );
  }

  void _showAgencyDropdown(BuildContext context, int index) {
    if (widget.vm.dropDownStatus.status != Status.completed) return;

    showModalBottomSheet(
      context: context,
      builder: (c) => DropdownBottomSheet(
        type: 'Agency',
        options: widget.vm.agencyList.map((e) {
          return {"id": e.agencyID, "name": e.agencyName};
        }).toList(),
        onSelect: (int id, String name) {
          setState(() {
            _agencyPartners[index]['Agency'] = name;
            _agencyPartners[index]['agencyID'] = id.toString(); // ✅ FIX
          });
          Navigator.pop(c);
        },
      ),
    );
  }

  // ================= DATA =================

  final List<Map<String, String>> _agencyPartners = [
    {
      'Agency': '',
      'agencyID': '',
      'Description': '',
      'Medium Type': '',
      'mediumID': '',
      'Vehicle': '',
      'Spends': '',
    },
  ];

  void _addAgencyPartner() {
    setState(() {
      _agencyPartners.add({
        'Agency': '',
        'agencyID': '',
        'Description': '',
        'Medium Type': '',
        'mediumID': '',
        'Vehicle': '',
        'Spends': '',
      });
    });
  }

  // ================= FIELD BUILDER =================

  Widget buildField(int index, String key) {
    final value = _agencyPartners[index][key] ?? '';

    if (key == 'Agency') {
      return InkWell(
        onTap: () => _showAgencyDropdown(context, index),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Agency Partner',
            border: OutlineInputBorder(),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : 'Select Agency',
                  style: TextStyle(
                    color: value.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    }

    if (key == 'Medium Type') {
      return InkWell(
        onTap: () => _showMediumDropdown(context, index),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Medium Type',
            border: OutlineInputBorder(),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : 'Select Medium Type',
                  style: TextStyle(
                    color: value.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    }

    return TextFormField(
      initialValue: value,
      onChanged: (val) {
        _agencyPartners[index][key] = val;
      },
      decoration: InputDecoration(labelText: key, border: OutlineInputBorder()),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._agencyPartners.asMap().entries.map((entry) {
          final index = entry.key;

          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // Delete button aligned top-right for each partner
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        // Remove this partner
                        setState(() {
                          if (_agencyPartners.length > 1) {
                            _agencyPartners.removeAt(index);
                          } else {
                            // clear fields if only one left
                            _agencyPartners[0] = {
                              'Agency': '',
                              'agencyID': '',
                              'Description': '',
                              'Medium Type': '',
                              'mediumID': '',
                              'Vehicle': '',
                              'Spends': '',
                            };
                          }
                        });
                      },
                    ),
                  ),
                  buildField(index, 'Agency'),
                  SizedBox(height: 10),
                  buildField(index, 'Description'),
                  SizedBox(height: 10),
                  buildField(index, 'Medium Type'),
                  SizedBox(height: 10),
                  buildField(index, 'Vehicle'),
                  SizedBox(height: 10),
                  buildField(index, 'Spends'),
                ],
              ),
            ),
          );
        }),

        SizedBox(height: 10),

        CustomButton(
          text: 'Add New Agency Partner',
          onPressed: _addAgencyPartner,
        ),

        SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Save',
                onPressed: () async {
                  // Validate before attempting save
                  if (_agencyPartners.any(
                    (e) => e['Agency']!.isEmpty || e['Medium Type']!.isEmpty,
                  )) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all required fields"),
                      ),
                    );
                    return;
                  }

                  await widget.vm.submitAgencyPartners(_agencyPartners);

                  if (widget.vm.agencyUpdateStatus.status == Status.completed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Saved Successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // notify parent to advance
                    if (widget.onSaved != null) widget.onSaved!();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.vm.agencyUpdateStatus.message ??
                              'Error saving data',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
