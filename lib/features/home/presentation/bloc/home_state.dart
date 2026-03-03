part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  final HomeStatus status;
  final List<ProductItem> products;
  final List<ProductItem> cartItems;
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.products = const [],
    this.cartItems = const [],
    this.errorMessage = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ProductItem>? products,
    List<ProductItem>? cartItems,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
