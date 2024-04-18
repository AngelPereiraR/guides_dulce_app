import 'package:flutter/material.dart';

class CustomAuthBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onItemTapped;

  const CustomAuthBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (value) => onItemTapped(value),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.login_outlined),
          label: 'Iniciar Sesión',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add_outlined),
          label: 'Registrarse',
        ),
      ],
    );
  }
}
