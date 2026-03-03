import 'dart:convert';

import 'package:demo_prc_skynet_tech/core/api/api_service.dart';
import 'package:demo_prc_skynet_tech/features/home/domain/repositories/home_repository.dart';
import 'package:demo_prc_skynet_tech/features/home/entity/product_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeRepositoryIm implements HomeRepository {
  final storage = FlutterSecureStorage();

  @override
  Future<List<ProductItem>> getProductsServer() async {
    final response = await ApiService().sendApiReqest(
      path: 'tfvjsonapi.php?search=all',
      body: {},
    );

    if (response.isEmpty) {
      return [];
    }

    final model = ProductListModel.fromJson(response);
    await storage.write(key: 'products', value: jsonEncode(response));
    return model.results;
  }

  @override
  Future<List<ProductItem>> getProductsLocal() async {
    final result = await storage.read(key: 'products');
    try {
      if ((result ?? '').isEmpty) {
        return [];
      }

      final model = ProductListModel.fromJson(jsonDecode(result!));
      return model.results;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<ProductItem?> getProductDetailsByNameLocal(String name) async {
    final result = await storage.read(key: 'products_$name');
    if ((result ?? '').isEmpty) {
      return null;
    }

    final model = ProductListModel.fromJson(jsonDecode(result!));
    return model.results.isEmpty ? null : model.results.first;
  }

  @override
  Future<ProductItem?> getProductDetailsByNameServer(String name) async {
    final response = await ApiService().sendApiReqest(
      path: 'tfvjsonapi.php?tfvitem=$name',
      body: {},
    );

    if (response.isEmpty) {
      return null;
    }

    final model = ProductListModel.fromJson(response);
    await storage.write(key: 'products_$name', value: jsonEncode(response));
    return model.results.isEmpty ? null : model.results.first;
  }
}
