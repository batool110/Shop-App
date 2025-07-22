import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/product_card.dart';

class ProductGridView extends StatelessWidget {
  final List<Product> products;
  final List<int> favoriteIds;
  final Function(int) onFavoritePressed;
  final Function(Product)? onProductTap;

  const ProductGridView({
    super.key,
    required this.products,
    required this.favoriteIds,
    required this.onFavoritePressed,
    this.onProductTap,
  });

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
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFavorite = favoriteIds.contains(product.id);

        return ProductCard(
          product: product,
          isFavorite: isFavorite,
          onFavoritePressed: () => onFavoritePressed(product.id),
          onTap: onProductTap != null ? () => onProductTap!(product) : null,
        );
      },
    );
  }
}
