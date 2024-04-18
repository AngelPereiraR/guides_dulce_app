import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
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
                  FloatingActionButton(
                    onPressed: () {
                      context.push('/create-guide');
                    },
                    tooltip: 'Añadir nueva guía',
                    child: const Icon(Icons.add_outlined),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
