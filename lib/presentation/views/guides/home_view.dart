import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guides_dulce_app/presentation/providers/auth/auth_provider.dart';

import '../../widgets/widgets.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        appBar: AppBar(
          title: const Text('Guías'),
        ),
        body: Stack(
          children: [
            const Column(
              children: [
                Center(
                  child: Placeholder(
                    fallbackHeight: 300,
                    fallbackWidth: 300,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (authNotifier.authStatus == AuthStatus.authenticated)
                      FloatingActionButton(
                        heroTag: 'create-guide',
                        onPressed: () {
                          context.push('/create-guide');
                        },
                        tooltip: 'Añadir nueva guía',
                        child: const Icon(Icons.add_outlined),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (authNotifier.authStatus == AuthStatus.authenticated)
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
        ),
      ),
    );
  }
}
