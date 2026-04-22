import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────
// THEME CONSTANTS
// ─────────────────────────────────────────────
class _AppColors {
  static const bg = Color(0xFFF0F4FF);
  static const surface = Colors.white;
  static const primary = Color(0xFF3B5BDB);
  static const primaryLight = Color(0xFFEEF2FF);

  static const approved = Color(0xFF2F9E44);
  static const approvedBg = Color(0xFFEBFBEE);
  static const pending = Color(0xFFE67700);
  static const pendingBg = Color(0xFFFFF3BF);
  static const rejected = Color(0xFFC92A2A);
  static const rejectedBg = Color(0xFFFFE3E3);
  static const total = Color(0xFF3B5BDB);
  static const totalBg = Color(0xFFEEF2FF);

  static const textPrimary = Color(0xFF1A1D2E);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E9F2);
}

// ─────────────────────────────────────────────
// MAIN WIDGET
// ─────────────────────────────────────────────
class ActivityTrackerDashboard extends StatefulWidget {
  const ActivityTrackerDashboard({super.key});

  @override
  State<ActivityTrackerDashboard> createState() =>
      _ActivityTrackerDashboardState();
}

class _ActivityTrackerDashboardState extends State<ActivityTrackerDashboard>
    with SingleTickerProviderStateMixin {
  String _searchQuery = "";
  String _selectedStatus = "All";
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  final _statusFilters = ["All", "Approved", "Pending", "Rejected"];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    Future.microtask(() {
      context.read<ActivityDashViewModel>().fetchDashboardDetails(
        type: "VIEW",
        activityID: 0,
        userID: context
            .read<ActivityDashViewModel>()
            .dbRepository
            .userData
            ?.userID,
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ─── FILTER LIST ────────────────────────────
  List _filteredList(List raw) {
    return raw.where((e) {
      final matchSearch = (e.brandName ?? "").toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchStatus =
          _selectedStatus == "All" ||
          (e.activityStatusName ?? "").toLowerCase().contains(
            _selectedStatus.toLowerCase(),
          );
      return matchSearch && matchStatus;
    }).toList();
  }

  // ─── BUILD ──────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.bg,
      body: Consumer<ActivityDashViewModel>(
        builder: (context, vm, _) {
          if (vm.dashboardStatus.status == Status.loading) {
            return const _LoadingView();
          }
          if (vm.dashboardStatus.status == Status.error) {
            return _ErrorView(message: vm.dashboardStatus.message);
          }

          // Trigger fade-in once data is ready
          _fadeController.forward();

          final filtered = _filteredList(vm.dashboardList);

          return FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(vm: vm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _KpiRow(vm: vm),
                        const SizedBox(height: 20),
                        _ToolbarRow(
                          searchQuery: _searchQuery,
                          selectedStatus: _selectedStatus,
                          statusFilters: _statusFilters,
                          onSearch: (v) => setState(() => _searchQuery = v),
                          onFilter: (v) => setState(() => _selectedStatus = v),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _DataTable(
                            data: filtered,
                            onEdit: (item) => _onEdit(context, item),
                            onDelete: (item) => _onDelete(context, item, vm),
                            onUpload: (item) => _onUpload(context, item),
                            onDownload: (item) => _onDownload(context, item),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _Footer(total: filtered.length),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── ACTIONS ────────────────────────────────
  void _onEdit(BuildContext ctx, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => _ActionDialog(
        title: "Edit Activity",
        icon: Icons.edit_rounded,
        iconColor: _AppColors.primary,
        content:
            "Edit entry for brand: ${item.brandName ?? 'N/A'}\n\nCampaign: ${item.campaignName ?? 'N/A'}",
        confirmLabel: "Open Editor",
        confirmColor: _AppColors.primary,
        onConfirm: () {
          Navigator.pop(ctx);
          // TODO: Navigate to edit screen
          ScaffoldMessenger.of(ctx).showSnackBar(
            _snack("Opening editor for ${item.brandName}", _AppColors.primary),
          );
        },
      ),
    );
  }

  void _onDelete(BuildContext ctx, dynamic item, ActivityDashViewModel vm) {
    showDialog(
      context: ctx,
      builder: (_) => _ActionDialog(
        title: "Delete Activity",
        icon: Icons.delete_rounded,
        iconColor: _AppColors.rejected,
        content:
            "Are you sure you want to delete the activity for\n\"${item.brandName ?? 'N/A'}\"?\n\nThis action cannot be undone.",
        confirmLabel: "Delete",
        confirmColor: _AppColors.rejected,
        onConfirm: () {
          Navigator.pop(ctx);
          // TODO: Call vm.deleteActivity(item.activityID)
          ScaffoldMessenger.of(ctx).showSnackBar(
            _snack("Deleted: ${item.brandName}", _AppColors.rejected),
          );
        },
      ),
    );
  }

  void _onUpload(BuildContext ctx, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => _ActionDialog(
        title: "Upload Files",
        icon: Icons.upload_rounded,
        iconColor: _AppColors.approved,
        content:
            "Upload files for brand: ${item.brandName ?? 'N/A'}\n\nSupported: PDF, PNG, JPG, XLSX",
        confirmLabel: "Choose Files",
        confirmColor: _AppColors.approved,
        onConfirm: () {
          Navigator.pop(ctx);
          // TODO: Open file picker
          ScaffoldMessenger.of(ctx).showSnackBar(
            _snack(
              "File picker opened for ${item.brandName}",
              _AppColors.approved,
            ),
          );
        },
      ),
    );
  }

  void _onDownload(BuildContext ctx, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => _ActionDialog(
        title: "Download Files",
        icon: Icons.download_rounded,
        iconColor: _AppColors.pending,
        content: "Download all files for brand: ${item.brandName ?? 'N/A'}",
        confirmLabel: "Download",
        confirmColor: _AppColors.pending,
        onConfirm: () {
          Navigator.pop(ctx);
          // TODO: Trigger download
          ScaffoldMessenger.of(ctx).showSnackBar(
            _snack(
              "Downloading files for ${item.brandName}",
              _AppColors.pending,
            ),
          );
        },
      ),
    );
  }

  SnackBar _snack(String msg, Color color) => SnackBar(
    content: Text(msg, style: const TextStyle(color: Colors.white)),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
  );
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  final ActivityDashViewModel vm;
  const _Header({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: _AppColors.surface,
        border: Border(bottom: BorderSide(color: _AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: _AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Activity Dashboard",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                "${vm.dashboardList.length} total records",
                style: const TextStyle(
                  fontSize: 12,
                  color: _AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          _PillButton(
            icon: Icons.refresh_rounded,
            label: "Refresh",
            onTap: () {
              context.read<ActivityDashViewModel>().fetchDashboardDetails(
                type: "VIEW",
                activityID: 0,
                userID: vm.dbRepository.userData?.userID,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _AppColors.primary, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: _AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// KPI ROW
// ─────────────────────────────────────────────
class _KpiRow extends StatelessWidget {
  final ActivityDashViewModel vm;
  const _KpiRow({required this.vm});

  int _count(String keyword) => vm.dashboardList
      .where(
        (e) => (e.activityStatusName ?? "").toLowerCase().contains(keyword),
      )
      .length;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiData(
        "Total",
        vm.dashboardList.length,
        Icons.layers_rounded,
        _AppColors.total,
        _AppColors.totalBg,
      ),
      _KpiData(
        "Approved",
        _count("approved"),
        Icons.check_circle_rounded,
        _AppColors.approved,
        _AppColors.approvedBg,
      ),
      _KpiData(
        "Pending",
        _count("pending"),
        Icons.access_time_rounded,
        _AppColors.pending,
        _AppColors.pendingBg,
      ),
      _KpiData(
        "Rejected",
        _count("rejected"),
        Icons.cancel_rounded,
        _AppColors.rejected,
        _AppColors.rejectedBg,
      ),
    ];

    return Row(
      children: cards
          .asMap()
          .entries
          .map(
            (e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: e.key == 0 ? 0 : 10),
                child: _KpiCard(data: e.value),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _KpiData {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color bg;
  const _KpiData(this.label, this.value, this.icon, this.color, this.bg);
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${data.value}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: data.color,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: data.color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOOLBAR (Search + Filter)
// ─────────────────────────────────────────────
class _ToolbarRow extends StatelessWidget {
  final String searchQuery;
  final String selectedStatus;
  final List<String> statusFilters;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilter;

  const _ToolbarRow({
    required this.searchQuery,
    required this.selectedStatus,
    required this.statusFilters,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: _AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _AppColors.border),
            ),
            child: TextField(
              style: const TextStyle(
                fontSize: 14,
                color: _AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: "Search by brand...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: _AppColors.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: _AppColors.textSecondary,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: onSearch,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Filter dropdown
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _AppColors.textSecondary,
                size: 18,
              ),
              style: const TextStyle(
                fontSize: 13,
                color: _AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              items: statusFilters
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => onFilter(v!),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DATA TABLE
// ─────────────────────────────────────────────
class _DataTable extends StatelessWidget {
  final List data;
  final Function(dynamic) onEdit;
  final Function(dynamic) onDelete;
  final Function(dynamic) onUpload;
  final Function(dynamic) onDownload;

  const _DataTable({
    required this.data,
    required this.onEdit,
    required this.onDelete,
    required this.onUpload,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _EmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 20,
              horizontalMargin: 16,
              headingRowHeight: 44,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 60,
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFFF8FAFF),
              ),
              dividerThickness: 1,
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: _AppColors.border,
                  width: 0.8,
                ),
              ),
              columns: [
                _col("Brand"),
                _col("Product"),
                _col("Campaign"),
                _col("Status"),
                _col("Date"),
                _col("Actions", center: true),
              ],
              rows: data.asMap().entries.map<DataRow>((entry) {
                final item = entry.value;
                final isEven = entry.key % 2 == 0;

                return DataRow(
                  color: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return _AppColors.primaryLight;
                    }
                    return isEven ? Colors.white : const Color(0xFFFAFBFF);
                  }),
                  cells: [
                    DataCell(_brandCell(item.brandName)),
                    DataCell(_textCell(item.productName)),
                    DataCell(_textCell(item.campaignName)),
                    DataCell(_StatusBadge(status: item.activityStatusName)),
                    DataCell(_dateCell(item.createdDate)),
                    DataCell(
                      _ActionsCell(
                        onEdit: () => onEdit(item),
                        onDelete: () => onDelete(item),
                        onUpload: () => onUpload(item),
                        onDownload: () => onDownload(item),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _col(String label, {bool center = false}) => DataColumn(
    label: Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: _AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _brandCell(String? name) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            (name ?? "?").isNotEmpty ? name![0].toUpperCase() : "?",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: _AppColors.primary,
              fontSize: 13,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        name ?? "-",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: _AppColors.textPrimary,
        ),
      ),
    ],
  );

  Widget _textCell(String? text) => Text(
    text ?? "-",
    style: const TextStyle(fontSize: 13, color: _AppColors.textPrimary),
    overflow: TextOverflow.ellipsis,
  );

  Widget _dateCell(String? date) => Row(
    children: [
      const Icon(
        Icons.calendar_today_rounded,
        size: 13,
        color: _AppColors.textSecondary,
      ),
      const SizedBox(width: 5),
      Text(
        date ?? "-",
        style: const TextStyle(fontSize: 12, color: _AppColors.textSecondary),
      ),
    ],
  );
}

// ─────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String? status;
  const _StatusBadge({this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    IconData icon;

    final lower = (status ?? "").toLowerCase();
    if (lower.contains("approved")) {
      color = _AppColors.approved;
      bg = _AppColors.approvedBg;
      icon = Icons.check_circle_rounded;
    } else if (lower.contains("pending")) {
      color = _AppColors.pending;
      bg = _AppColors.pendingBg;
      icon = Icons.access_time_rounded;
    } else if (lower.contains("rejected")) {
      color = _AppColors.rejected;
      bg = _AppColors.rejectedBg;
      icon = Icons.cancel_rounded;
    } else {
      color = _AppColors.textSecondary;
      bg = _AppColors.border;
      icon = Icons.help_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            status ?? "-",
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACTIONS CELL
// ─────────────────────────────────────────────
class _ActionsCell extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onUpload;
  final VoidCallback onDownload;

  const _ActionsCell({
    required this.onEdit,
    required this.onDelete,
    required this.onUpload,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionBtn(
          icon: Icons.edit_rounded,
          color: _AppColors.primary,
          tooltip: "Edit",
          onTap: onEdit,
        ),
        _ActionBtn(
          icon: Icons.upload_rounded,
          color: _AppColors.approved,
          tooltip: "Upload",
          onTap: onUpload,
        ),
        _ActionBtn(
          icon: Icons.download_rounded,
          color: _AppColors.pending,
          tooltip: "Download",
          onTap: onDownload,
        ),
        _ActionBtn(
          icon: Icons.delete_rounded,
          color: _AppColors.rejected,
          tooltip: "Delete",
          onTap: onDelete,
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────
class _Footer extends StatelessWidget {
  final int total;
  const _Footer({required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            "Showing $total record${total == 1 ? '' : 's'}",
            style: const TextStyle(
              fontSize: 12,
              color: _AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 36,
              color: _AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No records found",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Try adjusting your search or filter",
            style: TextStyle(fontSize: 13, color: _AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOADING VIEW
// ─────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: _AppColors.primary,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          const Text(
            "Loading activities...",
            style: TextStyle(color: _AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ERROR VIEW
// ─────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String? message;
  const _ErrorView({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _AppColors.rejectedBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 32,
              color: _AppColors.rejected,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message ?? "Please try again",
            style: const TextStyle(
              fontSize: 13,
              color: _AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ActivityDashViewModel>().fetchDashboardDetails(
                type: "VIEW",
                activityID: 0,
                userID: context
                    .read<ActivityDashViewModel>()
                    .dbRepository
                    .userData
                    ?.userID,
              );
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACTION DIALOG
// ─────────────────────────────────────────────
class _ActionDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String content;
  final String confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const _ActionDialog({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.content,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + Title
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _AppColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  color: _AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _AppColors.textSecondary,
                      side: BorderSide(color: _AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      confirmLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
