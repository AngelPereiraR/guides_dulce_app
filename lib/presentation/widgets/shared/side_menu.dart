import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart' as main;
import '../../providers/providers.dart';
import '../widgets.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;

    void showSnackbar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return Consumer(
      builder: (context, ref, child) {
        final authState = main.container.read(authProvider);

        return NavigationDrawer(
          elevation: 1,
          selectedIndex: navDrawerIndex,
          onDestinationSelected: (value) {
            setState(() {
              navDrawerIndex = value;
            });

            widget.scaffoldKey.currentState?.closeDrawer();
          },
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, hasNotch ? 20 : 40, 16, 0),
              child: Text('Saludos', style: textStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
              child: Text(
                  authState.user?.id != 0 ? authState.user!.name : 'Usuario',
                  style: textStyles.titleSmall),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.inventory_outlined),
              label: Text('Categorías de guías'),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
              child: Divider(),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
              child: Text('Otras opciones'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: authState.user?.id != 0
                  ? CustomFilledButton(
                      onPressed: () async {
                        await main.container
                            .read(authProvider.notifier)
                            .logout();
                        showSnackbar(
                            context, 'La sesión se ha cerrado con éxito');
                        context.pushReplacement('/');
                      },
                      text: 'Cerrar sesión',
                    )
                  : CustomFilledButton(
                      onPressed: () {
                        context.push('/login');
                      },
                      text: 'Iniciar sesión',
                    ),
            ),
          ],
        );
      },
    );
  }
}
