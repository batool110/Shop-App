import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class CategoryFilter extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.defaultAnimationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value * 300, 0),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.smallPadding,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              itemCount: widget.categories.length + 1, // +1 for "All" option
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryChip(
                    'All',
                    widget.selectedCategory == null,
                  );
                }

                final category = widget.categories[index - 1];
                final isSelected = widget.selectedCategory == category;

                return _buildCategoryChip(category, isSelected);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return AnimatedContainer(
      duration: AppConstants.defaultAnimationDuration,
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(right: AppConstants.smallPadding),
      child: FilterChip(
        label: Text(
          category == 'All' ? category : _formatCategoryName(category),
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.surface : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          widget.onCategorySelected(category == 'All' ? null : category);
        },
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        checkmarkColor: AppColors.surface,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.divider,
          width: 1.5,
        ),
        elevation: isSelected ? 4 : 1,
        pressElevation: 8,
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
