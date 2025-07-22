import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/favorite/favorite_cubit.dart';
import '../cubits/favorite/favorite_state.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/error_widget.dart' as custom_error;
import '../widgets/empty_state_widget.dart';
import '../widgets/product_card.dart';
import '../../data/models/product.dart';
import '../../core/constants/app_constants.dart';

class FavoritesTab extends StatefulWidget {
  final Function(Product, List<int>) onProductTap;

  const FavoritesTab({super.key, required this.onProductTap});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const SkeletonGridView();
        }

        if (state is FavoriteError) {
          return custom_error.ErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<FavoriteCubit>().loadFavorites();
            },
          );
        }

        if (state is FavoriteLoaded) {
          if (state.favoriteProducts.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Favorites Yet',
              message:
                  'You haven\'t added any products to your favorites. Start browsing to add some!',
              icon: Icons.favorite_border,
            );
          }

          // Create list of favorite IDs for consistency
          final favoriteIds = state.favoriteProducts.map((p) => p.id).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<FavoriteCubit>().refreshFavorites();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppConstants.gridCrossAxisCount,
                mainAxisSpacing: AppConstants.gridMainAxisSpacing,
                crossAxisSpacing: AppConstants.gridCrossAxisSpacing,
                childAspectRatio: AppConstants.gridChildAspectRatio,
              ),
              itemCount: state.favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = state.favoriteProducts[index];

                return ProductCard(
                  product: product,
                  isFavorite:
                      true, // All products in favorites tab are favorites
                  onFavoritePressed: () {
                    context.read<FavoriteCubit>().toggleFavorite(product.id);
                  },
                  onTap: () => widget.onProductTap(product, favoriteIds),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
