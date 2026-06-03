import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:activity_tracker/components/components.dart';
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

        const SizedBox(height: 4),

        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addExecutionElement,
            icon: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
            label: Text(
              'Add New Execution Element',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),

        const SizedBox(height: 20),

        if (widget.onSaved != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ResponsiveRow(
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
                        final data = _prepareApiData();

                        if (data.any((e) => e['title']!.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please fill all required fields")),
                          );
                          return;
                        }

                        await widget.vm.submitExecutionElements(data);

                        if (widget.vm.executionUpdateStatus.status == Status.completed) {
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
                              content: Text(widget.vm.executionUpdateStatus.message ?? "Error saving data"),
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
          ),

        // ✅ SAME ADD BUTTON
        // TextButton.icon(
        //   onPressed: _addExecutionElement,
        //   icon: Icon(
        //     Icons.add_circle_outline,
        //     color: Theme.of(context).colorScheme.primary,
        //     size: 20,
        //   ),
        //   label: const Text(
        //     'Add New Execution Element',
        //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        //   ),
        //   style: TextButton.styleFrom(
        //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        //     backgroundColor: Theme.of(
        //       context,
        //     ).colorScheme.primary.withOpacity(0.05),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}