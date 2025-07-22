import 'package:equatable/equatable.dart';
import '../../../data/models/product.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Product> favoriteProducts;

  const FavoriteLoaded({required this.favoriteProducts});

  @override
  List<Object?> get props => [favoriteProducts];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
