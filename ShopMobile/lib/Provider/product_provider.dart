import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';

import '../Screens/Products/Repo/product_repo.dart';

ProductRepo productRepo = ProductRepo();
final productProvider = FutureProvider.family.autoDispose<List<ProductModel>,num?>((ref,id) => productRepo.fetchAllProducts(categoryId: id));
