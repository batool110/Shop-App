import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'products_tab.dart';
import 'favorites_tab.dart';
import '../cubits/product/product_cubit.dart';
import '../cubits/favorite/favorite_cubit.dart';
import '../../data/models/product.dart';
import '../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.index == 1) {
      // When switching to favorites tab, reload favorites
      context.read<FavoriteCubit>().loadFavorites();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showProductDetails(
    BuildContext context,
    Product product,
    List<int> favoriteIds,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ProductDetailsBottomSheet(
        product: product,
        isFavorite: favoriteIds.contains(product.id),
        onFavoritePressed: () {
          // Update both cubits when favorite is toggled from product details
          context.read<ProductCubit>().toggleFavorite(product.id);
          context.read<FavoriteCubit>().toggleFavorite(product.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.shopping_bag), text: 'Products'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
          ],
          indicatorColor: AppColors.surface,
          labelColor: AppColors.surface,
          unselectedLabelColor: AppColors.surface.withValues(alpha: 0.7),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_tabController.index == 0) {
                context.read<ProductCubit>().refreshProducts();
              } else {
                context.read<FavoriteCubit>().refreshFavorites();
              }
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProductsTab(
            onProductTap: (product, favoriteIds) =>
                _showProductDetails(context, product, favoriteIds),
          ),
          FavoritesTab(
            onProductTap: (product, favoriteIds) =>
                _showProductDetails(context, product, favoriteIds),
          ),
        ],
      ),
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
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(product.image, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: onFavoritePressed,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.favorite : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.category.toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating.rate} (${product.rating.count} reviews)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
