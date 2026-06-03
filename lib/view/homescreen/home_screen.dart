import 'package:activity_tracker/data/remote/response/status.dart';
import 'package:activity_tracker/utils/routes/app_routes.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/view/homescreen/widget/activity_screen.dart';

// ─────────────────────────────────────────────
// RESOLUTION PORTAL DESIGN TOKENS
// ─────────────────────────────────────────────
class _RP {
  // Core colors
  static const bg = Color(0xFFF5F6FC); // lightLavender
  static const surface = Colors.white;
  static const primary = Color(0xFF3243E0); // royalBlue
  static const primaryDark = Color(0xFF2A1FA3);
  static const primaryLight = Color(0xFFEEF2FF);
  static const golden = Color(0xFFE8B84B); // JLL gold accent

  // Status
  static const approved = Color(0xFF059669);
  static const approvedBg = Color(0xFFECFDF5);
  static const pending = Color(0xFFD97706);
  static const pendingBg = Color(0xFFFFFBEB);
  static const rejected = Color(0xFFBE3730);
  static const rejectedBg = Color(0xFFFEF2F2);
  static const total = Color(0xFF3243E0);
  static const totalBg = Color(0xFFEEF2FF);

  // Text & borders
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF666666);
  static const border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFEDEFF5);
}

// ─────────────────────────────────────────────
// ACTIVE SCREEN ENUM
// ─────────────────────────────────────────────
enum _ActiveScreen { dashboard, editActivity }

