class ProductListModel {
  ProductListModel({required this.results, required this.tfvcount});

  final List<ProductItem> results;
  final int tfvcount;

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'];
    return ProductListModel(
      results: rawResults is List
          ? rawResults
                .whereType<Map<String, dynamic>>()
                .map(ProductItem.fromJson)
                .toList()
          : <ProductItem>[],
      tfvcount: int.tryParse('${json['tfvcount'] ?? 0}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'results': results.map((x) => x.toJson()).toList(),
    'tfvcount': tfvcount,
  };
}

class ProductItem {
  ProductItem({
    required this.tfvname,
    required this.botname,
    required this.othname,
    required this.imageurl,
    required this.details,
  });

  final String tfvname;
  final String botname;
  final String othname;
  final String imageurl;
  final Map<String, dynamic> details;

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    final rawImage = '${json['imageurl'] ?? ''}'.trim();
    return ProductItem(
      tfvname: '${json['tfvname'] ?? ''}',
      botname: '${json['botname'] ?? ''}',
      othname: '${json['othname'] ?? ''}',
      imageurl: _normalizeImageUrl(rawImage),
      details: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>.from(details);
    map['tfvname'] = tfvname;
    map['botname'] = botname;
    map['othname'] = othname;
    map['imageurl'] = imageurl;
    return map;
  }

  static String _normalizeImageUrl(String url) {
    if (url.isEmpty) {
      return '';
    }
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    if (url.startsWith('http://')) {
      return 'https://${url.substring(7)}';
    }
    return url;
  }
}

typedef SingleProductItem = ProductItem;
