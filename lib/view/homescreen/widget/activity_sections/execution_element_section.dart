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