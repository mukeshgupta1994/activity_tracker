import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class ExecutionElementSection extends StatefulWidget {
  final ActivityDashViewModel vm;
  final VoidCallback? onSaved;

  const ExecutionElementSection({Key? key, required this.vm, this.onSaved})
    : super(key: key);

  @override
  State<ExecutionElementSection> createState() =>
      _ExecutionElementSectionState();
}

class _ExecutionElementSectionState extends State<ExecutionElementSection> {
  final List<ExecutionElementData> _executionElements = [
    ExecutionElementData(
      title: 'Retailer connect',
      details: {'Description': 'Exo Sampling'},
    ),
    ExecutionElementData(
      title: 'School Activity',
      details: {'Description': 'Student Engagement'},
    ),
  ];

  void _addExecutionElement() {
    setState(() {
      _executionElements.add(
        ExecutionElementData(
          title: 'New Execution Element',
          details: {'Description': ''},
        ),
      );
    });
  }

  void _removeExecutionElement(int index) {
    setState(() {
      if (_executionElements.length > 1) {
        _executionElements.removeAt(index);
      }
    });
  }

  // ✅ UI → API DATA CONVERT
  List<Map<String, String>> _prepareApiData() {
    return _executionElements.map((e) {
      return {'title': e.title, 'Description': e.details['Description'] ?? ''};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._executionElements.asMap().entries.map((entry) {
          final index = entry.key;
          final element = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EditableDetailCard(
              title: element.title,
              details: element.details,
              onDelete: _executionElements.length > 1
                  ? () => _removeExecutionElement(index)
                  : null,
            ),
          );
        }).toList(),

        TextButton.icon(
          onPressed: _addExecutionElement,
          icon: Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          label: const Text(
            'Add New Execution Element',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        SizedBox(height: 20),
        // ✅ SAVE BUTTON WITH API
        if (widget.onSaved != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final data = _prepareApiData();

                      // ✅ validation
                      if (data.any((e) => e['title']!.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all required fields"),
                          ),
                        );
                        return;
                      }

                      await widget.vm.submitExecutionElements(data);

                      if (widget.vm.executionUpdateStatus.status ==
                          Status.completed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saved Successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // 👉 collapse + next expand
                        widget.onSaved?.call();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.vm.executionUpdateStatus.message ??
                                  "Error saving data",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    //  widget.onSaved,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D3A8C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  //  ElevatedButton(
                  //   onPressed: () async {

                  //    //IMPORTANT: Activity save hona chahiye pehle
                  //     // if (widget.vm.activityList.isEmpty) {
                  //     //   ScaffoldMessenger.of(context).showSnackBar(
                  //     //     const SnackBar(
                  //     //       content: Text("Please save Activity first"),
                  //     //     ),
                  //     //   );
                  //     //   return;
                  //     // }

                  //     final data = _prepareApiData();

                  //     // ✅ validation
                  //     if (data.any((e) => e['title']!.isEmpty)) {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           content:
                  //               Text("Please fill all required fields"),
                  //         ),
                  //       );
                  //       return;
                  //     }

                  //     await widget.vm
                  //         .submitExecutionElements(data);

                  //     if (widget.vm.executionUpdateStatus.status ==
                  //         Status.completed) {

                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           content: Text('Saved Successfully'),
                  //           backgroundColor: Colors.green,
                  //         ),
                  //       );

                  //       // 👉 collapse + next expand
                  //       widget.onSaved?.call();

                  //     } else {

                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(
                  //           content: Text(
                  //             widget.vm.executionUpdateStatus.message ??
                  //                 "Error saving data",
                  //           ),
                  //           backgroundColor: Colors.red,
                  //         ),
                  //       );
                  //     }
                  //   },
                  //   child: const Text('Save'),
                  // ),
                ),
              ],
            ),
          ),

        // ✅ SAME ADD BUTTON
        TextButton.icon(
          onPressed: _addExecutionElement,
          icon: Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          label: const Text(
            'Add New Execution Element',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

// class ExecutionElementSection extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   final VoidCallback? onSaved;

//   const ExecutionElementSection({
//     Key? key,
//     required this.vm,
//     this.onSaved,
//   }) : super(key: key);

//   @override
//   State<ExecutionElementSection> createState() =>
//       _ExecutionElementSectionState();
// }

// class _ExecutionElementSectionState extends State<ExecutionElementSection> {

//   final List<ExecutionElementData> _executionElements = [
//     ExecutionElementData(
//       title: 'Retailer connect',
//       details: {'Description': 'Exo Sampling'},
//     ),
//   ];

//   void _addExecutionElement() {
//     setState(() {
//       _executionElements.add(
//         ExecutionElementData(
//           title: 'New Execution Element',
//           details: {'Description': ''},
//         ),
//       );
//     });
//   }

//   void _removeExecutionElement(int index) {
//     setState(() {
//       if (_executionElements.length > 1) {
//         _executionElements.removeAt(index);
//       }
//     });
//   }

//   // 🔥 CONVERT UI DATA → API FORMAT
//   List<Map<String, String>> _prepareApiData() {
//     return _executionElements.map((e) {
//       return {
//         'title': e.title,
//         'Description': e.details['Description'] ?? '',
//       };
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [

//         ..._executionElements.asMap().entries.map((entry) {
//           final index = entry.key;
//           final element = entry.value;

//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: EditableDetailCard(
//               title: element.title,
//               details: element.details,
//               onDelete: _executionElements.length > 1
//                   ? () => _removeExecutionElement(index)
//                   : null,
//             ),
//           );
//         }).toList(),

//         // ✅ SAVE BUTTON WITH API
//         if (widget.onSaved != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {

//                       final data = _prepareApiData();

//                       // ✅ validation
//                       if (data.any((e) => e['title']!.isEmpty)) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content:
//                                 Text("Please fill all required fields"),
//                           ),
//                         );
//                         return;
//                       }

//                       await widget.vm.submitExecutionElements(data);

//                       if (widget.vm.executionUpdateStatus.status ==
//                           Status.completed) {

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Saved Successfully'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );

//                         // 👉 collapse + next expand
//                         widget.onSaved?.call();

//                       } else {

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               widget.vm.executionUpdateStatus.message ??
//                                   "Error saving data",
//                             ),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                     child: const Text('Save'),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         // ✅ ADD BUTTON SAME AS BEFORE
//         TextButton.icon(
//           onPressed: _addExecutionElement,
//           icon: Icon(
//             Icons.add_circle_outline,
//             color: Theme.of(context).colorScheme.primary,
//             size: 20,
//           ),
//           label: const Text(
//             'Add New Execution Element',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//           ),
//           style: TextButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//             backgroundColor:
//                 Theme.of(context).colorScheme.primary.withOpacity(0.05),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ExecutionElementSection extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   final VoidCallback? onSaved;

//   const ExecutionElementSection({
//     Key? key,
//     required this.vm,
//     this.onSaved,
//   }) : super(key: key);

//   @override
//   State<ExecutionElementSection> createState() =>
//       _ExecutionElementSectionState();
// }

// class _ExecutionElementSectionState
//     extends State<ExecutionElementSection> {
//   final List<Map<String, String>> _executionElements = [
//     {
//       'title': '',
//       'Description': '',
//     }
//   ];

//   void _addExecutionElement() {
//     setState(() {
//       _executionElements.add({
//         'title': '',
//         'Description': '',
//       });
//     });
//   }

//   void _removeExecutionElement(int index) {
//     setState(() {
//       if (_executionElements.length > 1) {
//         _executionElements.removeAt(index);
//       }
//     });
//   }

//   Widget buildField(int index, String key) {
//     return TextFormField(
//       initialValue: _executionElements[index][key],
//       onChanged: (val) {
//         _executionElements[index][key] = val;
//       },
//       decoration: InputDecoration(
//         labelText: key,
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ..._executionElements.asMap().entries.map((entry) {
//           final index = entry.key;

//           return Card(
//             margin: EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: IconButton(
//                       icon: Icon(Icons.delete_outline, color: Colors.red),
//                       onPressed: () => _removeExecutionElement(index),
//                     ),
//                   ),
//                   buildField(index, 'title'),
//                   SizedBox(height: 10),
//                   buildField(index, 'Description'),
//                 ],
//               ),
//             ),
//           );
//         }),

//         SizedBox(height: 10),

//         ElevatedButton(
//           onPressed: _addExecutionElement,
//           child: Text("Add Execution Element"),
//         ),

//         SizedBox(height: 20),

//         Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 child: Text("Save"),
//                 onPressed: () async {
//                   // ✅ validation
//                   if (_executionElements.any(
//                       (e) => e['title']!.isEmpty)) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                             "Please fill all required fields"),
//                       ),
//                     );
//                     return;
//                   }

//                   await widget.vm
//                       .submitExecutionElements(_executionElements);

//                   if (widget.vm.executionUpdateStatus.status ==
//                       Status.completed) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Saved Successfully'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );

//                     // 👉 collapse + next expand trigger
//                     widget.onSaved?.call();
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(widget
//                                 .vm.executionUpdateStatus.message ??
//                             "Error"),
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

// import 'package:flutter/material.dart';
// import 'shared_widgets.dart';

// class ExecutionElementSection extends StatefulWidget {
//   final VoidCallback? onSaved;
//   const ExecutionElementSection({Key? key, this.onSaved}) : super(key: key);

//   @override
//   State<ExecutionElementSection> createState() =>
//       _ExecutionElementSectionState();
// }

// class _ExecutionElementSectionState extends State<ExecutionElementSection> {
//   final List<ExecutionElementData> _executionElements = [
//     ExecutionElementData(
//       title: 'Retailer connect',
//       details: {'Description': 'Exo Sampling'},
//     ),
//     ExecutionElementData(
//       title: 'School Activity',
//       details: {'Description': 'Student Engagement'},
//     ),
//   ];

//   void _addExecutionElement() {
//     setState(() {
//       _executionElements.add(
//         ExecutionElementData(
//           title: 'New Execution Element',
//           details: {'Description': ''},
//         ),
//       );
//     });
//   }

//   void _removeExecutionElement(int index) {
//     setState(() {
//       if (_executionElements.length > 1) _executionElements.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ..._executionElements.asMap().entries.map((entry) {
//           final index = entry.key;
//           final element = entry.value;
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: EditableDetailCard(
//               title: element.title,
//               details: element.details,
//               onDelete: _executionElements.length > 1
//                   ? () => _removeExecutionElement(index)
//                   : null,
//             ),
//           );
//         }).toList(),
//         // Show a Save button if parent provides onSaved so section can trigger advancement
//         if (widget.onSaved != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // In a real implementation we'd persist the execution elements.
//                       widget.onSaved?.call();
//                     },
//                     child: const Text('Save'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         TextButton.icon(
//           onPressed: _addExecutionElement,
//           icon: Icon(
//             Icons.add_circle_outline,
//             color: Theme.of(context).colorScheme.primary,
//             size: 20,
//           ),
//           label: const Text(
//             'Add New Execution Element',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//           ),
//           style: TextButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//             backgroundColor: Theme.of(
//               context,
//             ).colorScheme.primary.withOpacity(0.05),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
