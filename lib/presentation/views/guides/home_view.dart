import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guides_dulce_app/presentation/providers/providers.dart';

import '../../../main.dart' as main;
import '../../../domain/domain.dart';
import '../../widgets/widgets.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = main.container.read(authProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: scaffoldKey,
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        appBar: AppBar(
          title: const Text(
            'Categorías de guías',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        body: FutureBuilder<List<Category>>(
          future:
              main.container.read(categoryProvider.notifier).getAllCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final categories = snapshot.data;
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom:
                            authNotifier.authStatus == AuthStatus.authenticated
                                ? 75
                                : 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (categories != null)
                            for (Category category in categories)
                              Center(
                                  child: Column(
                                children: [
                                  if (authNotifier.authStatus ==
                                      AuthStatus.authenticated)
                                    CustomCategoryCard(
                                      category: category,
                                      userLoggedIn: true,
                                    ),
                                  if (authNotifier.authStatus ==
                                          AuthStatus.notAuthenticated ||
                                      authNotifier.authStatus ==
                                          AuthStatus.checking)
                                    CustomCategoryCard(
                                      category: category,
                                      userLoggedIn: false,
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )),
                          if (categories == null)
                            const Center(
                              child: Placeholder(
                                fallbackHeight: 300,
                                fallbackWidth: 300,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (authNotifier.authStatus ==
                              AuthStatus.authenticated)
                            FloatingActionButton(
                              heroTag: 'create-category',
                              onPressed: () {
                                context.push('/create-category');
                              },
                              tooltip: 'Añadir nueva categoría de guías',
                              child: const Icon(Icons.category_outlined),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
