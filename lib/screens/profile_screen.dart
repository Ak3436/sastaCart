import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/edge_to_edge.dart';
import '../viewmodel/profile_view_model.dart';
import '../widgets/home_shimmer.dart';

/// =========================
/// PROFILE SCREEN
/// =========================
/// Displays the full user profile fetched from DummyJSON.
/// Follows the attached design reference:
///   • Gradient header with avatar, name, email & address
///   • "Personal Information" card with a 2-column info grid
///   • "Company Details" card with logo placeholder and job info
///   • Stats row (Years of Experience, Projects, Awards, Feedback)
///   • Logout button
///
/// State management: [ProfileViewModel] via Provider / ChangeNotifier.
class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // ── Lifecycle ────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    /// =========================
    /// TRIGGER API CALL
    /// =========================
    /// microtask ensures the widget tree is fully mounted before
    /// we touch the Provider (avoids "called during build" errors).
    Future.microtask(() {
      context.read<ProfileViewModel>().getUserProfile(1);
    });
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (_, vm, __) {

        /// =========================
        /// LOADING STATE → SHIMMER
        /// =========================
        if (vm.isLoading) return const HomeShimmer();

        /// =========================
        /// ERROR STATE
        /// =========================
        if (vm.errorMessage.isNotEmpty) {
          return _buildErrorState(vm.errorMessage, vm);
        }

        /// =========================
        /// NULL GUARD
        /// =========================
        if (vm.user == null) return const SizedBox();

        final user = vm.user!;

        return EdgeToEdgeBody(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                // ── (1) GRADIENT HEADER ──────────────────────────
                _buildHeader(user, vm),

                const SizedBox(height: 20),

                // ── (2) PERSONAL INFORMATION CARD ────────────────
                _buildSectionCard(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  child: _buildPersonalInfoGrid(user, vm),
                ),

                const SizedBox(height: 16),

                // ── (3) ADDRESS CARD ─────────────────────────────
                _buildSectionCard(
                  icon: Icons.location_on_outlined,
                  title: 'Address Details',
                  child: _buildAddressGrid(user),
                ),

                const SizedBox(height: 16),

                // ── (4) COMPANY DETAILS CARD ─────────────────────
                _buildSectionCard(
                  icon: Icons.business_center_outlined,
                  title: 'Company Details',
                  child: _buildCompanyDetails(user),
                ),

                const SizedBox(height: 16),

                // ── (5) STATS ROW ────────────────────────────────
                _buildStatsRow(),

                const SizedBox(height: 24),

                // ── (6) LOGOUT BUTTON ────────────────────────────
                _buildLogoutButton(),

                const SizedBox(height: 36),
              ],
            ),
          ),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════════
  // HEADER
  // ════════════════════════════════════════════════════════════════

  /// Blue gradient banner containing:
  ///   • Rounded avatar with online indicator
  ///   • Verified name badge
  ///   • Email and address lines
  Widget _buildHeader(user, ProfileViewModel vm) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1565C0), Color(0xff42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [

              // ── App bar row ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _headerIconButton(Icons.person),
                ],
              ),

              const SizedBox(height: 28),

              // ── Avatar ───────────────────────────────────────
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  /// White ring + gradient ring + network image
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.45),
                          blurRadius: 18,
                          spreadRadius: 4,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(user.image),
                    ),
                  ),

                  /// Green online dot
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xff4CAF50),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Name + verified badge ────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.verified, color: Color(0xff64B5F6), size: 24),
                ],
              ),

              const SizedBox(height: 8),

              // ── Email ────────────────────────────────────────
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 6),

              // ── Address one-liner ────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${user.address.address}, ${user.address.city}, '
                          '${user.address.country}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Small frosted-glass icon button used in the header bar.
  Widget _headerIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // SECTION CARD WRAPPER
  // ════════════════════════════════════════════════════════════════

  /// Reusable white card with a header icon + title and a [child] body.
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Card header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xff1565C0), size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 20),
          ),

          // ── Card body ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // PERSONAL INFORMATION GRID
  // ════════════════════════════════════════════════════════════════

  /// 2-column grid of labelled info tiles (matches reference design).
  Widget _buildPersonalInfoGrid(user, ProfileViewModel vm) {
    return Column(
      children: [
        _infoRow(
          left: _infoCell(
            icon: Icons.calendar_today,
            iconColor: const Color(0xff5C6BC0),
            iconBg: const Color(0xffEDE7F6),
            label: 'Birthdate',
            value: vm.formattedBirthDate,
          ),
          right: _infoCell(
            icon: Icons.phone,
            iconColor: const Color(0xff43A047),
            iconBg: const Color(0xffE8F5E9),
            label: 'Phone Number',
            value: user.phone,
          ),
        ),
        _rowDivider(),
        _infoRow(
          left: _infoCell(
            icon: Icons.cake_outlined,
            iconColor: const Color(0xffF57C00),
            iconBg: const Color(0xffFFF3E0),
            label: 'Age',
            value: '${user.age} Years',
          ),
          right: _infoCell(
            icon: Icons.email_outlined,
            iconColor: const Color(0xff8E24AA),
            iconBg: const Color(0xffF3E5F5),
            label: 'Email Address',
            value: user.email,
          ),
        ),
        _rowDivider(),
        _infoRow(
          left: _infoCell(
            icon: Icons.wc_outlined,
            iconColor: const Color(0xff039BE5),
            iconBg: const Color(0xffE1F5FE),
            label: 'Gender',
            value: _capitalize(user.gender),
          ),
          right: _infoCell(
            icon: Icons.public,
            iconColor: const Color(0xff00897B),
            iconBg: const Color(0xffE0F2F1),
            label: 'Nationality',
            value: user.address.country,
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  // ADDRESS GRID
  // ════════════════════════════════════════════════════════════════

  Widget _buildAddressGrid(user) {
    final addr = user.address;
    return Column(
      children: [
        _infoRow(
          left: _infoCell(
            icon: Icons.home_outlined,
            iconColor: const Color(0xffe53935),
            iconBg: const Color(0xffFFEBEE),
            label: 'Street',
            value: addr.address,
          ),
          right: _infoCell(
            icon: Icons.location_city_outlined,
            iconColor: const Color(0xff1E88E5),
            iconBg: const Color(0xffE3F2FD),
            label: 'City',
            value: addr.city,
          ),
        ),
        _rowDivider(),
        _infoRow(
          left: _infoCell(
            icon: Icons.map_outlined,
            iconColor: const Color(0xff43A047),
            iconBg: const Color(0xffE8F5E9),
            label: 'State',
            value: addr.state,
          ),
          right: _infoCell(
            icon: Icons.markunread_mailbox_outlined,
            iconColor: const Color(0xffF57C00),
            iconBg: const Color(0xffFFF3E0),
            label: 'Postal Code',
            value: addr.postalCode,
          ),
        ),
        _rowDivider(),
        _infoCell(
          icon: Icons.flag_outlined,
          iconColor: const Color(0xff5C6BC0),
          iconBg: const Color(0xffEDE7F6),
          label: 'Country',
          value: addr.country,
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  // COMPANY DETAILS
  // ════════════════════════════════════════════════════════════════

  /// Matches the reference: company logo placeholder on the left,
  /// three labelled rows (Name, Department, Title) on the right,
  /// plus Employee ID, Work Email and Office Address.
  Widget _buildCompanyDetails(user) {
    final company = user.company;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Logo + primary info side-by-side ─────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Company logo placeholder (gradient diamond)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xff1565C0), Color(0xff42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(width: 16),

            /// Name, Department, Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _companyInfoRow(
                    icon: Icons.business_outlined,
                    label: 'Company Name',
                    value: company.name,
                  ),
                  const SizedBox(height: 10),
                  _companyInfoRow(
                    icon: Icons.groups_outlined,
                    label: 'Department',
                    value: company.department,
                  ),
                  const SizedBox(height: 10),
                  _companyInfoRow(
                    icon: Icons.person_outline,
                    label: 'Job Title',
                    value: company.title,
                  ),
                ],
              ),
            ),
          ],
        ),

        const Divider(height: 24),

        // ── Office address ───────────────────────────────────
        _companyInfoRow(
          icon: Icons.location_on_outlined,
          label: 'Office Address',
          value: company.address.formatted,
        ),
      ],
    );
  }

  /// Single labelled row inside the Company card.
  Widget _companyInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xff1565C0)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  // STATS ROW
  // ════════════════════════════════════════════════════════════════

  /// Four stat chips in a row (Years of Experience, Projects,
  /// Awards, Positive Feedback) matching the bottom of the reference.
  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statChip(
            icon: Icons.work_outline,
            iconColor: const Color(0xff5C6BC0),
            iconBg: const Color(0xffEDE7F6),
            value: '4+',
            label: 'Years of\nExperience',
          ),
          _statChip(
            icon: Icons.people_outline,
            iconColor: const Color(0xff43A047),
            iconBg: const Color(0xffE8F5E9),
            value: '32',
            label: 'Projects\nCompleted',
          ),
          _statChip(
            icon: Icons.emoji_events_outlined,
            iconColor: const Color(0xffF57C00),
            iconBg: const Color(0xffFFF3E0),
            value: '8',
            label: 'Awards\nReceived',
          ),
          _statChip(
            icon: Icons.star_outline,
            iconColor: const Color(0xffe91e63),
            iconBg: const Color(0xffFCE4EC),
            value: '98%',
            label: 'Positive\nFeedback',
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  // LOGOUT BUTTON
  // ════════════════════════════════════════════════════════════════

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: widget.onLogout,
          icon: const Icon(Icons.logout, size: 22),
          label: const Text(
            'Logout',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // ERROR STATE
  // ════════════════════════════════════════════════════════════════

  Widget _buildErrorState(String message, ProfileViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            /// Retry button – calls [getUserProfile] again.
            ElevatedButton.icon(
              onPressed: () => vm.getUserProfile(1),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ════════════════════════════════════════════════════════════════

  /// A row that places two [_infoCell]s side by side.
  Widget _infoRow({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  /// A single labelled info tile with a coloured icon chip.
  Widget _infoCell({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Light horizontal divider used between grid rows.
  Widget _rowDivider() => const Divider(height: 1, color: Color(0xffF0F0F0));

  /// Capitalises the first letter of a string (e.g. "male" → "Male").
  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
