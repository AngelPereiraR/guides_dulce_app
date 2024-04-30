import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart' as main;
import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../screens/screens.dart';
import '../../widgets/widgets.dart';

class CategoryView extends ConsumerWidget {
  final Category category;
  const CategoryView(this.category, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = main.container.read(authProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: FutureBuilder<List<Guide>>(
        future: main.container
            .read(guideProvider.notifier)
            .getAllGuidesByCategoryId(category.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SplashScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final guides = snapshot.data;
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
                        if (guides!.isNotEmpty)
                          for (Guide guide in guides)
                            Center(
                                child: Column(
                              children: [
                                if (authNotifier.authStatus ==
                                    AuthStatus.authenticated)
                                  CustomGuideCard(
                                    guide: guide,
                                    categoryId: category.id,
                                    userLoggedIn: true,
                                  ),
                                if (authNotifier.authStatus ==
                                        AuthStatus.notAuthenticated ||
                                    authNotifier.authStatus ==
                                        AuthStatus.checking)
                                  CustomGuideCard(
                                    guide: guide,
                                    categoryId: category.id,
                                    userLoggedIn: false,
                                  ),
                                const SizedBox(height: 10),
                              ],
                            )),
                        if (guides.isEmpty)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (authNotifier.authStatus ==
                                    AuthStatus.authenticated)
                                  FloatingActionButton(
                                    heroTag: 'create-guide',
                                    onPressed: () {
                                      context
                                          .push('/create-guide/${category.id}');
                                    },
                                    tooltip: 'Añadir nueva guía',
                                    child: const Icon(Icons.add_outlined),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (guides.isNotEmpty)
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
                              heroTag: 'create-guide',
                              onPressed: () {
                                context.push('/create-guide/${category.id}');
                              },
                              tooltip: 'Añadir nueva guía',
                              child: const Icon(Icons.add_outlined),
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
    );
  }
}
