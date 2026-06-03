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
  State<AgencyPartnerSection> createState() =>
      _AgencyPartnerSectionState();
}

class _AgencyPartnerSectionState extends State<AgencyPartnerSection> {

  // ================= COMMON DECORATION =================

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
           labelStyle: TextStyle(
      fontSize: 12,
      color: Colors.grey.shade600,
    ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    );
  }

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
            _agencyPartners[index]['mediumID'] = id.toString();
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
            _agencyPartners[index]['agencyID'] = id.toString();
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
          decoration: _inputDecoration('Agency Partner'),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : 'Select Agency',
                  style: TextStyle(
                    fontSize: 12,
                    color: value.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: Colors.grey),
            ],
          ),
        ),
      );
    }

    if (key == 'Medium Type') {
      return InkWell(
        onTap: () => _showMediumDropdown(context, index),
        child: InputDecorator(
          decoration: _inputDecoration('Medium Type'),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : 'Select Medium',
                  style: TextStyle(
                    fontSize: 12,
                    color: value.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: Colors.grey),
            ],
          ),
        ),
      );
    }

    return TextFormField(
      initialValue: value,
      onChanged: (val) => _agencyPartners[index][key] = val,
      style: const TextStyle(fontSize: 12),
      decoration: _inputDecoration(key),
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
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          size: 18, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          if (_agencyPartners.length > 1) {
                            _agencyPartners.removeAt(index);
                          } else {
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

                  ResponsiveRow(
                    children: [
                      Expanded(child: buildField(index, 'Agency')),
                      const SizedBox(width: 8),
                      Expanded(child: buildField(index, 'Medium Type')),
                    ],
                  ),

                  const SizedBox(height: 8),

                  ResponsiveRow(
                    children: [
                      Expanded(child: buildField(index, 'Description')),
                      const SizedBox(width: 8),
                      Expanded(child: buildField(index, 'Vehicle')),
                      const SizedBox(width: 8),
                      Expanded(child: buildField(index, 'Spends')),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

       

      

        const SizedBox(height: 4),

        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addAgencyPartner,
            icon: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
            label: Text(
              'Add New Agency Partner',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),

        const SizedBox(height: 20),

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
                  text: 'Save',
                  onPressed: () async {
                    if (_agencyPartners.any((e) => e['Agency']!.isEmpty || e['Medium Type']!.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all required fields")),
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
                      widget.onSaved?.call();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.vm.agencyUpdateStatus.message ?? 'Error saving data'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// import 'package:activity_tracker/components/custom_button.dart';
// import 'package:activity_tracker/data/remote/response/status.dart';
// import 'package:activity_tracker/view/homescreen/widget/activity_sections/shared_widgets.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';

// class AgencyPartnerSection extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   final VoidCallback? onSaved;
//   const AgencyPartnerSection({Key? key, required this.vm, this.onSaved})
//     : super(key: key);

//   @override
//   State<AgencyPartnerSection> createState() => _AgencyPartnerSectionState();
// }

// class _AgencyPartnerSectionState extends State<AgencyPartnerSection> {
//   // ================= DROPDOWNS =================

//   void _showMediumDropdown(BuildContext context, int index) {
//     if (widget.vm.dropDownStatus.status != Status.completed) return;

//     showModalBottomSheet(
//       context: context,
//       builder: (c) => DropdownBottomSheet(
//         type: 'Medium',
//         options: widget.vm.mediumList.map((e) {
//           return {"id": e.mediumID, "name": e.mediumName};
//         }).toList(),
//         onSelect: (int id, String name) {
//           setState(() {
//             _agencyPartners[index]['Medium Type'] = name;
//             _agencyPartners[index]['mediumID'] = id.toString(); // ✅ FIX
//           });
//           Navigator.pop(c);
//         },
//       ),
//     );
//   }

//   void _showAgencyDropdown(BuildContext context, int index) {
//     if (widget.vm.dropDownStatus.status != Status.completed) return;

//     showModalBottomSheet(
//       context: context,
//       builder: (c) => DropdownBottomSheet(
//         type: 'Agency',
//         options: widget.vm.agencyList.map((e) {
//           return {"id": e.agencyID, "name": e.agencyName};
//         }).toList(),
//         onSelect: (int id, String name) {
//           setState(() {
//             _agencyPartners[index]['Agency'] = name;
//             _agencyPartners[index]['agencyID'] = id.toString(); // ✅ FIX
//           });
//           Navigator.pop(c);
//         },
//       ),
//     );
//   }

//   // ================= DATA =================

//   final List<Map<String, String>> _agencyPartners = [
//     {
//       'Agency': '',
//       'agencyID': '',
//       'Description': '',
//       'Medium Type': '',
//       'mediumID': '',
//       'Vehicle': '',
//       'Spends': '',
//     },
//   ];

//   void _addAgencyPartner() {
//     setState(() {
//       _agencyPartners.add({
//         'Agency': '',
//         'agencyID': '',
//         'Description': '',
//         'Medium Type': '',
//         'mediumID': '',
//         'Vehicle': '',
//         'Spends': '',
//       });
//     });
//   }

//   // ================= FIELD BUILDER =================

//   Widget buildField(int index, String key) {
//     final value = _agencyPartners[index][key] ?? '';

//     if (key == 'Agency') {
//       return InkWell(
//         onTap: () => _showAgencyDropdown(context, index),
//         child: InputDecorator(
//           decoration: InputDecoration(
//             labelText: 'Agency Partner',
//             border: OutlineInputBorder(),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   value.isNotEmpty ? value : 'Select Agency',
//                   style: TextStyle(
//                     color: value.isNotEmpty ? Colors.black : Colors.grey,
//                   ),
//                 ),
//               ),
//               Icon(Icons.arrow_drop_down),
//             ],
//           ),
//         ),
//       );
//     }

//     if (key == 'Medium Type') {
//       return InkWell(
//         onTap: () => _showMediumDropdown(context, index),
//         child: InputDecorator(
//           decoration: InputDecoration(
//             labelText: 'Medium Type',
//             border: OutlineInputBorder(),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   value.isNotEmpty ? value : 'Select Medium Type',
//                   style: TextStyle(
//                     color: value.isNotEmpty ? Colors.black : Colors.grey,
//                   ),
//                 ),
//               ),
//               Icon(Icons.arrow_drop_down),
//             ],
//           ),
//         ),
//       );
//     }

//     return TextFormField(
//       initialValue: value,
//       onChanged: (val) {
//         _agencyPartners[index][key] = val;
//       },
//       decoration: InputDecoration(
//   labelText: key,
//   border: OutlineInputBorder(),
//   isDense: true, // 👈 compact height
//   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// ),
//     );
//   }

//   // ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ..._agencyPartners.asMap().entries.map((entry) {
//           final index = entry.key;

//           return Card(
//             margin: EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   // 🔹 Row 1 → Agency + Medium
//                   Row(
//                     children: [
//                       Expanded(child: buildField(index, 'Agency')),
//                       const SizedBox(width: 10),
//                       Expanded(child: buildField(index, 'Medium Type')),
//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   Row(
//                     children: [
//                       Expanded(child: buildField(index, 'Description')),
//                       const SizedBox(width: 10),
//                       Expanded(child: buildField(index, 'Vehicle')),
//                       const SizedBox(width: 10),
//                       Expanded(child: buildField(index, 'Spends')),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),

//         SizedBox(height: 10),

//         CustomButton(
//           text: 'Add New Agency Partner',
//           onPressed: _addAgencyPartner,
//         ),

//         SizedBox(height: 20),

//         Row(
//           children: [
//             Expanded(
//               child: CustomButton(
//                 text: 'Save',
//                 onPressed: () async {
//                   // Validate before attempting save
//                   if (_agencyPartners.any(
//                     (e) => e['Agency']!.isEmpty || e['Medium Type']!.isEmpty,
//                   )) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Please fill all required fields"),
//                       ),
//                     );
//                     return;
//                   }

//                   await widget.vm.submitAgencyPartners(_agencyPartners);

//                   if (widget.vm.agencyUpdateStatus.status == Status.completed) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Saved Successfully'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                     // notify parent to advance
//                     if (widget.onSaved != null) widget.onSaved!();
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           widget.vm.agencyUpdateStatus.message ??
//                               'Error saving data',
//                         ),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
