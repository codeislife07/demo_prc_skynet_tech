part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeLoadProducts extends HomeEvent {}

class HomeAddToCart extends HomeEvent {
  final ProductItem product;

  HomeAddToCart({required this.product});
}

class HomeRemoveFromCart extends HomeEvent {
  final String productName;

  HomeRemoveFromCart({required this.productName});
}

class HomeClearCart extends HomeEvent {}
