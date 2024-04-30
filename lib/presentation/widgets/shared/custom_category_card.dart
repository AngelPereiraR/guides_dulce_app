import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/domain.dart';
import '../../../main.dart' as main;
import '../../providers/providers.dart';

class CustomCategoryCard extends ConsumerWidget {
  final Category category;
  final bool userLoggedIn;

  const CustomCategoryCard({
    super.key,
    required this.category,
    this.userLoggedIn = false,
  });

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const borderRadius = Radius.circular(15);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: borderRadius,
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Nº de guías: ${category.guideCount}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (userLoggedIn)
                      IconButton(
                        onPressed: () async {
                          final bool? isConfirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar categoría'),
                              content: Text(
                                  '¿Estás seguro de que quieres eliminar la categoría "${category.name}"?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text('Eliminar'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (isConfirmed!) {
                            List<Guide> guides = await main.container
                                .read(guideProvider.notifier)
                                .getAllGuidesByCategoryId(category.id);
                            for (Guide guide in guides) {
                              await ref
                                  .read(guideProvider.notifier)
                                  .deleteGuide(guide.id, category.id);
                            }
                            await ref
                                .read(categoryProvider.notifier)
                                .deleteCategory(category.id);

                            showSnackbar(context,
                                'Se ha eliminado la categoría correctamente.');
                            context.pushReplacement('/');
                          }
                        },
                        icon: const Icon(Icons.delete_outlined),
                        tooltip: 'Eliminar categoría de juegos',
                      ),
                    if (userLoggedIn)
                      IconButton(
                        onPressed: () {
                          context.push('/edit-category/${category.id}');
                        },
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Editar categoría de juegos',
                      ),
                    IconButton(
                      onPressed: () {
                        context.push('/category/${category.id}');
                      },
                      icon: const Icon(Icons.games_outlined),
                      tooltip: 'Ver guías de la categoría',
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
