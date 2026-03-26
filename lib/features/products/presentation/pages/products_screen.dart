import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';

import '../../data/models/product_model.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
// لا تنسي تعملي import لملفات الـ Cubit والـ Model تبعتك

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    // بنستدعي الداتا أول ما تفتح الشاشة
    context.read<ProductsCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جميع المنتجات')),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          // الحالة الأولى: جاري التحميل
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // الحالة الثانية: حدث خطأ
          else if (state is ProductsError) {
            return Center(
              child: Text(
                'حدث خطأ: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // الحالة الثالثة: نجاح وجلب البيانات
          else if (state is ProductsLoaded) {
            final products = state.products;

            // إذا ما في منتجات راجعة
            if (products.isEmpty) {
              return const Center(child: Text('لا توجد منتجات حالياً'));
            }

            // عرض المنتجات في شبكة (Grid)
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الكروت في السطر الواحد
                crossAxisSpacing: 10, // المسافة الأفقية بين الكروت
                mainAxisSpacing: 10, // المسافة العمودية بين الكروت
                childAspectRatio:
                    0.75, // نسبة العرض للطول للكارت (عدليها حسب تصميمك)
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(
                  product,
                ); // فصلنا الكارت بميثود عشان النظافة
              },
            );
          }

          // الحالة الافتراضية
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ودجت (كارت) مبسط لعرض بيانات المنتج
  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.productDetails, extra: product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. صورة المنتج (بما إنها حالياً بتيجي فاضية، حطينا صورة افتراضية)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child:
                    product.images.isNotEmpty
                        ? Image.network(product.images.first, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),

            // 2. تفاصيل المنتج
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // التصنيف (مثلاً Gaming / PC Parts) - مؤقتاً نعرض حالة المنتج
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.condition,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // اسم المنتج
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // السعر
                  Text(
                    '${product.price} ILS',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
