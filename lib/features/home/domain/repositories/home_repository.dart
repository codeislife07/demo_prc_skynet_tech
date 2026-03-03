import 'package:demo_prc_skynet_tech/features/home/entity/product_model.dart';

abstract class HomeRepository {
  Future<List<ProductItem>> getProductsServer();
  Future<List<ProductItem>> getProductsLocal();
  Future<ProductItem?> getProductDetailsByNameServer(String name);
  Future<ProductItem?> getProductDetailsByNameLocal(String name);
}