// ─────────────────────────────────────────────
// MAIN DASHBOARD WIDGET
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
  _ActiveScreen _activeScreen = _ActiveScreen.dashboard;

  final _statusFilters = ["All", "Approved", "Pending", "Rejected"];

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

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

  void _goToEditActivity() =>
      setState(() => _activeScreen = _ActiveScreen.editActivity);

  void _goToDashboard() {
    setState(() => _activeScreen = _ActiveScreen.dashboard);
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
    final userName =
        context
            .watch<ActivityDashViewModel>()
            .dbRepository
            .userData
            ?.userName ??
        'User';
    final initials = _getInitials(userName);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: _RP.bg,
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _activeScreen == _ActiveScreen.dashboard ? 0 : 1,
              selectedItemColor: _RP.primary,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 8,
              selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500),
              onTap: (index) {
                if (index == 0) {
                  _goToDashboard();
                } else if (index == 1) {
                  _goToEditActivity();
                } else if (index == 2) {
                  _confirmLogout(context);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: 'Activity',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout_rounded),
                  label: 'Logout',
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          // ── TOP APP BAR (Resolution Portal style) ──────────────────
          _buildAppBar(initials, userName, isMobile),

          // ── BODY ───────────────────────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── SIDE NAV ─────────────────────────────────────────
                if (!isMobile)
                  _SideNav(
                    activeScreen: _activeScreen,
                    onDashboardTap: _goToDashboard,
                    onEditActivityTap: _goToEditActivity,
                    onLogoutTap: () => _confirmLogout(context),
                  ),

                if (!isMobile)
                  const VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: Color(0xFFE9E8E8),
                  ),

                // ── CONTENT ──────────────────────────────────────────
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
          ),
        ],
      ),
    );
  }

  // ── APP BAR (Resolution Portal style: white + golden bottom line) ──
  Widget _buildAppBar(String initials, String userName, bool isMobile) {
    return Container(
      height: 110 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: _RP.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Golden bottom border — Resolution Portal signature
          Positioned(
            left: -20,
            right: -16,
            bottom: 0,
            child: Container(height: 1, color: _RP.golden),
          ),
          Row(
            children: [
              // Hamburger menu removed for bottom navigation
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/log_icon.png',
                  height: isMobile ? 50 : 75,
                  width: isMobile ? 50 : 75,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: isMobile ? 12 : 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jyothy Labs',
                      style: GoogleFonts.poppins(
                        color: _RP.primary,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'ACTIVITY TRACKER PORTAL',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF64748B),
                        fontSize: isMobile ? 8 : 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // User name badge (Pill shaped)
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userName.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Avatar with popup
              _UserAvatar(
                initials: initials,
                onLogout: () => _confirmLogout(context),
              ),
            ],
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Welcome Banner ─────────────────────────────────
                _WelcomeBanner(
                  userName: vm.dbRepository.userData?.userName ?? 'User',
                  total: vm.dashboardList.length,
                  onRefresh: () {
                    context.read<ActivityDashViewModel>().fetchDashboardDetails(
                      type: "VIEW",
                      activityID: 0,
                      userID: vm.dbRepository.userData?.userID,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ── KPI Stat Cards ──────────────────────────────────
                _KpiRow(vm: vm),
                const SizedBox(height: 28),

                // ── Toolbar ─────────────────────────────────────────
                _ToolbarRow(
                  searchQuery: _searchQuery,
                  selectedStatus: _selectedStatus,
                  statusFilters: _statusFilters,
                  onSearch: (v) => setState(() => _searchQuery = v),
                  onFilter: (v) => setState(() => _selectedStatus = v),
                  onNewActivity: _goToEditActivity,
                ),
                const SizedBox(height: 16),

                // ── Data Table ──────────────────────────────────────
                _DataTable(
                  data: filtered,
                  onEdit: (item) => _onEdit(context, item),
                  onDelete: (item) => _onDelete(context, item, vm),
                  onUpload: (item) => _onUpload(context, item),
                  onDownload: (item) => _onDownload(context, item),
                ),
                const SizedBox(height: 12),

                // Footer
                _Footer(total: filtered.length),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── ACTIONS ──────────────────────────────────────────────────────
  void _onEdit(BuildContext ctx, dynamic item) {
    showDialog(
      context: ctx,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _ActionDialog(
            title: "Edit Activity",
            icon: Icons.edit_rounded,
            iconColor: _RP.primary,
            content:
                "Edit entry for brand: ${item.brandName ?? 'N/A'}\n\nCampaign: ${item.campaignName ?? 'N/A'}",
            confirmLabel: "Open Editor",
            confirmColor: _RP.primary,
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
          constraints: const BoxConstraints(maxWidth: 480),
          child: _ActionDialog(
            title: "Delete Activity",
            icon: Icons.delete_rounded,
            iconColor: _RP.rejected,
            content:
                "Are you sure you want to delete the activity for\n\"${item.brandName ?? 'N/A'}\"?\n\nThis action cannot be undone.",
            confirmLabel: "Delete",
            confirmColor: _RP.rejected,
            onConfirm: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                _snack("Deleted: ${item.brandName}", _RP.rejected),
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
          constraints: const BoxConstraints(maxWidth: 480),
          child: _ActionDialog(
            title: "Upload Files",
            icon: Icons.upload_rounded,
            iconColor: _RP.approved,
            content:
                "Upload files for brand: ${item.brandName ?? 'N/A'}\n\nSupported: PDF, PNG, JPG, XLSX",
            confirmLabel: "Choose Files",
            confirmColor: _RP.approved,
            onConfirm: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                _snack(
                  "File picker opened for ${item.brandName}",
                  _RP.approved,
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
          constraints: const BoxConstraints(maxWidth: 480),
          child: _ActionDialog(
            title: "Download Files",
            icon: Icons.download_rounded,
            iconColor: _RP.pending,
            content: "Download all files for brand: ${item.brandName ?? 'N/A'}",
            confirmLabel: "Download",
            confirmColor: _RP.pending,
            onConfirm: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                _snack("Downloading files for ${item.brandName}", _RP.pending),
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
          constraints: const BoxConstraints(maxWidth: 480),
          child: _ActionDialog(
            title: "Logout",
            icon: Icons.logout_rounded,
            iconColor: _RP.rejected,
            content: "Are you sure you want to logout?",
            confirmLabel: "Logout",
            confirmColor: _RP.rejected,
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
    content: Text(
      msg,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
  );
}

// ─────────────────────────────────────────────
// USER AVATAR POPUP
// ─────────────────────────────────────────────
class _UserAvatar extends StatelessWidget {
  final String initials;
  final VoidCallback onLogout;
  const _UserAvatar({required this.initials, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: PopupMenuButton<String>(
        tooltip: 'Profile',
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
            color: Color(0xFFEAB308), // Resolution Portal Golden Yellow
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: false,
            child: Text(
              'Signed In',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: _RP.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                const Icon(Icons.logout, color: Color(0xFFBE3730), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFBE3730),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'logout') onLogout();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDE NAV — Resolution Portal tile style
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
      width: 250,
      color: _RP.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu items
          _buildTileNavItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isSelected: activeScreen == _ActiveScreen.dashboard,
            onTap: onDashboardTap,
          ),
          const SizedBox(height: 8),
          _buildTileNavItem(
            icon: Icons.edit_note_rounded,
            label: 'Add Activity',
            isSelected: activeScreen == _ActiveScreen.editActivity,
            onTap: onEditActivityTap,
          ),

          const Spacer(),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Logout
          _buildLogoutItem(onTap: onLogoutTap),
        ],
      ),
    );
  }

  // ── Tile Nav Item (Resolution Portal card style) ──────────────────
  Widget _buildTileNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFDFDFB) : const Color(0xFFF3F3ED),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected
              ? _RP.primary.withOpacity(0.15)
              : Colors.black.withOpacity(0.05),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icon container with gradient when selected
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [_RP.primary, _RP.primary.withOpacity(0.8)]
                        : [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _RP.primary.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? Colors.white : _RP.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? _RP.primary : _RP.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Logout Item ──────────────────────────────────────────────────
  Widget _buildLogoutItem({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFBE3730).withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFBE3730).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFBE3730),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFBE3730),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WELCOME BANNER — Resolution Portal signature
// ─────────────────────────────────────────────
class _WelcomeBanner extends StatelessWidget {
  final String userName;
  final int total;
  final VoidCallback onRefresh;

  const _WelcomeBanner({
    required this.userName,
    required this.total,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: _RP.primary, width: 6)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Welcome Back, ',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1E293B),
                        ),
                        children: [
                          TextSpan(
                            text: '$userName!',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manage and track all your activity records seamlessly. ($total total records)',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Refresh button
              InkWell(
                onTap: onRefresh,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _RP.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _RP.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.refresh_rounded,
                        color: _RP.primary,
                        size: 17,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Refresh',
                        style: GoogleFonts.poppins(
                          color: _RP.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// KPI ROW — Resolution Portal stat card style
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
        label: 'Total Activities',
        count: vm.dashboardList.length,
        icon: Icons.layers_rounded,
        activeColor: _RP.total,
        activeBg: _RP.totalBg,
        activeTextColor: _RP.primary,
        activeSubtextColor: _RP.primary,
      ),
      _KpiData(
        label: 'Approved',
        count: _count('approved'),
        icon: Icons.check_circle_outline_rounded,
        activeColor: _RP.approved,
        activeBg: _RP.approvedBg,
        activeTextColor: const Color(0xFF047857),
        activeSubtextColor: const Color(0xFF065F46),
      ),
      _KpiData(
        label: 'Pending',
        count: _count('pending'),
        icon: Icons.hourglass_empty_rounded,
        activeColor: _RP.pending,
        activeBg: _RP.pendingBg,
        activeTextColor: const Color(0xFF92400E),
        activeSubtextColor: const Color(0xFFB45309),
      ),
      _KpiData(
        label: 'Rejected',
        count: _count('rejected'),
        icon: Icons.cancel_outlined,
        activeColor: _RP.rejected,
        activeBg: _RP.rejectedBg,
        activeTextColor: const Color(0xFF991B1B),
        activeSubtextColor: const Color(0xFFB91C1C),
      ),
    ];

    final isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return Column(
        children: cards
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(top: e.key == 0 ? 0 : 12),
                child: SizedBox(
                  width: double.infinity,
                  child: _KpiCard(data: e.value),
                ),
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: cards
          .asMap()
          .entries
          .map(
            (e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: e.key == 0 ? 0 : 12),
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
  final int count;
  final IconData icon;
  final Color activeColor;
  final Color activeBg;
  final Color activeTextColor;
  final Color activeSubtextColor;

  const _KpiData({
    required this.label,
    required this.count,
    required this.icon,
    required this.activeColor,
    required this.activeBg,
    required this.activeTextColor,
    required this.activeSubtextColor,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: data.activeColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: data.activeColor.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: data.activeBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(data.icon, color: data.activeColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: data.activeSubtextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data.count} items',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: data.activeTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: data.activeColor, size: 16),
          ],
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.activeBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: data.activeColor.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: data.activeColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.count}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: data.activeTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: data.activeSubtextColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: data.activeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.activeColor, size: 20),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOOLBAR ROW
// ─────────────────────────────────────────────
class _ToolbarRow extends StatelessWidget {
  final String searchQuery;
  final String selectedStatus;
  final List<String> statusFilters;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilter;
  final VoidCallback onNewActivity;

  const _ToolbarRow({
    required this.searchQuery,
    required this.selectedStatus,
    required this.statusFilters,
    required this.onSearch,
    required this.onFilter,
    required this.onNewActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search field
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _RP.border),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6),
              ],
            ),
            child: TextField(
              style: GoogleFonts.poppins(fontSize: 12, color: _RP.textPrimary),
              decoration: InputDecoration(
                hintText: "Search by brand...",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _RP.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: _RP.textSecondary,
                  size: 19,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: onSearch,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Status filter
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _RP.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _RP.textSecondary,
                size: 18,
              ),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _RP.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              items: statusFilters
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => onFilter(v!),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // New Activity button
        GestureDetector(
          onTap: onNewActivity,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_RP.primary, _RP.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _RP.primary.withOpacity(0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'New Activity',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
    if (data.isEmpty) return const _EmptyState();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _RP.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
              horizontalMargin: 18,
              headingRowHeight: 46,
              dataRowMinHeight: 54,
              dataRowMaxHeight: 62,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FE)),
              dividerThickness: 0.8,
              border: TableBorder(
                horizontalInside: BorderSide(color: _RP.border, width: 0.8),
              ),
              columns: [
                _col("Actions"),

                _col("Activity ID"),
                _col("Description"),
                _col("Status"),
                _col("List of Activity"),
                _col("Brand Business Structure"),
                _col("Period"),
                _col("Medium"),
                _col("Vendor/Agency"),
                _col("Spends"),
              ],
              rows: data.asMap().entries.map<DataRow>((entry) {
                final item = entry.value;
                final isEven = entry.key % 2 == 0;
                return DataRow(
                  color: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return _RP.primaryLight;
                    }
                    return isEven ? Colors.white : const Color(0xFFFAFBFF);
                  }),
                  cells: [
                    DataCell(
                      _ActionsCell(
                        onEdit: () => onEdit(item),
                        onDelete: () => onDelete(item),
                        onUpload: () => onUpload(item),
                        onDownload: () => onDownload(item),
                      ),
                    ),
                    DataCell(_textCell(item.activityID?.toString() ?? "-")), // Activity ID
                    DataCell(_textCell(item.campaignName)), // Description
                    DataCell(_StatusBadge(status: item.activityStatusName)), // Status
                    DataCell(_textCell(item.productName)), // List of Activity (fallback)
                    DataCell(_brandCell(item.brandName)), // Brand Business Structure
                    DataCell(_textCell('${item.activityPeriodFrom ?? "-"} to ${item.activityPeriodTo ?? "-"}')), // Period
                    DataCell(_textCell(item.mediumName?.toString() ?? "-")), // Medium
                    DataCell(_textCell(item.vehicle?.toString() ?? "-")), // Vendor/Agency
                    DataCell(_textCell("-")), // Spends
                    
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
      label.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _RP.textSecondary,
        letterSpacing: 0.6,
      ),
    ),
  );

  Widget _brandCell(String? name) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_RP.primary, _RP.primaryDark],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            (name ?? "?").isNotEmpty ? name![0].toUpperCase() : "?",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        name ?? "-",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: _RP.textPrimary,
        ),
      ),
    ],
  );

  Widget _textCell(String? text) => Text(
    text ?? "-",
    style: GoogleFonts.poppins(fontSize: 12, color: _RP.textPrimary),
    overflow: TextOverflow.ellipsis,
  );

  Widget _dateCell(String? date) => Row(
    children: [
      const Icon(
        Icons.calendar_today_rounded,
        size: 13,
        color: _RP.textSecondary,
      ),
      const SizedBox(width: 5),
      Text(
        date ?? "-",
        style: GoogleFonts.poppins(fontSize: 11, color: _RP.textSecondary),
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
      color = _RP.approved;
      bg = _RP.approvedBg;
      icon = Icons.check_circle_rounded;
    } else if (lower.contains("pending")) {
      color = _RP.pending;
      bg = _RP.pendingBg;
      icon = Icons.access_time_rounded;
    } else if (lower.contains("rejected")) {
      color = _RP.rejected;
      bg = _RP.rejectedBg;
      icon = Icons.cancel_rounded;
    } else {
      color = _RP.textSecondary;
      bg = _RP.border;
      icon = Icons.help_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            status ?? "-",
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 11,
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
          color: _RP.primary,
          tooltip: "Edit",
          onTap: onEdit,
        ),
        // _ActionBtn(
        //   icon: Icons.upload_rounded,
        //   color: _RP.approved,
        //   tooltip: "Upload",
        //   onTap: onUpload,
        // ),
        // _ActionBtn(
        //   icon: Icons.download_rounded,
        //   color: _RP.pending,
        //   tooltip: "Download",
        //   onTap: onDownload,
        // ),
        _ActionBtn(
          icon: Icons.delete_rounded,
          color: _RP.rejected,
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
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Icon(icon, size: 15, color: color),
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
        style: GoogleFonts.poppins(fontSize: 11, color: _RP.textSecondary),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _RP.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 36,
              color: _RP.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No records found",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _RP.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Try adjusting your search or filter",
            style: GoogleFonts.poppins(fontSize: 12, color: _RP.textSecondary),
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
          const CircularProgressIndicator(color: _RP.primary, strokeWidth: 2.5),
          const SizedBox(height: 16),
          Text(
            "Loading activities...",
            style: GoogleFonts.poppins(color: _RP.textSecondary, fontSize: 13),
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
              color: _RP.rejectedBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 32,
              color: _RP.rejected,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Something went wrong",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _RP.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message ?? "Please try again",
            style: GoogleFonts.poppins(fontSize: 12, color: _RP.textSecondary),
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
            label: Text(
              "Retry",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _RP.primary,
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
// ACTION DIALOG — Resolution Portal style
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _RP.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _RP.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _RP.border),
              ),
              child: Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _RP.textSecondary,
                  height: 1.55,
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
                      foregroundColor: _RP.textSecondary,
                      side: BorderSide(color: _RP.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
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
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      confirmLabel,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
