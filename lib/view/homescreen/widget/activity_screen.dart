import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'activity_sections/activity_form_section.dart';
import 'activity_sections/agency_partner_section.dart';
import 'activity_sections/execution_element_section.dart';
import 'activity_sections/authorisation_docs_section.dart';
import 'activity_sections/supporting_docs_section.dart';

class EditActivityScreen extends StatefulWidget {
  final ActivityDashViewModel vm;
  final VoidCallback onBack; // ✅ dashboard wapas jaane ke liye callback
  const EditActivityScreen({super.key, required this.vm, required this.onBack});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  late List<bool> _expandedSections;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const List<_SectionMeta> _sections = [
    _SectionMeta(
      title: 'Activity Details',
      icon: Icons.edit_note_outlined,
      accent: Color(0xFF6C63FF),
    ),
    _SectionMeta(
      title: 'Agency Partner Details',
      icon: Icons.handshake_outlined,
      accent: Color(0xFF00B894),
    ),
    _SectionMeta(
      title: 'Execution Element Details',
      icon: Icons.settings_input_component_outlined,
      accent: Color(0xFF0984E3),
    ),
    _SectionMeta(
      title: 'Authorisation Documents',
      icon: Icons.verified_user_outlined,
      accent: Color(0xFFE17055),
    ),
    _SectionMeta(
      title: 'Supporting Documents',
      icon: Icons.folder_open_outlined,
      accent: Color(0xFFFDAB23),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _expandedSections = List.generate(_sections.length, (i) => i == 0);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.vm.getActivityDropDownDetails();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onSectionSaved(int index) {
    setState(() {
      _expandedSections[index] = false;
      if (_currentStep < index + 1) _currentStep = index + 1;
      if (index + 1 < _sections.length) _expandedSections[index + 1] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ProgressHeader(
                  currentStep: _currentStep,
                  totalSteps: _sections.length,
                ),
                const SizedBox(height: 24),
                ..._buildSectionCards(),
                const SizedBox(height: 32),
                _SubmitButton(
                  onPressed: widget.onBack, // ✅ save sonra dashboard wapas
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionCards() {
    final List<Widget> cards = [];
    for (int i = 0; i < _sections.length; i++) {
      if (i > 0) cards.add(const SizedBox(height: 12));
      cards.add(_buildSectionCard(i));
    }
    return cards;
  }

  Widget _buildSectionCard(int index) {
    final meta = _sections[index];
    final enabled = true;
    final expanded = _expandedSections[index];
    final done = _currentStep > index;

    final Widget sectionChild = _buildSectionChild(index);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
     opacity: 1.0,
      child: IgnorePointer(
  ignoring: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: expanded
                  ? meta.accent.withOpacity(0.5)
                  : const Color(0xFFE8EAF0),
              width: expanded ? 1.5 : 1,
            ),
            boxShadow: expanded
                ? [
                    BoxShadow(
                      color: meta.accent.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
  setState(() {
    _expandedSections[index] = !_expandedSections[index];
  });
},
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      _StepIndicator(
                        index: index,
                        accent: meta.accent,
                        done: done,
                        active: expanded,
                      ),
                      const SizedBox(width: 14),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: meta.accent.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(meta.icon, color: meta.accent, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meta.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1D2E),
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              done
                                  ? 'Completed'
                                  : expanded
                                      ? 'Fill in the details below'
                                      : 'Tap to expand',
                              style: TextStyle(
                                fontSize: 12,
                                color: done
                                    ? const Color(0xFF00B894)
                                    : const Color(0xFF9496A1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (done)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8FAF5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00B894),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: expanded ? 0.5 : 0,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFB0B3BF),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: expanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Column(
                  children: [
                    Divider(height: 1, color: meta.accent.withOpacity(0.12)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                      child: sectionChild,
                    ),
                  ],
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionChild(int index) {
    switch (index) {
      case 0:
        return ActivityFormSection(
          vm: widget.vm,
          onSaved: () => _onSectionSaved(0),
        );
      case 1:
        return AgencyPartnerSection(
          vm: widget.vm,
          onSaved: () => _onSectionSaved(1),
        );
      case 2:
        return ExecutionElementSection(
          vm: widget.vm,
          onSaved: () => _onSectionSaved(2),
        );
      case 3:
        return AuthorisationDocsSection(onSaved: () => _onSectionSaved(3));
      case 4:
        return SupportingDocsSection(onSaved: () => _onSectionSaved(4));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: const Color(0x14000000),
      automaticallyImplyLeading: false,
      // ✅ Back button — widget.onBack callback use karta hai, GoRouter nahi
      // leading: Padding(
      //   padding: const EdgeInsets.all(8),
      //   child: Material(
      //     color: Colors.white.withOpacity(0.2),
      //     borderRadius: BorderRadius.circular(10),
      //     child: InkWell(
      //       onTap: widget.onBack,
      //       borderRadius: BorderRadius.circular(10),
      //       child: const Icon(
      //         Icons.arrow_back_ios_new_rounded,
      //         size: 18,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: const BoxDecoration(
            color: AppColors.colorWhite,
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
            // ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                bottom: -40,
                child: Opacity(
                  opacity: 0.07,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ACTIVITY EDITOR',
                        style: TextStyle(
                          // color: Colors.white60,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.8,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Edit Activity',
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
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
// SECTION META
// ─────────────────────────────────────────────
class _SectionMeta {
  final String title;
  final IconData icon;
  final Color accent;
  const _SectionMeta({
    required this.title,
    required this.icon,
    required this.accent,
  });
}

// ─────────────────────────────────────────────
// STEP INDICATOR
// ─────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int index;
  final Color accent;
  final bool done;
  final bool active;

  const _StepIndicator({
    required this.index,
    required this.accent,
    required this.done,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? const Color(0xFF00B894)
            : active
                ? accent
                : const Color(0xFFF0F1F5),
        border: Border.all(
          color: done
              ? const Color(0xFF00B894)
              : active
                  ? accent
                  : const Color(0xFFDDE0EA),
          width: 1.5,
        ),
      ),
      child: Center(
        child: done
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : const Color(0xFF9496A1),
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROGRESS HEADER
// ─────────────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressHeader(
      {required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final pct = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EAF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Form Progress',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1D2E),
                ),
              ),
              Text(
                '$currentStep of $totalSteps completed',
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF9496A1)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: const Color(0xFFF0F1F5),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF6C63FF),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(totalSteps, (i) {
              final isDone = i < currentStep;
              final isActive = i == currentStep;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: isDone
                              ? const Color(0xFF6C63FF)
                              : isActive
                                  ? const Color(0xFF6C63FF).withOpacity(0.4)
                                  : const Color(0xFFE8EAF0),
                        ),
                      ),
                    ),
                    if (i < totalSteps - 1) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SUBMIT BUTTON
// ─────────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.cloud_done_outlined, size: 20),
          label: const Text(
            'Update & Save Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:activity_tracker/utils/routes/app_routes.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'activity_sections/activity_form_section.dart';
// import 'activity_sections/agency_partner_section.dart';
// import 'activity_sections/execution_element_section.dart';
// import 'activity_sections/authorisation_docs_section.dart';
// import 'activity_sections/supporting_docs_section.dart';

// class EditActivityScreen extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   const EditActivityScreen({super.key, required this.vm});

//   @override
//   State<EditActivityScreen> createState() => _EditActivityScreenState();
// }

// class _EditActivityScreenState extends State<EditActivityScreen>
//     with TickerProviderStateMixin {
//   int _currentStep = 0;
//   late List<bool> _expandedSections;
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;

//   static const List<_SectionMeta> _sections = [
//     _SectionMeta(
//       title: 'Activity Details',
//       icon: Icons.edit_note_outlined,
//       accent: Color(0xFF6C63FF),
//     ),
//     _SectionMeta(
//       title: 'Agency Partner Details',
//       icon: Icons.handshake_outlined,
//       accent: Color(0xFF00B894),
//     ),
//     _SectionMeta(
//       title: 'Execution Element Details',
//       icon: Icons.settings_input_component_outlined,
//       accent: Color(0xFF0984E3),
//     ),
//     _SectionMeta(
//       title: 'Authorisation Documents',
//       icon: Icons.verified_user_outlined,
//       accent: Color(0xFFE17055),
//     ),
//     _SectionMeta(
//       title: 'Supporting Documents',
//       icon: Icons.folder_open_outlined,
//       accent: Color(0xFFFDAB23),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _expandedSections = List.generate(_sections.length, (i) => i == 0);

//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeOut,
//     );
//     _fadeController.forward();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       widget.vm.getActivityDropDownDetails();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   void _onSectionSaved(int index) {
//     setState(() {
//       _expandedSections[index] = false;
//       if (_currentStep < index + 1) _currentStep = index + 1;
//       if (index + 1 < _sections.length) _expandedSections[index + 1] = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ FIX: sidebar always shown on wide screens — no Stack overlay needed
//     final isWide = MediaQuery.of(context).size.width >= 900;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FC),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
            

//             // ── MAIN CONTENT ─────────────────────────────────────────────
//             Expanded(
//               child: CustomScrollView(
//                 slivers: [
//                   _buildAppBar(context, showBackButton: !isWide),

//                   SliverPadding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: isWide ? 40 : 16,
//                       vertical: 24,
//                     ),
//                     sliver: SliverList(
//                       delegate: SliverChildListDelegate([
//                         _ProgressHeader(
//                           currentStep: _currentStep,
//                           totalSteps: _sections.length,
//                         ),
//                         const SizedBox(height: 24),
//                         ..._buildSectionCards(),
//                         const SizedBox(height: 32),
//                         _SubmitButton(
//                           onPressed: () => context.push(
//                             AppRoutes.activitytrackerdashboard,
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                       ]),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildSectionCards() {
//     final List<Widget> cards = [];
//     for (int i = 0; i < _sections.length; i++) {
//       if (i > 0) cards.add(const SizedBox(height: 12));
//       cards.add(_buildSectionCard(i));
//     }
//     return cards;
//   }

//   Widget _buildSectionCard(int index) {
//     final meta = _sections[index];
//     final enabled = _currentStep >= index;
//     final expanded = _expandedSections[index];
//     final done = _currentStep > index;

//     final Widget sectionChild = _buildSectionChild(index);

//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 300),
//       opacity: enabled ? 1.0 : 0.45,
//       child: IgnorePointer(
//         ignoring: !enabled,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: expanded
//                   ? meta.accent.withOpacity(0.5)
//                   : const Color(0xFFE8EAF0),
//               width: expanded ? 1.5 : 1,
//             ),
//             boxShadow: expanded
//                 ? [
//                     BoxShadow(
//                       color: meta.accent.withOpacity(0.08),
//                       blurRadius: 20,
//                       offset: const Offset(0, 6),
//                     ),
//                   ]
//                 : [
//                     const BoxShadow(
//                       color: Color(0x08000000),
//                       blurRadius: 8,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               InkWell(
//                 onTap: enabled
//                     ? () =>
//                         setState(() => _expandedSections[index] = !expanded)
//                     : null,
//                 borderRadius: BorderRadius.circular(16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(18),
//                   child: Row(
//                     children: [
//                       _StepIndicator(
//                         index: index,
//                         accent: meta.accent,
//                         done: done,
//                         active: expanded,
//                       ),
//                       const SizedBox(width: 14),
//                       Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: meta.accent.withOpacity(0.09),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(meta.icon, color: meta.accent, size: 20),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               meta.title,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF1A1D2E),
//                                 letterSpacing: -0.2,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               done
//                                   ? 'Completed'
//                                   : expanded
//                                       ? 'Fill in the details below'
//                                       : 'Tap to expand',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: done
//                                     ? const Color(0xFF00B894)
//                                     : const Color(0xFF9496A1),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (done)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFE8FAF5),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Text(
//                             'Done',
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF00B894),
//                             ),
//                           ),
//                         ),
//                       const SizedBox(width: 8),
//                       AnimatedRotation(
//                         duration: const Duration(milliseconds: 200),
//                         turns: expanded ? 0.5 : 0,
//                         child: const Icon(
//                           Icons.keyboard_arrow_down_rounded,
//                           color: Color(0xFFB0B3BF),
//                           size: 22,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               AnimatedCrossFade(
//                 duration: const Duration(milliseconds: 250),
//                 crossFadeState: expanded
//                     ? CrossFadeState.showFirst
//                     : CrossFadeState.showSecond,
//                 firstChild: Column(
//                   children: [
//                     Divider(height: 1, color: meta.accent.withOpacity(0.12)),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
//                       child: sectionChild,
//                     ),
//                   ],
//                 ),
//                 secondChild: const SizedBox.shrink(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionChild(int index) {
//     switch (index) {
//       case 0:
//         return ActivityFormSection(
//           vm: widget.vm,
//           onSaved: () => _onSectionSaved(0),
//         );
//       case 1:
//         return AgencyPartnerSection(
//           vm: widget.vm,
//           onSaved: () => _onSectionSaved(1),
//         );
//       case 2:
//         return ExecutionElementSection(
//           vm: widget.vm,
//           onSaved: () => _onSectionSaved(2),
//         );
//       case 3:
//         return AuthorisationDocsSection(onSaved: () => _onSectionSaved(3));
//       case 4:
//         return SupportingDocsSection(onSaved: () => _onSectionSaved(4));
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   // ✅ FIX: back button shown in AppBar leading — only on mobile (no sidebar)
//   Widget _buildAppBar(BuildContext context, {required bool showBackButton}) {
//     return SliverAppBar(
//       expandedHeight: 160,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.white,
//       surfaceTintColor: Colors.transparent,
//       shadowColor: const Color(0x14000000),
//       automaticallyImplyLeading: false,
//       leading: showBackButton
//           ? Padding(
//               padding: const EdgeInsets.all(8),
//               child: Material(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10),
//                 child: InkWell(
//                   onTap: () => context.pop(),
//                   borderRadius: BorderRadius.circular(10),
//                   child: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     size: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             )
//           : null,
//       flexibleSpace: FlexibleSpaceBar(
//         collapseMode: CollapseMode.parallax,
//         background: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
//             ),
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 right: -40,
//                 bottom: -40,
//                 child: Opacity(
//                   opacity: 0.07,
//                   child: Container(
//                     width: 220,
//                     height: 220,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 40,
//                 top: 20,
//                 child: Opacity(
//                   opacity: 0.05,
//                   child: Container(
//                     width: 120,
//                     height: 120,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'ACTIVITY EDITOR',
//                         style: TextStyle(
//                           color: Colors.white60,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 1.8,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Edit Activity',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 26,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SECTION META
// // ─────────────────────────────────────────────
// class _SectionMeta {
//   final String title;
//   final IconData icon;
//   final Color accent;
//   const _SectionMeta({
//     required this.title,
//     required this.icon,
//     required this.accent,
//   });
// }

// // ─────────────────────────────────────────────
// // STEP INDICATOR
// // ─────────────────────────────────────────────
// class _StepIndicator extends StatelessWidget {
//   final int index;
//   final Color accent;
//   final bool done;
//   final bool active;

//   const _StepIndicator({
//     required this.index,
//     required this.accent,
//     required this.done,
//     required this.active,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: 32,
//       height: 32,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: done
//             ? const Color(0xFF00B894)
//             : active
//                 ? accent
//                 : const Color(0xFFF0F1F5),
//         border: Border.all(
//           color: done
//               ? const Color(0xFF00B894)
//               : active
//                   ? accent
//                   : const Color(0xFFDDE0EA),
//           width: 1.5,
//         ),
//       ),
//       child: Center(
//         child: done
//             ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
//             : Text(
//                 '${index + 1}',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: active ? Colors.white : const Color(0xFF9496A1),
//                 ),
//               ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // PROGRESS HEADER
// // ─────────────────────────────────────────────
// class _ProgressHeader extends StatelessWidget {
//   final int currentStep;
//   final int totalSteps;

//   const _ProgressHeader(
//       {required this.currentStep, required this.totalSteps});

//   @override
//   Widget build(BuildContext context) {
//     final pct = (currentStep / totalSteps).clamp(0.0, 1.0);

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE8EAF0)),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x06000000),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Form Progress',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1A1D2E),
//                 ),
//               ),
//               Text(
//                 '$currentStep of $totalSteps completed',
//                 style: const TextStyle(
//                     fontSize: 12, color: Color(0xFF9496A1)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: pct,
//               minHeight: 6,
//               backgroundColor: const Color(0xFFF0F1F5),
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                 Color(0xFF6C63FF),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: List.generate(totalSteps, (i) {
//               final isDone = i < currentStep;
//               final isActive = i == currentStep;
//               return Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         height: 3,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(2),
//                           color: isDone
//                               ? const Color(0xFF6C63FF)
//                               : isActive
//                                   ? const Color(0xFF6C63FF).withOpacity(0.4)
//                                   : const Color(0xFFE8EAF0),
//                         ),
//                       ),
//                     ),
//                     if (i < totalSteps - 1) const SizedBox(width: 4),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // SUBMIT BUTTON
// // ─────────────────────────────────────────────
// class _SubmitButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   const _SubmitButton({required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 54,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
//           ),
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF6C63FF).withOpacity(0.3),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: ElevatedButton.icon(
//           onPressed: onPressed,
//           icon: const Icon(Icons.cloud_done_outlined, size: 20),
//           label: const Text(
//             'Update & Save Details',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.2,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:activity_tracker/utils/routes/app_routes.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'activity_sections/activity_form_section.dart';
// import 'activity_sections/agency_partner_section.dart';
// import 'activity_sections/execution_element_section.dart';
// import 'activity_sections/authorisation_docs_section.dart';
// import 'activity_sections/supporting_docs_section.dart';

// class EditActivityScreen extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   const EditActivityScreen({super.key, required this.vm});

//   @override
//   State<EditActivityScreen> createState() => _EditActivityScreenState();
// }

// class _EditActivityScreenState extends State<EditActivityScreen>
//     with TickerProviderStateMixin {
//   int _currentStep = 0;
//   late List<bool> _expandedSections;
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;

//   static const List<_SectionMeta> _sections = [
//     _SectionMeta(
//       title: 'Activity Details',
//       icon: Icons.edit_note_outlined,
//       accent: Color(0xFF6C63FF),
//     ),
//     _SectionMeta(
//       title: 'Agency Partner Details',
//       icon: Icons.handshake_outlined,
//       accent: Color(0xFF00B894),
//     ),
//     _SectionMeta(
//       title: 'Execution Element Details',
//       icon: Icons.settings_input_component_outlined,
//       accent: Color(0xFF0984E3),
//     ),
//     _SectionMeta(
//       title: 'Authorisation Documents',
//       icon: Icons.verified_user_outlined,
//       accent: Color(0xFFE17055),
//     ),
//     _SectionMeta(
//       title: 'Supporting Documents',
//       icon: Icons.folder_open_outlined,
//       accent: Color(0xFFFDAB23),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _expandedSections = List.generate(_sections.length, (i) => i == 0);

//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeOut,
//     );
//     _fadeController.forward();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       widget.vm.getActivityDropDownDetails();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   void _onSectionSaved(int index) {
//     setState(() {
//       _expandedSections[index] = false;
//       if (_currentStep < index + 1) _currentStep = index + 1;
//       if (index + 1 < _sections.length) _expandedSections[index + 1] = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width >= 900;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FC),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Stack(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (isWide)
//                   _WebSidebar(sections: _sections, currentStep: _currentStep),

//                 Expanded(
//                   child: CustomScrollView(
//                     slivers: [
//                       _buildAppBar(context),

//                       SliverPadding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: isWide ? 40 : 16,
//                           vertical: 24,
//                         ),
//                         sliver: SliverList(
//                           delegate: SliverChildListDelegate([
//                             _ProgressHeader(
//                               currentStep: _currentStep,
//                               totalSteps: _sections.length,
//                             ),
//                             const SizedBox(height: 24),
//                             ..._buildSectionCards(),
//                             const SizedBox(height: 32),
//                             _SubmitButton(
//                               onPressed: () => context.push(
//                                 AppRoutes.activitytrackerdashboard,
//                               ),
//                             ),
//                             const SizedBox(height: 40),
//                           ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             Positioned(
//               top: 41,
//               left: 25,
//               child: SafeArea(child: _BackButtonWidget()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildSectionCards() {
//     final List<Widget> cards = [];
//     for (int i = 0; i < _sections.length; i++) {
//       if (i > 0) cards.add(const SizedBox(height: 12));
//       cards.add(_buildSectionCard(i));
//     }
//     return cards;
//   }

//   Widget _buildSectionCard(int index) {
//     final meta = _sections[index];
//     final enabled = _currentStep >= index;
//     final expanded = _expandedSections[index];
//     final done = _currentStep > index;

//     final Widget sectionChild = _buildSectionChild(index);

//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 300),
//       opacity: enabled ? 1.0 : 0.45,
//       child: IgnorePointer(
//         ignoring: !enabled,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: expanded
//                   ? meta.accent.withOpacity(0.5)
//                   : const Color(0xFFE8EAF0),
//               width: expanded ? 1.5 : 1,
//             ),
//             boxShadow: expanded
//                 ? [
//                     BoxShadow(
//                       color: meta.accent.withOpacity(0.08),
//                       blurRadius: 20,
//                       offset: const Offset(0, 6),
//                     ),
//                   ]
//                 : [
//                     const BoxShadow(
//                       color: Color(0x08000000),
//                       blurRadius: 8,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               InkWell(
//                 onTap: enabled
//                     ? () => setState(() => _expandedSections[index] = !expanded)
//                     : null,
//                 borderRadius: BorderRadius.circular(16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(18),
//                   child: Row(
//                     children: [
//                       _StepIndicator(
//                         index: index,
//                         accent: meta.accent,
//                         done: done,
//                         active: expanded,
//                       ),
//                       const SizedBox(width: 14),
//                       // Icon
//                       Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: meta.accent.withOpacity(0.09),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(meta.icon, color: meta.accent, size: 20),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               meta.title,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF1A1D2E),
//                                 letterSpacing: -0.2,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               done
//                                   ? 'Completed'
//                                   : expanded
//                                   ? 'Fill in the details below'
//                                   : 'Tap to expand',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: done
//                                     ? const Color(0xFF00B894)
//                                     : const Color(0xFF9496A1),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (done)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFE8FAF5),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const Text(
//                             'Done',
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF00B894),
//                             ),
//                           ),
//                         ),
//                       const SizedBox(width: 8),
//                       AnimatedRotation(
//                         duration: const Duration(milliseconds: 200),
//                         turns: expanded ? 0.5 : 0,
//                         child: const Icon(
//                           Icons.keyboard_arrow_down_rounded,
//                           color: Color(0xFFB0B3BF),
//                           size: 22,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               AnimatedCrossFade(
//                 duration: const Duration(milliseconds: 250),
//                 crossFadeState: expanded
//                     ? CrossFadeState.showFirst
//                     : CrossFadeState.showSecond,
//                 firstChild: Column(
//                   children: [
//                     Divider(height: 1, color: meta.accent.withOpacity(0.12)),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
//                       child: sectionChild,
//                     ),
//                   ],
//                 ),
//                 secondChild: const SizedBox.shrink(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionChild(int index) {
//     switch (index) {
//       case 0:
//         return ActivityFormSection(
//           vm: widget.vm,
//           onSaved: () => _onSectionSaved(0),
//         );
//       case 1:
//         return AgencyPartnerSection(
//           vm: widget.vm,
//           onSaved: () => _onSectionSaved(1),
//         );
//       case 2:
//         return ExecutionElementSection(
//           vm: widget.vm,
//           onSaved: () => _onSectionSaved(2),
//         );
//       case 3:
//         return AuthorisationDocsSection(onSaved: () => _onSectionSaved(3));
//       case 4:
//         return SupportingDocsSection(onSaved: () => _onSectionSaved(4));
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 160,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.white,
//       surfaceTintColor: Colors.transparent,
//       shadowColor: const Color(0x14000000),
//       // leading: IconButton(
//       //   icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
//       //   color: const Color(0xFF1A1D2E),
//       //   onPressed: () => context.pop(),
//       // ),
//       flexibleSpace: FlexibleSpaceBar(
//         collapseMode: CollapseMode.parallax,
//         background: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
//             ),
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 right: -40,
//                 bottom: -40,
//                 child: Opacity(
//                   opacity: 0.07,
//                   child: Container(
//                     width: 220,
//                     height: 220,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 40,
//                 top: 20,
//                 child: Opacity(
//                   opacity: 0.05,
//                   child: Container(
//                     width: 120,
//                     height: 120,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'ACTIVITY EDITOR',
//                         style: TextStyle(
//                           color: Colors.white60,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 1.8,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'Edit Activity',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 26,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SectionMeta {
//   final String title;
//   final IconData icon;
//   final Color accent;
//   const _SectionMeta({
//     required this.title,
//     required this.icon,
//     required this.accent,
//   });
// }

// class _StepIndicator extends StatelessWidget {
//   final int index;
//   final Color accent;
//   final bool done;
//   final bool active;

//   const _StepIndicator({
//     required this.index,
//     required this.accent,
//     required this.done,
//     required this.active,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: 32,
//       height: 32,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: done
//             ? const Color(0xFF00B894)
//             : active
//             ? accent
//             : const Color(0xFFF0F1F5),
//         border: Border.all(
//           color: done
//               ? const Color(0xFF00B894)
//               : active
//               ? accent
//               : const Color(0xFFDDE0EA),
//           width: 1.5,
//         ),
//       ),
//       child: Center(
//         child: done
//             ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
//             : Text(
//                 '${index + 1}',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: active ? Colors.white : const Color(0xFF9496A1),
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class _ProgressHeader extends StatelessWidget {
//   final int currentStep;
//   final int totalSteps;

//   const _ProgressHeader({required this.currentStep, required this.totalSteps});

//   @override
//   Widget build(BuildContext context) {
//     final pct = (currentStep / totalSteps).clamp(0.0, 1.0);

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE8EAF0)),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x06000000),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Form Progress',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1A1D2E),
//                 ),
//               ),
//               Text(
//                 '$currentStep of $totalSteps completed',
//                 style: const TextStyle(fontSize: 12, color: Color(0xFF9496A1)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: pct,
//               minHeight: 6,
//               backgroundColor: const Color(0xFFF0F1F5),
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                 Color(0xFF6C63FF),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: List.generate(totalSteps, (i) {
//               final isDone = i < currentStep;
//               final isActive = i == currentStep;
//               return Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         height: 3,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(2),
//                           color: isDone
//                               ? const Color(0xFF6C63FF)
//                               : isActive
//                               ? const Color(0xFF6C63FF).withOpacity(0.4)
//                               : const Color(0xFFE8EAF0),
//                         ),
//                       ),
//                     ),
//                     if (i < totalSteps - 1) const SizedBox(width: 4),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _WebSidebar extends StatelessWidget {
//   final List<_SectionMeta> sections;
//   final int currentStep;

//   const _WebSidebar({required this.sections, required this.currentStep});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 260,
//       height: double.infinity,
//       color: const Color(0xFFFFFFFF),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             // height: 180,
//             padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.bolt, color: Colors.white, size: 22),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Activity Tracker',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: -0.3,
//                     height: 1,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'Edit Activity',
//                   style: TextStyle(color: Colors.white60, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(left: 8, bottom: 10),
//                   child: Text(
//                     'SECTIONS',
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFFB0B3BF),
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ),
//                 ...List.generate(sections.length, (i) {
//                   final s = sections[i];
//                   final isDone = i < currentStep;
//                   final isActive = i == currentStep;

//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 4),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isActive
//                             ? s.accent.withOpacity(0.08)
//                             : Colors.transparent,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 28,
//                             height: 28,
//                             decoration: BoxDecoration(
//                               color: isDone
//                                   ? const Color(0xFFE8FAF5)
//                                   : isActive
//                                   ? s.accent.withOpacity(0.12)
//                                   : const Color(0xFFF0F1F5),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: isDone
//                                 ? const Icon(
//                                     Icons.check_rounded,
//                                     size: 14,
//                                     color: Color(0xFF00B894),
//                                   )
//                                 : Icon(
//                                     s.icon,
//                                     size: 14,
//                                     color: isActive
//                                         ? s.accent
//                                         : const Color(0xFFB0B3BF),
//                                   ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               s.title,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: isActive
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                                 color: isActive
//                                     ? s.accent
//                                     : isDone
//                                     ? const Color(0xFF1A1D2E)
//                                     : const Color(0xFF9496A1),
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           if (isDone)
//                             const Icon(
//                               Icons.check_circle_rounded,
//                               size: 14,
//                               color: Color(0xFF00B894),
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ),
//           const Spacer(),
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF7F8FC),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFE8EAF0)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6C63FF).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.info_outline_rounded,
//                     color: Color(0xFF6C63FF),
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Expanded(
//                   child: Text(
//                     'Complete all sections before submitting.',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Color(0xFF9496A1),
//                       height: 1.4,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SubmitButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   const _SubmitButton({required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 54,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF6C63FF), Color(0xFF00B894)],
//           ),
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF6C63FF).withOpacity(0.3),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: ElevatedButton.icon(
//           onPressed: onPressed,
//           icon: const Icon(Icons.cloud_done_outlined, size: 20),
//           label: const Text(
//             'Update & Save Details',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.2,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _BackButtonWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       elevation: 6,
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         onTap: () => context.pop(),
//         borderRadius: BorderRadius.circular(12),
//         child: const Padding(
//           padding: EdgeInsets.all(10),
//           child: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 18,
//             color: Color(0xFF1A1D2E),
//           ),
//         ),
//       ),
//     );
//   }
// }
