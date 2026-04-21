import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class DownloadReportsSection extends StatelessWidget {
  final VoidCallback? onSaved;
  const DownloadReportsSection({Key? key, this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ActionCard(
          label: 'State Wise Report',
          icon: Icons.map_outlined,
          iconColor: Colors.orange,
        ),
        const SizedBox(height: 16),
        const ActionCard(
          label: 'Month Wise Report',
          icon: Icons.calendar_month_outlined,
          iconColor: Colors.pinkAccent,
        ),
        if (onSaved != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSaved,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
