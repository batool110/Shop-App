import 'package:equatable/equatable.dart';
import '../../../data/models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoadingMore extends ProductState {
  final List<Product> currentProducts;
  final List<int> favoriteIds;

  const ProductLoadingMore({
    required this.currentProducts,
    required this.favoriteIds,
  });

  @override
  List<Object?> get props => [currentProducts, favoriteIds];
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<int> favoriteIds;
  final bool hasReachedMax;
  final int currentLimit;
  final List<Product> allProducts;
  final String? selectedCategory;

  const ProductLoaded({
    required this.products,
    required this.favoriteIds,
    this.hasReachedMax = false,
    this.currentLimit = 10,
    this.allProducts = const [],
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [
    products,
    favoriteIds,
    hasReachedMax,
    currentLimit,
    allProducts,
    selectedCategory,
  ];

  ProductLoaded copyWith({
    List<Product>? products,
    List<int>? favoriteIds,
    bool? hasReachedMax,
    int? currentLimit,
    List<Product>? allProducts,
    String? selectedCategory,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentLimit: currentLimit ?? this.currentLimit,
      allProducts: allProducts ?? this.allProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
