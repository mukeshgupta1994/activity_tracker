import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/utils/routes/app_routes.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';

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
// WHICH SCREEN IS ACTIVE IN CONTENT AREA
// ─────────────────────────────────────────────
enum _ActiveScreen { dashboard, editActivity }

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

  // ✅ Track which screen is showing in the content area
  _ActiveScreen _activeScreen = _ActiveScreen.dashboard;

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

  void _goToEditActivity() {
    setState(() => _activeScreen = _ActiveScreen.editActivity);
  }

  void _goToDashboard() {
    setState(() => _activeScreen = _ActiveScreen.dashboard);
    // Re-fetch when coming back
    context.read<ActivityDashViewModel>().fetchDashboardDetails(
      type: "VIEW",
      activityID: 0,
      userID: context
          .read<ActivityDashViewModel>()
          .dbRepository
          .userData
          ?.userID,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.bg,
      body: Row(
        children: [
          // ── SIDENAV — hamesha visible ──────────────────────────────────
          _SideNav(
            activeScreen: _activeScreen,
            onDashboardTap: _goToDashboard,
            onEditActivityTap: _goToEditActivity,
            onLogoutTap: () => _confirmLogout(context),
          ),

          // ── CONTENT AREA — dashboard ya edit activity ──────────────────
          Expanded(
            child: _activeScreen == _ActiveScreen.editActivity
                ? EditActivityScreen(
                    vm: context.read<ActivityDashViewModel>(),
                    onBack: _goToDashboard,
                  )
                : _buildDashboardContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Consumer<ActivityDashViewModel>(
      builder: (context, vm, _) {
        if (vm.dashboardStatus.status == Status.loading) {
          return const _LoadingView();
        }
        if (vm.dashboardStatus.status == Status.error) {
          return _ErrorView(message: vm.dashboardStatus.message);
        }

        _fadeController.forward();
        final filtered = _filteredList(vm.dashboardList);

        return FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                vm: vm,
                onNewActivity: _goToEditActivity,
                onRefresh: () {
                  context.read<ActivityDashViewModel>().fetchDashboardDetails(
                    type: "VIEW",
                    activityID: 0,
                    userID: vm.dbRepository.userData?.userID,
                  );
                },
              ),
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
    );
  }

  // ─── ACTIONS ──────────────────────────────────────────────────────────
  // void _onEdit(BuildContext ctx, dynamic item) {
  //   showDialog(
  //     context: ctx,
  //     builder: (_) => _ActionDialog(
  //       title: "Edit Activity",
  //       icon: Icons.edit_rounded,
  //       iconColor: _AppColors.primary,
  //       content:
  //           "Edit entry for brand: ${item.brandName ?? 'N/A'}\n\nCampaign: ${item.campaignName ?? 'N/A'}",
  //       confirmLabel: "Open Editor",
  //       confirmColor: _AppColors.primary,
  //       onConfirm: () {
  //         Navigator.pop(ctx);
  //         _goToEditActivity(); // ✅ sidenav ke saath khulega
  //       },
  //     ),
  //   );
  // }
  void _onEdit(BuildContext ctx, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: _ActionDialog(
            title: "Edit Activity",
            icon: Icons.edit_rounded,
            iconColor: _AppColors.primary,
            content:
                "Edit entry for brand: ${item.brandName ?? 'N/A'}\n\nCampaign: ${item.campaignName ?? 'N/A'}",
            confirmLabel: "Open Editor",
            confirmColor: _AppColors.primary,
            onConfirm: () {
              Navigator.pop(ctx);
              _goToEditActivity();
            },
          ),
        ),
      ),
    );
  }

  void _onDelete(BuildContext ctx, dynamic item, ActivityDashViewModel vm) {
    showDialog(
      context: ctx,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: _ActionDialog(
            title: "Delete Activity",
            icon: Icons.delete_rounded,
            iconColor: _AppColors.rejected,
            content:
                "Are you sure you want to delete the activity for\n\"${item.brandName ?? 'N/A'}\"?\n\nThis action cannot be undone.",
            confirmLabel: "Delete",
            confirmColor: _AppColors.rejected,
            onConfirm: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                _snack("Deleted: ${item.brandName}", _AppColors.rejected),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onUpload(BuildContext ctx, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: _ActionDialog(
            title: "Upload Files",
            icon: Icons.upload_rounded,
            iconColor: _AppColors.approved,
            content:
                "Upload files for brand: ${item.brandName ?? 'N/A'}\n\nSupported: PDF, PNG, JPG, XLSX",
            confirmLabel: "Choose Files",
            confirmColor: _AppColors.approved,
            onConfirm: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                _snack(
                  "File picker opened for ${item.brandName}",
                  _AppColors.approved,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onDownload(BuildContext ctx, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: _ActionDialog(
            title: "Download Files",
            icon: Icons.download_rounded,
            iconColor: _AppColors.pending,
            content: "Download all files for brand: ${item.brandName ?? 'N/A'}",
            confirmLabel: "Download",
            confirmColor: _AppColors.pending,
            onConfirm: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                _snack(
                  "Downloading files for ${item.brandName}",
                  _AppColors.pending,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: _ActionDialog(
            title: "Logout",
            icon: Icons.logout_rounded,
            iconColor: _AppColors.rejected,
            content: "Are you sure you want to logout?",
            confirmLabel: "Logout",
            confirmColor: _AppColors.rejected,
            onConfirm: () {
              Navigator.pop(context);
              context.go(AppRoutes.loginScreenRoute);
            },
          ),
        ),
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
// SIDE NAV — callbacks se navigate karta hai, GoRouter nahi
// ─────────────────────────────────────────────
class _SideNav extends StatelessWidget {
  final _ActiveScreen activeScreen;
  final VoidCallback onDashboardTap;
  final VoidCallback onEditActivityTap;
  final VoidCallback onLogoutTap;

  const _SideNav({
    required this.activeScreen,
    required this.onDashboardTap,
    required this.onEditActivityTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: double.infinity,
      decoration: const BoxDecoration(
        // gradient: LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00B894)]),
        color: _AppColors.surface,
        border: Border(right: BorderSide(color: _AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 12,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── LOGO ──
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.18,
            //155,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4F46E5), // indigo
                  Color(0xFF06B6D4),
                ],
              ),
              border: Border(bottom: BorderSide(color: _AppColors.border)),
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/log_icon.png",
                  width: 65,
                  height: 65,
                ),

                const SizedBox(width: 10),
                const Text(
                  "Activity\nTracker",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _AppColors.approvedBg,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const SizedBox(height: 4),

          _NavItem(
            icon: Icons.dashboard_rounded,
            label: "Dashboard",
            isActive: activeScreen == _ActiveScreen.dashboard,
            onTap: onDashboardTap,
          ),

          _NavItem(
            icon: Icons.edit_note_rounded,
            label: "Add Activity",
            isActive: activeScreen == _ActiveScreen.editActivity,
            onTap: onEditActivityTap,
          ),

          const Spacer(),

          const Divider(height: 1, color: _AppColors.border),
          const SizedBox(height: 8),

          _NavItem(
            icon: Icons.logout_rounded,
            label: "Logout",
            isDanger: true,
            onTap: onLogoutTap,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NAV ITEM
// ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDanger;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isDanger
        ? _AppColors.rejected
        : isActive
        ? _AppColors.primary
        : _AppColors.textSecondary;

    final Color textColor = isDanger
        ? _AppColors.rejected
        : isActive
        ? _AppColors.primary
        : _AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? _AppColors.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isActive
                  ? Border.all(color: _AppColors.primary.withOpacity(0.15))
                  : null,
            ),
            child: Row(
              children: [
                Icon(icon, size: 19, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: _AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  final ActivityDashViewModel vm;
  final VoidCallback onNewActivity;
  final VoidCallback onRefresh;

  const _Header({
    required this.vm,
    required this.onNewActivity,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 155,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 16,
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
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35),

              const Text(
                "Activity Dashboard",
                style: TextStyle(
                  fontSize: 25,
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
          // _PillButton(
          //   icon: Icons.add_rounded,
          //   label: "New Activity",
          //   onTap: onNewActivity, // ✅ callback — GoRouter nahi
          // ),
          const SizedBox(width: 10),
          _PillButton(
            icon: Icons.refresh_rounded,
            label: "Refresh",
            onTap: onRefresh,
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
            Icon(icon, color: _AppColors.primary, size: 15),
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
// TOOLBAR
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
    if (data.isEmpty) return _EmptyState();

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
                _col("Actions"),
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

  DataColumn _col(String label) => DataColumn(
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
    final lower = (status ?? "").toLowerCase();
    Color color;
    Color bg;
    IconData icon;

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
      child: Text(
        "Showing $total record${total == 1 ? '' : 's'}",
        style: const TextStyle(fontSize: 12, color: _AppColors.textSecondary),
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: _AppColors.primary,
            strokeWidth: 2.5,
          ),
          SizedBox(height: 16),
          Text(
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
                      side: const BorderSide(color: _AppColors.border),
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



// import 'package:activity_tracker/data/remote/response/status.dart';
// import 'package:activity_tracker/utils/routes/app_routes.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// // ─────────────────────────────────────────────
// // THEME CONSTANTS
// // ─────────────────────────────────────────────
// class _AppColors {
//   static const bg = Color(0xFFF0F4FF);
//   static const surface = Colors.white;
//   static const primary = Color(0xFF3B5BDB);
//   static const primaryLight = Color(0xFFEEF2FF);

//   static const approved = Color(0xFF2F9E44);
//   static const approvedBg = Color(0xFFEBFBEE);
//   static const pending = Color(0xFFE67700);
//   static const pendingBg = Color(0xFFFFF3BF);
//   static const rejected = Color(0xFFC92A2A);
//   static const rejectedBg = Color(0xFFFFE3E3);
//   static const total = Color(0xFF3B5BDB);
//   static const totalBg = Color(0xFFEEF2FF);

//   static const textPrimary = Color(0xFF1A1D2E);
//   static const textSecondary = Color(0xFF6B7280);
//   static const border = Color(0xFFE5E9F2);
// }

// // ─────────────────────────────────────────────
// // MAIN WIDGET
// // ─────────────────────────────────────────────
// class ActivityTrackerDashboard extends StatefulWidget {
//   const ActivityTrackerDashboard({super.key});

//   @override
//   State<ActivityTrackerDashboard> createState() =>
//       _ActivityTrackerDashboardState();
// }

// class _ActivityTrackerDashboardState extends State<ActivityTrackerDashboard>
//     with SingleTickerProviderStateMixin {
//   String _searchQuery = "";
//   String _selectedStatus = "All";
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnim;

//   final _statusFilters = ["All", "Approved", "Pending", "Rejected"];

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _fadeAnim =
//         CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

//     Future.microtask(() {
//       context.read<ActivityDashViewModel>().fetchDashboardDetails(
//             type: "VIEW",
//             activityID: 0,
//             userID: context
//                 .read<ActivityDashViewModel>()
//                 .dbRepository
//                 .userData
//                 ?.userID,
//           );
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   List _filteredList(List raw) {
//     return raw.where((e) {
//       final matchSearch = (e.brandName ?? "")
//           .toLowerCase()
//           .contains(_searchQuery.toLowerCase());
//       final matchStatus = _selectedStatus == "All" ||
//           (e.activityStatusName ?? "")
//               .toLowerCase()
//               .contains(_selectedStatus.toLowerCase());
//       return matchSearch && matchStatus;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _AppColors.bg,
//       body: Row(
//         children: [
//           // ── PERMANENT SIDE NAV ──
//           _SideNav(activeRoute: AppRoutes.activitytrackerdashboard),

//           // ── MAIN CONTENT ──
//           Expanded(
//             child: Consumer<ActivityDashViewModel>(
//               builder: (context, vm, _) {
//                 if (vm.dashboardStatus.status == Status.loading) {
//                   return const _LoadingView();
//                 }
//                 if (vm.dashboardStatus.status == Status.error) {
//                   return _ErrorView(message: vm.dashboardStatus.message);
//                 }

//                 _fadeController.forward();
//                 final filtered = _filteredList(vm.dashboardList);

//                 return FadeTransition(
//                   opacity: _fadeAnim,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _Header(vm: vm),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 20),
//                               _KpiRow(vm: vm),
//                               const SizedBox(height: 20),
//                               _ToolbarRow(
//                                 searchQuery: _searchQuery,
//                                 selectedStatus: _selectedStatus,
//                                 statusFilters: _statusFilters,
//                                 onSearch: (v) =>
//                                     setState(() => _searchQuery = v),
//                                 onFilter: (v) =>
//                                     setState(() => _selectedStatus = v),
//                               ),
//                               const SizedBox(height: 16),
//                               Expanded(
//                                 child: _DataTable(
//                                   data: filtered,
//                                   onEdit: (item) => _onEdit(context, item),
//                                   onDelete: (item) =>
//                                       _onDelete(context, item, vm),
//                                   onUpload: (item) => _onUpload(context, item),
//                                   onDownload: (item) =>
//                                       _onDownload(context, item),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               _Footer(total: filtered.length),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── ACTIONS ────────────────────────────────
//   void _onEdit(BuildContext ctx, dynamic item) {
//     showDialog(
//       context: ctx,
//       builder: (_) => _ActionDialog(
//         title: "Edit Activity",
//         icon: Icons.edit_rounded,
//         iconColor: _AppColors.primary,
//         content:
//             "Edit entry for brand: ${item.brandName ?? 'N/A'}\n\nCampaign: ${item.campaignName ?? 'N/A'}",
//         confirmLabel: "Open Editor",
//         confirmColor: _AppColors.primary,
//         onConfirm: () {
//           Navigator.pop(ctx);
//           // ✅ GoRouter push — edit screen opens on top, back button returns to dashboard
//           ctx.push(AppRoutes.editActivityScreen);
//         },
//       ),
//     );
//   }

//   void _onDelete(BuildContext ctx, dynamic item, ActivityDashViewModel vm) {
//     showDialog(
//       context: ctx,
//       builder: (_) => _ActionDialog(
//         title: "Delete Activity",
//         icon: Icons.delete_rounded,
//         iconColor: _AppColors.rejected,
//         content:
//             "Are you sure you want to delete the activity for\n\"${item.brandName ?? 'N/A'}\"?\n\nThis action cannot be undone.",
//         confirmLabel: "Delete",
//         confirmColor: _AppColors.rejected,
//         onConfirm: () {
//           Navigator.pop(ctx);
//           // TODO: vm.deleteActivity(item.activityID)
//           ScaffoldMessenger.of(ctx).showSnackBar(
//             _snack("Deleted: ${item.brandName}", _AppColors.rejected),
//           );
//         },
//       ),
//     );
//   }

//   void _onUpload(BuildContext ctx, dynamic item) {
//     showDialog(
//       context: ctx,
//       builder: (_) => _ActionDialog(
//         title: "Upload Files",
//         icon: Icons.upload_rounded,
//         iconColor: _AppColors.approved,
//         content:
//             "Upload files for brand: ${item.brandName ?? 'N/A'}\n\nSupported: PDF, PNG, JPG, XLSX",
//         confirmLabel: "Choose Files",
//         confirmColor: _AppColors.approved,
//         onConfirm: () {
//           Navigator.pop(ctx);
//           // TODO: Open file picker
//           ScaffoldMessenger.of(ctx).showSnackBar(
//             _snack(
//                 "File picker opened for ${item.brandName}", _AppColors.approved),
//           );
//         },
//       ),
//     );
//   }

//   void _onDownload(BuildContext ctx, dynamic item) {
//     showDialog(
//       context: ctx,
//       builder: (_) => _ActionDialog(
//         title: "Download Files",
//         icon: Icons.download_rounded,
//         iconColor: _AppColors.pending,
//         content: "Download all files for brand: ${item.brandName ?? 'N/A'}",
//         confirmLabel: "Download",
//         confirmColor: _AppColors.pending,
//         onConfirm: () {
//           Navigator.pop(ctx);
//           // TODO: Trigger download
//           ScaffoldMessenger.of(ctx).showSnackBar(
//             _snack(
//                 "Downloading files for ${item.brandName}", _AppColors.pending),
//           );
//         },
//       ),
//     );
//   }

//   SnackBar _snack(String msg, Color color) => SnackBar(
//         content: Text(msg, style: const TextStyle(color: Colors.white)),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       );
// }

// // ─────────────────────────────────────────────
// // SIDE NAV  ← FIXED: proper BuildContext & GoRouter
// // ─────────────────────────────────────────────
// class _SideNav extends StatelessWidget {
//   final String activeRoute;
//   const _SideNav({required this.activeRoute});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 220,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         color: _AppColors.surface,
//         border: Border(right: BorderSide(color: _AppColors.border)),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x06000000),
//             blurRadius: 12,
//             offset: Offset(2, 0),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── LOGO ──
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(
//               top: MediaQuery.of(context).padding.top + 20,
//               left: 20,
//               right: 20,
//               bottom: 20,
//             ),
//             decoration: const BoxDecoration(
//               border: Border(bottom: BorderSide(color: _AppColors.border)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: _AppColors.primaryLight,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.bolt_rounded,
//                       color: _AppColors.primary, size: 20),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   "Activity\nTracker",
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: _AppColors.textPrimary,
//                     height: 1.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),

//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//             child: Text(
//               "MENU",
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//                 color: _AppColors.textSecondary,
//                 letterSpacing: 1.4,
//               ),
//             ),
//           ),

//           const SizedBox(height: 4),

//           // ── DASHBOARD (active highlight) ──
//           _NavItem(
//             icon: Icons.dashboard_rounded,
//             label: "Dashboard",
//             isActive: true, // always active on this screen
//             onTap: () {
//               // Already here — just do nothing or re-fetch
//             },
//           ),

//           // ── EDIT ACTIVITY ──
//           // Uses context.push so dashboard stays in back-stack
//           _NavItem(
//             icon: Icons.edit_note_rounded,
//             label: "Edit Activity",
//             isActive: false,
//             onTap: () => context.push(AppRoutes.editActivityScreen),
//           ),

//           const Spacer(),

//           const Divider(height: 1, color: _AppColors.border),
//           const SizedBox(height: 8),

//           // ── LOGOUT ──
//           _NavItem(
//             icon: Icons.logout_rounded,
//             label: "Logout",
//             isDanger: true,
//             onTap: () => _confirmLogout(context),
//           ),

//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => _ActionDialog(
//         title: "Logout",
//         icon: Icons.logout_rounded,
//         iconColor: _AppColors.rejected,
//         content: "Are you sure you want to logout?",
//         confirmLabel: "Logout",
//         confirmColor: _AppColors.rejected,
//         onConfirm: () {
//           Navigator.pop(context);
//           // TODO: Clear session → context.go(AppRoutes.login)
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // NAV ITEM
// // ─────────────────────────────────────────────
// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   final bool isDanger;
//   final VoidCallback onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.isActive = false,
//     this.isDanger = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Color iconColor = isDanger
//         ? _AppColors.rejected
//         : isActive
//             ? _AppColors.primary
//             : _AppColors.textSecondary;

//     final Color textColor = isDanger
//         ? _AppColors.rejected
//         : isActive
//             ? _AppColors.primary
//             : _AppColors.textPrimary;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(10),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(10),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color:
//                   isActive ? _AppColors.primaryLight : Colors.transparent,
//               borderRadius: BorderRadius.circular(10),
//               border: isActive
//                   ? Border.all(
//                       color: _AppColors.primary.withOpacity(0.15))
//                   : null,
//             ),
//             child: Row(
//               children: [
//                 Icon(icon, size: 19, color: iconColor),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: isActive
//                           ? FontWeight.w600
//                           : FontWeight.w500,
//                       color: textColor,
//                     ),
//                   ),
//                 ),
//                 if (isActive)
//                   Container(
//                     width: 6,
//                     height: 6,
//                     decoration: const BoxDecoration(
//                       color: _AppColors.primary,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // HEADER
// // ─────────────────────────────────────────────
// class _Header extends StatelessWidget {
//   final ActivityDashViewModel vm;
//   const _Header({required this.vm});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 16,
//         left: 20,
//         right: 20,
//         bottom: 16,
//       ),
//       decoration: BoxDecoration(
//         color: _AppColors.surface,
//         border:
//             Border(bottom: BorderSide(color: _AppColors.border, width: 1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: _AppColors.primaryLight,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.bar_chart_rounded,
//                 color: _AppColors.primary, size: 22),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Activity Dashboard",
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                   color: _AppColors.textPrimary,
//                   letterSpacing: -0.3,
//                 ),
//               ),
//               Text(
//                 "${vm.dashboardList.length} total records",
//                 style: const TextStyle(
//                     fontSize: 12, color: _AppColors.textSecondary),
//               ),
//             ],
//           ),
//           const Spacer(),
//           // ✅ "+ New Activity" button navigates to edit screen
//           _PillButton(
//             icon: Icons.add_rounded,
//             label: "New Activity",
//             onTap: () => context.push(AppRoutes.editActivityScreen),
//           ),
//           const SizedBox(width: 10),
//           _PillButton(
//             icon: Icons.refresh_rounded,
//             label: "Refresh",
//             onTap: () {
//               context.read<ActivityDashViewModel>().fetchDashboardDetails(
//                     type: "VIEW",
//                     activityID: 0,
//                     userID: vm.dbRepository.userData?.userID,
//                   );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PillButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   const _PillButton(
//       {required this.icon, required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: _AppColors.primaryLight,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: _AppColors.primary.withOpacity(0.2)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: _AppColors.primary, size: 15),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: _AppColors.primary,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // KPI ROW
// // ─────────────────────────────────────────────
// class _KpiRow extends StatelessWidget {
//   final ActivityDashViewModel vm;
//   const _KpiRow({required this.vm});

//   int _count(String keyword) => vm.dashboardList
//       .where((e) =>
//           (e.activityStatusName ?? "").toLowerCase().contains(keyword))
//       .length;

//   @override
//   Widget build(BuildContext context) {
//     final cards = [
//       _KpiData("Total", vm.dashboardList.length, Icons.layers_rounded,
//           _AppColors.total, _AppColors.totalBg),
//       _KpiData("Approved", _count("approved"), Icons.check_circle_rounded,
//           _AppColors.approved, _AppColors.approvedBg),
//       _KpiData("Pending", _count("pending"), Icons.access_time_rounded,
//           _AppColors.pending, _AppColors.pendingBg),
//       _KpiData("Rejected", _count("rejected"), Icons.cancel_rounded,
//           _AppColors.rejected, _AppColors.rejectedBg),
//     ];

//     return Row(
//       children: cards
//           .asMap()
//           .entries
//           .map((e) => Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(left: e.key == 0 ? 0 : 10),
//                   child: _KpiCard(data: e.value),
//                 ),
//               ))
//           .toList(),
//     );
//   }
// }

// class _KpiData {
//   final String label;
//   final int value;
//   final IconData icon;
//   final Color color;
//   final Color bg;
//   const _KpiData(this.label, this.value, this.icon, this.color, this.bg);
// }

// class _KpiCard extends StatelessWidget {
//   final _KpiData data;
//   const _KpiCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//       decoration: BoxDecoration(
//         color: _AppColors.surface,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _AppColors.border),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "${data.value}",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w800,
//                   color: data.color,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: data.bg,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(data.icon, color: data.color, size: 18),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             data.label,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: _AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // TOOLBAR
// // ─────────────────────────────────────────────
// class _ToolbarRow extends StatelessWidget {
//   final String searchQuery;
//   final String selectedStatus;
//   final List<String> statusFilters;
//   final ValueChanged<String> onSearch;
//   final ValueChanged<String> onFilter;

//   const _ToolbarRow({
//     required this.searchQuery,
//     required this.selectedStatus,
//     required this.statusFilters,
//     required this.onSearch,
//     required this.onFilter,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 44,
//             decoration: BoxDecoration(
//               color: _AppColors.surface,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: _AppColors.border),
//             ),
//             child: TextField(
//               style: const TextStyle(
//                   fontSize: 14, color: _AppColors.textPrimary),
//               decoration: const InputDecoration(
//                 hintText: "Search by brand...",
//                 hintStyle: TextStyle(
//                     fontSize: 14, color: _AppColors.textSecondary),
//                 prefixIcon: Icon(Icons.search_rounded,
//                     color: _AppColors.textSecondary, size: 20),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                     horizontal: 12, vertical: 12),
//               ),
//               onChanged: onSearch,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Container(
//           height: 44,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: _AppColors.surface,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _AppColors.border),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: selectedStatus,
//               icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                   color: _AppColors.textSecondary, size: 18),
//               style: const TextStyle(
//                   fontSize: 13,
//                   color: _AppColors.textPrimary,
//                   fontWeight: FontWeight.w500),
//               items: statusFilters
//                   .map((s) =>
//                       DropdownMenuItem(value: s, child: Text(s)))
//                   .toList(),
//               onChanged: (v) => onFilter(v!),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // DATA TABLE
// // ─────────────────────────────────────────────
// class _DataTable extends StatelessWidget {
//   final List data;
//   final Function(dynamic) onEdit;
//   final Function(dynamic) onDelete;
//   final Function(dynamic) onUpload;
//   final Function(dynamic) onDownload;

//   const _DataTable({
//     required this.data,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onUpload,
//     required this.onDownload,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (data.isEmpty) return _EmptyState();

//     return Container(
//       decoration: BoxDecoration(
//         color: _AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _AppColors.border),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SingleChildScrollView(
//             child: DataTable(
//               columnSpacing: 20,
//               horizontalMargin: 16,
//               headingRowHeight: 44,
//               dataRowMinHeight: 52,
//               dataRowMaxHeight: 60,
//               headingRowColor: MaterialStateProperty.all(
//                   const Color(0xFFF8FAFF)),
//               dividerThickness: 1,
//               border: TableBorder(
//                 horizontalInside:
//                     BorderSide(color: _AppColors.border, width: 0.8),
//               ),
//               columns: [
//                 _col("Brand"),
//                 _col("Product"),
//                 _col("Campaign"),
//                 _col("Status"),
//                 _col("Date"),
//                 _col("Actions"),
//               ],
//               rows: data.asMap().entries.map<DataRow>((entry) {
//                 final item = entry.value;
//                 final isEven = entry.key % 2 == 0;
//                 return DataRow(
//                   color: MaterialStateProperty.resolveWith((states) {
//                     if (states.contains(MaterialState.hovered)) {
//                       return _AppColors.primaryLight;
//                     }
//                     return isEven
//                         ? Colors.white
//                         : const Color(0xFFFAFBFF);
//                   }),
//                   cells: [
//                     DataCell(_brandCell(item.brandName)),
//                     DataCell(_textCell(item.productName)),
//                     DataCell(_textCell(item.campaignName)),
//                     DataCell(
//                         _StatusBadge(status: item.activityStatusName)),
//                     DataCell(_dateCell(item.createdDate)),
//                     DataCell(_ActionsCell(
//                       onEdit: () => onEdit(item),
//                       onDelete: () => onDelete(item),
//                       onUpload: () => onUpload(item),
//                       onDownload: () => onDownload(item),
//                     )),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   DataColumn _col(String label, {bool center = false}) => DataColumn(
//         label: Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//             color: _AppColors.textSecondary,
//             letterSpacing: 0.5,
//           ),
//         ),
//       );

//   Widget _brandCell(String? name) => Row(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: _AppColors.primaryLight,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(
//                 (name ?? "?").isNotEmpty ? name![0].toUpperCase() : "?",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     color: _AppColors.primary,
//                     fontSize: 13),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text(name ?? "-",
//               style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13,
//                   color: _AppColors.textPrimary)),
//         ],
//       );

//   Widget _textCell(String? text) => Text(text ?? "-",
//       style:
//           const TextStyle(fontSize: 13, color: _AppColors.textPrimary),
//       overflow: TextOverflow.ellipsis);

//   Widget _dateCell(String? date) => Row(
//         children: [
//           const Icon(Icons.calendar_today_rounded,
//               size: 13, color: _AppColors.textSecondary),
//           const SizedBox(width: 5),
//           Text(date ?? "-",
//               style: const TextStyle(
//                   fontSize: 12, color: _AppColors.textSecondary)),
//         ],
//       );
// }

// // ─────────────────────────────────────────────
// // STATUS BADGE
// // ─────────────────────────────────────────────
// class _StatusBadge extends StatelessWidget {
//   final String? status;
//   const _StatusBadge({this.status});

//   @override
//   Widget build(BuildContext context) {
//     final lower = (status ?? "").toLowerCase();
//     Color color;
//     Color bg;
//     IconData icon;

//     if (lower.contains("approved")) {
//       color = _AppColors.approved;
//       bg = _AppColors.approvedBg;
//       icon = Icons.check_circle_rounded;
//     } else if (lower.contains("pending")) {
//       color = _AppColors.pending;
//       bg = _AppColors.pendingBg;
//       icon = Icons.access_time_rounded;
//     } else if (lower.contains("rejected")) {
//       color = _AppColors.rejected;
//       bg = _AppColors.rejectedBg;
//       icon = Icons.cancel_rounded;
//     } else {
//       color = _AppColors.textSecondary;
//       bg = _AppColors.border;
//       icon = Icons.help_outline_rounded;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//           color: bg, borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 5),
//           Text(status ?? "-",
//               style: TextStyle(
//                   color: color,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // ACTIONS CELL
// // ─────────────────────────────────────────────
// class _ActionsCell extends StatelessWidget {
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onUpload;
//   final VoidCallback onDownload;

//   const _ActionsCell({
//     required this.onEdit,
//     required this.onDelete,
//     required this.onUpload,
//     required this.onDownload,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _ActionBtn(
//             icon: Icons.edit_rounded,
//             color: _AppColors.primary,
//             tooltip: "Edit",
//             onTap: onEdit),
//         _ActionBtn(
//             icon: Icons.upload_rounded,
//             color: _AppColors.approved,
//             tooltip: "Upload",
//             onTap: onUpload),
//         _ActionBtn(
//             icon: Icons.download_rounded,
//             color: _AppColors.pending,
//             tooltip: "Download",
//             onTap: onDownload),
//         _ActionBtn(
//             icon: Icons.delete_rounded,
//             color: _AppColors.rejected,
//             tooltip: "Delete",
//             onTap: onDelete),
//       ],
//     );
//   }
// }

// class _ActionBtn extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String tooltip;
//   final VoidCallback onTap;
//   const _ActionBtn(
//       {required this.icon,
//       required this.color,
//       required this.tooltip,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Tooltip(
//       message: tooltip,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Container(
//           width: 30,
//           height: 30,
//           margin: const EdgeInsets.only(right: 6),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, size: 16, color: color),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // FOOTER
// // ─────────────────────────────────────────────
// class _Footer extends StatelessWidget {
//   final int total;
//   const _Footer({required this.total});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: Text(
//         "Showing $total record${total == 1 ? '' : 's'}",
//         style: const TextStyle(
//             fontSize: 12, color: _AppColors.textSecondary),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // EMPTY STATE
// // ─────────────────────────────────────────────
// class _EmptyState extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 72,
//             height: 72,
//             decoration: BoxDecoration(
//               color: _AppColors.primaryLight,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Icon(Icons.inbox_rounded,
//                 size: 36, color: _AppColors.primary),
//           ),
//           const SizedBox(height: 16),
//           const Text("No records found",
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: _AppColors.textPrimary)),
//           const SizedBox(height: 6),
//           const Text("Try adjusting your search or filter",
//               style: TextStyle(
//                   fontSize: 13, color: _AppColors.textSecondary)),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // LOADING VIEW
// // ─────────────────────────────────────────────
// class _LoadingView extends StatelessWidget {
//   const _LoadingView();

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//               color: _AppColors.primary, strokeWidth: 2.5),
//           SizedBox(height: 16),
//           Text("Loading activities...",
//               style: TextStyle(
//                   color: _AppColors.textSecondary, fontSize: 14)),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // ERROR VIEW
// // ─────────────────────────────────────────────
// class _ErrorView extends StatelessWidget {
//   final String? message;
//   const _ErrorView({this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: _AppColors.rejectedBg,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: const Icon(Icons.error_outline_rounded,
//                 size: 32, color: _AppColors.rejected),
//           ),
//           const SizedBox(height: 14),
//           const Text("Something went wrong",
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: _AppColors.textPrimary)),
//           const SizedBox(height: 6),
//           Text(message ?? "Please try again",
//               style: const TextStyle(
//                   fontSize: 13, color: _AppColors.textSecondary)),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () {
//               context.read<ActivityDashViewModel>().fetchDashboardDetails(
//                     type: "VIEW",
//                     activityID: 0,
//                     userID: context
//                         .read<ActivityDashViewModel>()
//                         .dbRepository
//                         .userData
//                         ?.userID,
//                   );
//             },
//             icon: const Icon(Icons.refresh_rounded, size: 16),
//             label: const Text("Retry"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _AppColors.primary,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 20, vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // ACTION DIALOG
// // ─────────────────────────────────────────────
// class _ActionDialog extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color iconColor;
//   final String content;
//   final String confirmLabel;
//   final Color confirmColor;
//   final VoidCallback onConfirm;

//   const _ActionDialog({
//     required this.title,
//     required this.icon,
//     required this.iconColor,
//     required this.content,
//     required this.confirmLabel,
//     required this.confirmColor,
//     required this.onConfirm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: iconColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: iconColor, size: 22),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(title,
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: _AppColors.textPrimary)),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: _AppColors.bg,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(content,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       color: _AppColors.textSecondary,
//                       height: 1.5)),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: _AppColors.textSecondary,
//                       side: const BorderSide(color: _AppColors.border),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       padding:
//                           const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text("Cancel"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: onConfirm,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: confirmColor,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       padding:
//                           const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: Text(confirmLabel,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }