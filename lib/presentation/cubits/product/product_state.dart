import 'package:equatable/equatable.dart';
import '../../../data/models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<int> favoriteIds;

  const ProductLoaded({required this.products, required this.favoriteIds});

  @override
  List<Object?> get props => [products, favoriteIds];

  ProductLoaded copyWith({List<Product>? products, List<int>? favoriteIds}) {
    return ProductLoaded(
      products: products ?? this.products,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
