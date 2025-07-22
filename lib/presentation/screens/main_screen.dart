import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/product/product_cubit.dart';
import '../cubits/product/product_state.dart';
import '../cubits/favorite/favorite_cubit.dart';
import '../cubits/favorite/favorite_state.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/error_widget.dart' as custom_error;
import '../widgets/empty_state_widget.dart';
import '../widgets/enhanced_product_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/animated_favorite_button.dart';
import 'favorites_screen.dart';
import '../../data/models/product.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fabAnimationController;
  late Animation<Offset> _fabSlideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _fabAnimationController = AnimationController(
      duration: AppConstants.defaultAnimationDuration,
      vsync: this,
    );

    _fabSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _fabAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    context.read<ProductCubit>().loadProducts();
    context.read<FavoriteCubit>().loadFavorites();

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
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

  void _showProductDetails(
    BuildContext context,
    Product product,
    List<int> favoriteIds,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailsBottomSheet(
        product: product,
        isFavorite: favoriteIds.contains(product.id),
        onFavoritePressed: () {
          context.read<ProductCubit>().toggleFavorite(product.id);
          context.read<FavoriteCubit>().toggleFavorite(product.id);
        },
      ),
    );
  }

  void _navigateToFavorites() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FavoritesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: AppConstants.longAnimationDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ProductCubit>().refreshProducts();
              context.read<FavoriteCubit>().refreshFavorites();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Column(
              children: [
                SizedBox(height: 60), // Space for category filter
                Expanded(child: SkeletonGridView()),
              ],
            );
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
            List<String> categories = [];
            String? selectedCategory;

            if (state is ProductLoaded) {
              products = state.products;
              favoriteIds = state.favoriteIds;
              hasReachedMax = state.hasReachedMax;
              categories = context.read<ProductCubit>().getCategories();
              selectedCategory = state.selectedCategory;
            } else if (state is ProductLoadingMore) {
              products = state.currentProducts;
              favoriteIds = state.favoriteIds;
              isLoadingMore = true;
              categories = context.read<ProductCubit>().getCategories();
            }

            if (products.isEmpty && !isLoadingMore) {
              return Column(
                children: [
                  if (categories.isNotEmpty)
                    CategoryFilter(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) {
                        context.read<ProductCubit>().filterByCategory(category);
                      },
                    ),
                  const Expanded(
                    child: EmptyStateWidget(
                      title: 'No Products Found',
                      message: 'No products match the selected category.',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                // Category Filter
                if (categories.isNotEmpty)
                  CategoryFilter(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) {
                      context.read<ProductCubit>().filterByCategory(category);
                    },
                  ),

                // Products Grid
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<ProductCubit>().refreshProducts();
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(
                            AppConstants.defaultPadding,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      AppConstants.gridCrossAxisCount,
                                  mainAxisSpacing:
                                      AppConstants.gridMainAxisSpacing,
                                  crossAxisSpacing:
                                      AppConstants.gridCrossAxisSpacing,
                                  childAspectRatio:
                                      AppConstants.gridChildAspectRatio,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final product = products[index];
                              final isFavorite = favoriteIds.contains(
                                product.id,
                              );

                              return EnhancedProductCard(
                                product: product,
                                isFavorite: isFavorite,
                                onFavoritePressed: () {
                                  context.read<ProductCubit>().toggleFavorite(
                                    product.id,
                                  );
                                  context.read<FavoriteCubit>().toggleFavorite(
                                    product.id,
                                  );
                                },
                                onTap: () => _showProductDetails(
                                  context,
                                  product,
                                  favoriteIds,
                                ),
                              );
                            }, childCount: products.length),
                          ),
                        ),
                        if (isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(
                                AppConstants.defaultPadding,
                              ),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        if (!hasReachedMax &&
                            !isLoadingMore &&
                            products.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(
                                AppConstants.defaultPadding,
                              ),
                              child: Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<ProductCubit>()
                                        .loadMoreProducts();
                                  },
                                  icon: const Icon(Icons.expand_more),
                                  label: const Text('Load More'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.largePadding,
                                      vertical: AppConstants.defaultPadding,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: SlideTransition(
        position: _fabSlideAnimation,
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            int favoriteCount = 0;
            if (state is FavoriteLoaded) {
              favoriteCount = state.favoriteProducts.length;
            }

            return AnimatedFavoriteButton(
              favoriteCount: favoriteCount,
              onPressed: _navigateToFavorites,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ProductDetailsBottomSheet extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const ProductDetailsBottomSheet({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Hero(
                    tag: 'product-${product.id}',
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.favorite.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: onFavoritePressed,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? AppColors.favorite
                                : AppColors.favoriteInactive,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${product.rating.rate} (${product.rating.count} reviews)',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
