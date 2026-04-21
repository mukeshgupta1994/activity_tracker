// import 'package:activity_tracker/data/remote/response/status.dart';
// import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'activity_sections/activity_form_section.dart';
// import 'activity_sections/agency_partner_section.dart';
// import 'activity_sections/execution_element_section.dart';
// import 'activity_sections/authorisation_docs_section.dart';
// import 'activity_sections/supporting_docs_section.dart';
// import 'activity_sections/download_reports_section.dart';

import 'package:activity_tracker/components/components.dart';
import 'package:activity_tracker/viewmodel/activity_dash_view_model.dart';
import 'package:flutter/material.dart';
import 'activity_sections/activity_form_section.dart';
import 'activity_sections/agency_partner_section.dart';
import 'activity_sections/execution_element_section.dart';
import 'activity_sections/authorisation_docs_section.dart';
import 'activity_sections/supporting_docs_section.dart';
import 'activity_sections/download_reports_section.dart';

class EditActivityScreen extends StatefulWidget {
  final ActivityDashViewModel vm;
  const EditActivityScreen({super.key, required this.vm});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  late List<bool> _expandedSections;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
    _expandedSections = [true, false, false, false, false, false];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.vm.getActivityDropDownDetails();
      // don't auto-submit on open
      // widget.vm.submitActivity();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Activity Details",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableSection(
                      index: 0,
                      title: 'Activity Details',
                      icon: Icons.edit_note_outlined,
                      child: ActivityFormSection(
                        vm: widget.vm,
                        onSaved: () {
                          // advance to next section after save
                          setState(() {
                            final index = 0;
                            _expandedSections[index] = false;
                            _currentStep = (_currentStep < index + 1)
                                ? index + 1
                                : _currentStep;
                            if (index + 1 < _expandedSections.length)
                              _expandedSections[index + 1] = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildExpandableSection(
                      index: 1,
                      title: 'Agency Partner Details',
                      icon: Icons.handshake_outlined,
                      child: AgencyPartnerSection(
                        vm: widget.vm,
                        onSaved: () {
                          setState(() {
                            final index = 1;
                            _expandedSections[index] = false;
                            _currentStep = (_currentStep < index + 1)
                                ? index + 1
                                : _currentStep;
                            if (index + 1 < _expandedSections.length)
                              _expandedSections[index + 1] = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableSection(
                      index: 2,
                      title: 'Execution Element Details',
                      icon: Icons.settings_input_component_outlined,
                      child: ExecutionElementSection(
                        onSaved: () {
                          setState(() {
                            final index = 2;
                            _expandedSections[index] = false;
                            _currentStep = (_currentStep < index + 1)
                                ? index + 1
                                : _currentStep;
                            if (index + 1 < _expandedSections.length)
                              _expandedSections[index + 1] = true;
                          });
                        },
                        vm: widget.vm,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableSection(
                      index: 3,
                      title: 'Authorisation Documents Details',
                      icon: Icons.verified_user_outlined,
                      child: AuthorisationDocsSection(
                        onSaved: () {
                          setState(() {
                            final index = 3;
                            _expandedSections[index] = false;
                            _currentStep = (_currentStep < index + 1)
                                ? index + 1
                                : _currentStep;
                            if (index + 1 < _expandedSections.length)
                              _expandedSections[index + 1] = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableSection(
                      index: 4,
                      title: 'Supporting Documents Details',
                      icon: Icons.folder_open_outlined,
                      child: SupportingDocsSection(
                        onSaved: () {
                          setState(() {
                            final index = 4;
                            _expandedSections[index] = false;
                            _currentStep = (_currentStep < index + 1)
                                ? index + 1
                                : _currentStep;
                            if (index + 1 < _expandedSections.length)
                              _expandedSections[index + 1] = true;
                          });
                        },
                      ),
                    ),
                    // const SizedBox(height: 16),
                    // _buildExpandableSection(
                    //   index: 5,
                    //   title: 'Download Reports',
                    //   icon: Icons.file_download_outlined,
                    //   child: DownloadReportsSection(
                    //     onSaved: () {
                    //       // last section: finish and pop
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: CustomButton(
                        text: "Update & Save Details",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required int index,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final enabled = _currentStep >= index;
    final expanded = _expandedSections[index];

    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title area: make clickable to toggle expansion. Use Expanded
                  // + ellipsis to avoid overflow on small screens.
                  Expanded(
                    child: InkWell(
                      onTap: enabled
                          ? () {
                              setState(() {
                                _expandedSections[index] =
                                    !_expandedSections[index];
                              });
                            }
                          : null,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: enabled
                        ? () {
                            setState(() {
                              _expandedSections[index] =
                                  !_expandedSections[index];
                            });
                          }
                        : null,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 16),
                child,
                const SizedBox(height: 0),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.edit_note, size: 200, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Activity Editor",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      "Edit Activity",
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: Colors.white, fontSize: 28),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class EditActivityScreen extends StatefulWidget {
//   final ActivityDashViewModel vm;
//   const EditActivityScreen({super.key, required this.vm});

//   @override
//   State<EditActivityScreen> createState() => _EditActivityScreenState();
// }

// class _EditActivityScreenState extends State<EditActivityScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;
//   @override
//   void initState() {
//     super.initState();

//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeIn,
//     );
//     _fadeController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   // Section state and helpers moved into individual section widgets

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: CustomScrollView(
//           slivers: [
//             _buildAppBar(context),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Activity Details",
//                       style: Theme.of(context).textTheme.headlineLarge,
//                     ),
//                     const SizedBox(height: 16),
//                     ActivityFormSection(vm: widget.vm),
//                     const SizedBox(height: 24),
//                     _SectionCard(
//                       title: 'Agency Partner Details',
//                       icon: Icons.handshake_outlined,
//                       child: const AgencyPartnerSection(),
//                     ),
//                     const SizedBox(height: 16),
//                     _SectionCard(
//                       title: 'Execution Element Details',
//                       icon: Icons.settings_input_component_outlined,
//                       child: const ExecutionElementSection(),
//                     ),
//                     const SizedBox(height: 16),
//                     _SectionCard(
//                       title: 'Authorisation Documents Details',
//                       icon: Icons.verified_user_outlined,
//                       child: const AuthorisationDocsSection(),
//                     ),
//                     const SizedBox(height: 16),
//                     _SectionCard(
//                       title: 'Supporting Documents Details',
//                       icon: Icons.folder_open_outlined,
//                       child: const SupportingDocsSection(),
//                     ),
//                     const SizedBox(height: 16),
//                     _SectionCard(
//                       title: 'Download Reports',
//                       icon: Icons.file_download_outlined,
//                       child: const DownloadReportsSection(),
//                     ),
//                     const SizedBox(height: 32),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Update & Save Details",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _SectionCard({
//     required String title,
//     required IconData icon,
//     required Widget child,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Theme.of(
//                     context,
//                   ).colorScheme.secondary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: Theme.of(context).colorScheme.secondary,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleLarge?.copyWith(fontSize: 16),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 180,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Theme.of(context).primaryColor,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Theme.of(context).primaryColor,
//                 Theme.of(context).colorScheme.secondary,
//               ],
//             ),
//           ),
//           child: Stack(
//             children: [
//               const Positioned(
//                 right: -20,
//                 top: -20,
//                 child: Opacity(
//                   opacity: 0.1,
//                   child: Icon(Icons.edit_note, size: 200, color: Colors.white),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Activity Editor",
//                       style: TextStyle(color: Colors.white70, fontSize: 14),
//                     ),
//                     Text(
//                       "Edit Activity",
//                       style: Theme.of(context).textTheme.headlineLarge
//                           ?.copyWith(color: Colors.white, fontSize: 28),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
