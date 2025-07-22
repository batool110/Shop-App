import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/product.dart';

class EnhancedProductCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onTap;
  final String? heroTag;

  const EnhancedProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onTap,
    this.heroTag,
  });

  @override
  State<EnhancedProductCard> createState() => _EnhancedProductCardState();
}

class _EnhancedProductCardState extends State<EnhancedProductCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _favoriteController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _favoriteAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _favoriteController = AnimationController(
      duration: AppConstants.defaultAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _favoriteAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );

    if (widget.isFavorite) {
      _favoriteController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant EnhancedProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _favoriteController.forward();
      } else {
        _favoriteController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = widget.heroTag ?? 'product-${widget.product.id}';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColors.shadow.withValues(alpha: 0.3)
                        : AppColors.shadow,
                    blurRadius: _isPressed ? 12 : 8,
                    offset: _isPressed
                        ? const Offset(0, 6)
                        : const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section with favorite button
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                            ),
                            child: Hero(
                              tag: heroTag,
                              child: CachedNetworkImage(
                                imageUrl: widget.product.image,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(
                                  color: AppColors.background,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.background,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.textHint,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Favorite button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: AnimatedBuilder(
                              animation: _favoriteAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 0.8 + (_favoriteAnimation.value * 0.4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.surface.withValues(
                                        alpha: 0.9,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.shadow.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        widget.onFavoritePressed();
                                        if (!widget.isFavorite) {
                                          _favoriteController.forward();
                                        } else {
                                          _favoriteController.reverse();
                                        }
                                      },
                                      icon: Icon(
                                        widget.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: widget.isFavorite
                                            ? AppColors.favorite
                                            : AppColors.favoriteInactive,
                                        size: 20,
                                      ),
                                      splashRadius: 20,
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 36,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content section
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.smallPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.product.category.toUpperCase(),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 9,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Product title
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Price and rating row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Price
                                Text(
                                  '\$${widget.product.price.toStringAsFixed(2)}',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Rating
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: AppColors.warning,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        widget.product.rating.rate
                                            .toStringAsFixed(1),
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.warning,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
