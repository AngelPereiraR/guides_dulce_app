// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guides_dulce_app/domain/domain.dart';
import 'package:guides_dulce_app/presentation/screens/screens.dart';

import '../../providers/providers.dart';
import '../../views/views.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  static const name = 'category-screen';
  final int categoryId;

  const CategoryScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends ConsumerState<CategoryScreen> {
  late Category category;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  Future<void> getCategory() async {
    final fetchedCategory = await ref
        .read(categoryProvider.notifier)
        .getCategory(widget.categoryId);

    setState(() {
      category = fetchedCategory;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }
    return WillPopScope(
      onWillPop: () async {
        context.pushReplacement('/');
        return false;
      },
      child: Scaffold(
        body: GestureDetector(
          child: CategoryView(category),
        ),
      ),
    );
  }
}
