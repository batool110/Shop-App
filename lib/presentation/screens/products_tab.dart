import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/product/product_cubit.dart';
import '../cubits/product/product_state.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/error_widget.dart' as custom_error;
import '../widgets/empty_state_widget.dart';
import '../widgets/product_card.dart';
import '../../data/models/product.dart';
import '../../core/constants/app_constants.dart';

class ProductsTab extends StatefulWidget {
  final Function(Product, List<int>) onProductTap;

  const ProductsTab({super.key, required this.onProductTap});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ProductCubit>().loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductCubit>().loadMoreProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SkeletonGridView();
        }

        if (state is ProductError) {
          return custom_error.ErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<ProductCubit>().loadProducts();
            },
          );
        }

        if (state is ProductLoaded || state is ProductLoadingMore) {
          List<Product> products = [];
          List<int> favoriteIds = [];
          bool hasReachedMax = false;
          bool isLoadingMore = false;

          if (state is ProductLoaded) {
            products = state.products;
            favoriteIds = state.favoriteIds;
            hasReachedMax = state.hasReachedMax;
          } else if (state is ProductLoadingMore) {
            products = state.currentProducts;
            favoriteIds = state.favoriteIds;
            isLoadingMore = true;
          }

          if (products.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Products Found',
              message: 'There are no products available at the moment.',
              icon: Icons.shopping_bag_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ProductCubit>().refreshProducts();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AppConstants.gridCrossAxisCount,
                          mainAxisSpacing: AppConstants.gridMainAxisSpacing,
                          crossAxisSpacing: AppConstants.gridCrossAxisSpacing,
                          childAspectRatio: AppConstants.gridChildAspectRatio,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products[index];
                      final isFavorite = favoriteIds.contains(product.id);

                      return ProductCard(
                        product: product,
                        isFavorite: isFavorite,
                        onFavoritePressed: () {
                          context.read<ProductCubit>().toggleFavorite(
                            product.id,
                          );
                        },
                        onTap: () => widget.onProductTap(product, favoriteIds),
                      );
                    }, childCount: products.length),
                  ),
                ),
                if (isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.defaultPadding),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (!hasReachedMax && !isLoadingMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ProductCubit>().loadMoreProducts();
                          },
                          child: const Text('Load More'),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
