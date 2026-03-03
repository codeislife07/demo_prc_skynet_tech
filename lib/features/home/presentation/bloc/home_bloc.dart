import 'package:demo_prc_skynet_tech/features/home/domain/repositories/home_repository.dart';
import 'package:demo_prc_skynet_tech/features/home/entity/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(const HomeState()) {
    on<HomeLoadProducts>(_onLoadProducts);
    on<HomeAddToCart>(_onAddToCart);
    on<HomeRemoveFromCart>(_onRemoveFromCart);
    on<HomeClearCart>(_onClearCart);
  }

  Future<void> _onLoadProducts(
    HomeLoadProducts event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: ''));
    try {
      var products = await repository.getProductsServer();
      if (products.isEmpty) {
        products = await repository.getProductsLocal();
      }

      emit(
        state.copyWith(
          status: HomeStatus.success,
          products: products,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onAddToCart(HomeAddToCart event, Emitter<HomeState> emit) {
    final updated = [...state.cartItems, event.product];
    emit(state.copyWith(cartItems: updated));
  }

  void _onRemoveFromCart(HomeRemoveFromCart event, Emitter<HomeState> emit) {
    final updated = [...state.cartItems];
    final index = updated.indexWhere((item) => item.tfvname == event.productName);
    if (index >= 0) {
      updated.removeAt(index);
      emit(state.copyWith(cartItems: updated));
    }
  }

  void _onClearCart(HomeClearCart event, Emitter<HomeState> emit) {
    emit(state.copyWith(cartItems: []));
  }
}
