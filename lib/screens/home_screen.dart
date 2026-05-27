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

    const WishlistScreen(),

    ProfileScreen(userData: userData, onLogout: logoutUser),
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
        /// =========================
        bottomNavigationBar: EdgeToEdgeBottomBar(
          child: BottomNavigationBar(
            currentIndex: currentIndex,

            type: BottomNavigationBarType.fixed,

            selectedItemColor: Colors.blue,

            unselectedItemColor: Colors.grey,

            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },

            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.category),

                label: "Category",
              ),

              const BottomNavigationBarItem(
                icon: CartBadge(iconColor: Colors.grey, iconSize: 24),
                activeIcon: CartBadge(iconColor: Colors.blue, iconSize: 24),

                label: "Cart",
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite),

                label: "Wishlist",
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.person),

                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
