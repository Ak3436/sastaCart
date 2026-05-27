import 'package:demo_flutter/screens/cart_screen.dart';
import 'package:demo_flutter/screens/category_screen.dart';
import 'package:demo_flutter/screens/category_detail_screen.dart';
import 'package:demo_flutter/screens/profile_screen.dart';
import 'package:demo_flutter/screens/product_list_screen.dart';
import 'package:demo_flutter/screens/search_screen.dart';
import 'package:demo_flutter/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../session/session_manager.dart';
import '../utils/app_colors.dart';
import '../utils/edge_to_edge.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
import '../viewmodel/home_view_model.dart';
import '../widgets/cart_badge.dart';
import '../widgets/home_shimmer.dart';
import '../widgets/product_details_dialog.dart';
import 'login_screen.dart';

// ============================================================
// MODERN BOTTOM NAVIGATION BAR — DATA MODEL
// Holds icon, active icon, and label for each tab.
// ============================================================
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ============================================================
// ANIMATED BOTTOM NAVIGATION BAR WIDGET
// A fully custom, stateless widget that renders the nav bar.
// Accepts [currentIndex], [onTap], and optional [cartCount].
// All animation is driven by AnimatedContainer / AnimatedScale
// so no extra AnimationController is needed.
// ============================================================
class ModernBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount; // badge count — 0 means no badge

  const ModernBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  // ── Tab definitions ────────────────────────────────────────
  static const List<_NavItem> _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',            // index 0
    ),
    _NavItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'Categories',      // index 1
    ),
    _NavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      label: 'Cart',            // index 2
    ),
    // _NavItem(
    //   icon: Icons.favorite_border_rounded,
    //   activeIcon: Icons.favorite_rounded,
    //   label: 'Wishlist',        // index 3
    // ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',         // index 4
    ),
  ];

  // ── Brand colour used for the active pill ──────────────────
  static const Color _activeColor = Color(0xFF1565C0); // rich blue
  static const Color _bgColor = Colors.white;
  static const Color _inactiveColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    // Respect the system bottom inset (home indicator on iPhone, etc.)
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      // ── Rounded top corners + drop shadow ─────────────────
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      // Height = 64 px nav area + system bottom inset
      height: 64 + bottomInset,
      padding: EdgeInsets.only(
        bottom: bottomInset,
        left: 8,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final isActive = index == currentIndex;
          final item = _items[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                height: 64,
                // ── ClipRect prevents the pill from ever painting
                //    outside this tab's Expanded slot ──────────────
                child: ClipRect(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Pill indicator + icon ────────────────────
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeInOut,
                        // ── Max width = full slot width so it never
                        //    overflows on narrow phones ───────────────
                        constraints: const BoxConstraints(maxWidth: double.infinity),
                        padding: EdgeInsets.symmetric(
                          horizontal: isActive ? 10 : 0,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? _activeColor.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          // ── min so the pill hugs its content ────
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ── Cart tab (index 2): badge overlay ──
                            if (index == 2)
                              _CartIconWithBadge(
                                isActive: isActive,
                                cartCount: cartCount,
                                activeColor: _activeColor,
                                inactiveColor: _inactiveColor,
                              )
                            else
                            // ── Animated icon scale ──────────────
                              AnimatedScale(
                                scale: isActive ? 1.10 : 1.0,
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeInOut,
                                child: Icon(
                                  isActive ? item.activeIcon : item.icon,
                                  color:
                                  isActive ? _activeColor : _inactiveColor,
                                  size: 22,
                                ),
                              ),
                            // ── Label slides in; Flexible + overflow
                            //    prevents it from causing overflow ────
                            AnimatedSize(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeInOut,
                              child: isActive
                                  ? Flexible(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 5),
                                  child: Text(
                                    item.label,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: _activeColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      // ── Static label below inactive tabs ──────────
                      if (!isActive) ...[
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: _inactiveColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// CART ICON WITH BADGE
// Overlays a red dot badge on the cart icon when cartCount > 0.
// ============================================================
class _CartIconWithBadge extends StatelessWidget {
  final bool isActive;
  final int cartCount;
  final Color activeColor;
  final Color inactiveColor;

  const _CartIconWithBadge({
    required this.isActive,
    required this.cartCount,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedScale(
          scale: isActive ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: Icon(
            isActive ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
            color: isActive ? activeColor : inactiveColor,
            size: 24,
          ),
        ),
        // Badge — only shown when cartCount > 0
        if (cartCount > 0)
          Positioned(
            top: -5,
            right: -6,
            child: Container(
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              child: Text(
                cartCount > 99 ? '99+' : '$cartCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// =========================
  /// USER DATA
  /// =========================
  Map<String, dynamic>? userData;

  /// =========================
  /// BOTTOM NAVIGATION INDEX
  /// =========================
  int currentIndex = 0;

  /// =========================
  /// DOUBLE BACK PRESS
  /// =========================
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    loadUserData();

    /// LOAD APIs
    Future.microtask(() {
      context.read<HomeViewModel>().loadHomeData();
    });
  }

  /// =========================
  /// LOAD USER DATA
  /// =========================
  Future<void> loadUserData() async {
    final data = await SessionManager.getUserData();

    setState(() {
      userData = data;
    });
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Future<void> logoutUser() async {
    await SessionManager.logout();

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (_) => const LoginScreen()),

          (route) => false,
    );
  }

  /// =========================
  /// BACK PRESS HANDLE
  /// =========================
  Future<bool> onWillPop() async {
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
      });

      return false;
    }

    final now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Press back again to exit")));

      return false;
    }

    return true;
  }

  /// =========================
  /// HOME SCREEN UI
  /// =========================
  Widget buildHomeScreen() {
    final topInset = MediaQuery.viewPaddingOf(context).top;

    return Consumer<HomeViewModel>(
      builder: (_, vm, child) {
        /// =========================
        /// LOADER
        /// =========================
        if (vm.isLoading) {
          return const HomeShimmer();
        }

        /// =========================
        /// ERROR
        /// =========================
        if (vm.errorMessage.isNotEmpty) {
          return Center(child: Text(vm.errorMessage));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ====================================
              /// TOP HEADER SECTION
              /// ====================================
              Container(
                height: 170 + topInset,

                width: double.infinity,

                padding: EdgeInsets.only(
                  top: topInset + 16,
                  left: 20,
                  right: 20,
                ),

                decoration: const BoxDecoration(
                  color: Colors.blue,

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),

                    bottomRight: Radius.circular(25),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// =========================
                    /// APP NAME + CART ICON
                    /// =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/sastalogo.png",
                              height: 50,
                              width: 50,
                            ),

                            const SizedBox(width: 10),

                            const Text(
                              AppStrings.appName,

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: 28,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        InkWell(
                          borderRadius: BorderRadius.circular(50),

                          onTap: () {
                            setState(() {
                              currentIndex = 2;
                            });
                          },

                          child: Container(
                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),

                              shape: BoxShape.circle,
                            ),

                            /// Cart count badge listens to CartViewModel and
                            /// refreshes whenever cart items are added/removed.
                            child: const CartBadge(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    /// =========================
                    /// SEARCH BAR
                    /// =========================
                    InkWell(
                      borderRadius: BorderRadius.circular(15),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },

                      child: Container(
                        height: 55,

                        padding: const EdgeInsets.symmetric(horizontal: 15),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),

                            const SizedBox(width: 10),

                            const Text(
                              "Search any Products",

                              style: TextStyle(
                                color: Colors.grey,

                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ====================================
              /// CATEGORY SECTION
              /// ====================================
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),

                child: Text(
                  AppStrings.categories,
                  style: AppTextStyles.subHeading,
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: vm.categories.length,

                  itemBuilder: (context, index) {
                    final category = vm.categories[index];

                    return GestureDetector(
                      onTap: () {
                        debugPrint(category.name);

                        debugPrint(category.slug);

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => CategoryDetailScreen(
                              name: category.name,
                              slug: category.slug,
                              url: category.url,
                            ),
                          ),
                        );
                      },

                      child: Container(
                        width: 90,

                        margin: const EdgeInsets.only(left: 12),

                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 32,

                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),

                              child: const Icon(
                                Icons.category,
                                size: 30,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              category.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// ====================================
              /// PRODUCT TITLE
              /// ====================================
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      AppStrings.Products,
                      style: AppTextStyles.subHeading,
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                ProductListScreen(products: vm.products),
                          ),
                        );
                      },

                      child: const Text("More"),
                    ),
                  ],
                ),
              ),

              /// ====================================
              /// FIRST 3 PRODUCTS
              /// ====================================
              ListView.builder(
                padding: EdgeInsets.zero,

                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: vm.products.length > 3 ? 3 : vm.products.length,

                itemBuilder: (context, index) {
                  final product = vm.products[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () =>
                          showProductDetailsDialog(context, product.id),
                      child: Padding(
                        padding: const EdgeInsets.all(5),

                        child: Row(
                          children: [
                            /// PRODUCT IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.network(
                                product.thumbnail,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 8),

                            /// PRODUCT DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "Brand : ${product.brand}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.brandText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    "Category : ${product.category}",
                                    style: const TextStyle(
                                      color: AppColors.categoryText,
                                    ),
                                  ),

                                  Text(
                                    "Rating : ${product.rating}",
                                    style: const TextStyle(
                                      color: AppColors.ratingText,
                                    ),
                                  ),

                                  Text(
                                    "Stock : ${product.stock}",
                                    style: const TextStyle(
                                      color: AppColors.stockText,
                                    ),
                                  ),

                                  Text(
                                    "\$${product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: AppColors.priceText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    "Discount : ${product.discountPercentage}%",
                                    style: const TextStyle(
                                      color: AppColors.discountText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// =========================
  /// ALL BOTTOM NAVIGATION SCREENS
  /// =========================
  List<Widget> get screens => [
    buildHomeScreen(),

    const CategoryScreen(),

    const CartScreen(),

    // const WishlistScreen(),

    // ProfileScreen(userData: userData, onLogout: logoutUser),
    ProfileScreen(
      onLogout: logoutUser,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,

      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

        body: screens[currentIndex],

        /// =========================
        /// BOTTOM NAVIGATION BAR
        /// Modern animated nav bar with pill-style active indicator,
        /// smooth AnimatedContainer transitions, rounded top corners,
        /// drop shadow, and optional cart badge count.
        /// Only this widget changed — all navigation logic is unchanged.
        /// =========================
        bottomNavigationBar: ModernBottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          // Pass cart item count here if you have a CartViewModel.
          // Example: cartCount: context.watch<CartViewModel>().itemCount,
          cartCount: 0,
        ),
      ),
    );
  }
}
