import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({super.key, this.width, this.height, this.borderRadius});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius:
                widget.borderRadius ??
                BorderRadius.circular(AppConstants.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _animation.value, 0.0),
              end: Alignment(1.0 + _animation.value, 0.0),
              colors: const [
                AppColors.divider,
                AppColors.surface,
                AppColors.divider,
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: SkeletonLoader(
                width: double.infinity,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            const SkeletonLoader(width: 60, height: 12),
            const SizedBox(height: AppConstants.smallPadding / 2),
            const SkeletonLoader(width: double.infinity, height: 16),
            const SizedBox(height: AppConstants.smallPadding / 2),
            const SkeletonLoader(width: 120, height: 16),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonLoader(width: 60, height: 18),
                SkeletonLoader(width: 40, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonGridView extends StatelessWidget {
  final int itemCount;

  const SkeletonGridView({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppConstants.gridCrossAxisCount,
        mainAxisSpacing: AppConstants.gridMainAxisSpacing,
        crossAxisSpacing: AppConstants.gridCrossAxisSpacing,
        childAspectRatio: AppConstants.gridChildAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardSkeleton(),
    );
  }
}
