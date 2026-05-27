import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../utils/edge_to_edge.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
import '../viewmodel/home_view_model.dart';
import 'category_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                vm.errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText,
              ),
            ),
          );
        }

        if (vm.categories.isEmpty) {
          return const Center(
            child: Text("No categories found", style: AppTextStyles.subHeading),
          );
        }

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeToEdge.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.categories,
                  style: AppTextStyles.subHeading,
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: vm.categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.15,
                        ),
                    itemBuilder: (context, index) {
                      final category = vm.categories[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                child: const Icon(
                                  Icons.category,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                category.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyText.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
