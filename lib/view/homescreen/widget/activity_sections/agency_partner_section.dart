// import 'package:activity_tracker/components/custom_button.dart';
// import 'package:activity_tracker/data/remote/response/status.dart';
// import 'package:activity_tracker/view/homescreen/widget/activity_sections/shared_widgets.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';

// class AgencyPartnerSection extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   const AgencyPartnerSection({Key? key, required this.vm}) : super(key: key);

//   @override
//   State<AgencyPartnerSection> createState() => _AgencyPartnerSectionState();
// }

// class _AgencyPartnerSectionState extends State<AgencyPartnerSection> {
//   void _showMediumDropdown(BuildContext context, int index) {
//     if (widget.vm.dropDownStatus.status != Status.completed) return;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (c) => DropdownBottomSheet(
//         type: 'Medium',
//         options: widget.vm.mediumList.map((e) {
//           return {"id": e.mediumID, "name": e.mediumName};
//         }).toList(),
//         onSelect: (int id, String name) {
//           final selected = widget.vm.mediumList.firstWhere(
//             (e) => e.mediumID == id,
//           );

//           widget.vm.setSelectedMedium(selected);

//           setState(() {
//             _agencyPartners[index]['Medium Type'] = name;
//           });

//           Navigator.pop(c);
//         },
//       ),
//     );
//   }

//   void _showAgencyDropdown(BuildContext context, int index) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (c) => DropdownBottomSheet(
//         type: 'Agency',
//         options: agencyOptions.asMap().entries.map((entry) {
//           return {"id": entry.key, "name": entry.value};
//         }).toList(),
//         onSelect: (int id, String name) {
//           setState(() {
//             _agencyPartners[index]['Agency'] = name;
//           });

//           Navigator.pop(c);
//         },
//       ),
//     );
//   }

//   final List<String> agencyOptions = [
//     'Madison Communications Pvt Ltd',
//     'GroupM',
//     'Dentsu',
//   ];

//   final List<String> mediumOptions = ['ACTIVATION', 'DIGITAL', 'PRINT', 'TV'];

//   final List<Map<String, String>> _agencyPartners = [
//     {
//       'Agency': 'Madison Communications Pvt Ltd',
//       'Description': 'Media',
//       'Medium Type': 'ACTIVATION',
//       'Vehicle': 'ABP',
//       'Spends': '₹21,42,499',
//     },
//   ];

//   void _addAgencyPartner() {
//     setState(() {
//       _agencyPartners.add({
//         'Agency': '',
//         'Description': '',
//         'Medium Type': '',
//         'Vehicle': '',
//         'Spends': '',
//       });
//     });
//   }

//   void _removeAgencyPartner(int index) {
//     setState(() {
//       if (_agencyPartners.length > 1) {
//         _agencyPartners.removeAt(index);
//       }
//     });
//   }

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
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Icon(Icons.arrow_drop_down, color: Colors.grey),
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
//                   _agencyPartners[index]['Medium Type']?.isNotEmpty == true
//                       ? _agencyPartners[index]['Medium Type']!
//                       : 'Select Medium Type',
//                   style: TextStyle(
//                     color:
//                         _agencyPartners[index]['Medium Type']?.isNotEmpty ==
//                             true
//                         ? Colors.black
//                         : Colors.grey,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_drop_down,
//                 color: Colors.grey,
//               ),
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
//       decoration: InputDecoration(labelText: key, border: OutlineInputBorder()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         ..._agencyPartners.asMap().entries.map((entry) {
//           final index = entry.key;

//           return Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   buildField(index, 'Agency'),
//                   SizedBox(height: 10),
//                   buildField(index, 'Description'),
//                   SizedBox(height: 10),
//                   buildField(index, 'Medium Type'),
//                   SizedBox(height: 10),
//                   buildField(index, 'Vehicle'),
//                   SizedBox(height: 10),
//                   buildField(index, 'Spends'),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),

//         SizedBox(height: 10),
//         Align(
//           alignment: Alignment.center,
//           child: SizedBox(
//             width: 270,
//             child: CustomButton(
//               text: 'Add New Agency Partner',
//               onPressed: _addAgencyPartner,
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//         Row(
//           children: [
//            Expanded(
//   child: CustomButton(
//     text: 'Save',
//     onPressed: () async {
//       await widget.vm.submitAgencyPartners(_agencyPartners);

//       if (widget.vm.agencyUpdateStatus.status == Status.completed) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Agency Partners Saved Successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else if (widget.vm.agencyUpdateStatus.status == Status.error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(widget.vm.agencyUpdateStatus.message ?? 'Error'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     },
//   ),
// ),
//             SizedBox(width: 12),
//             Expanded(
//               child: CustomButton(
//                 gradientColors: [Colors.grey.shade300, Colors.grey.shade400],
//                 onPressed: () {},
//                 text: 'Skip ',
//                 // child: Text('Skip to Details'),
//               ),
//             ),
//           ],
//         ),
//       ],
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
