import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';

class CustomGuideCard extends ConsumerWidget {
  final Guide guide;
  final int categoryId;
  final bool userLoggedIn;

  const CustomGuideCard({
    super.key,
    required this.guide,
    required this.categoryId,
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
                    SizedBox(
                      width: 250,
                      child: Tooltip(
                        message: guide.name,
                        child: Text(
                          guide.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    if (userLoggedIn)
                      IconButton(
                        onPressed: () async {
                          final bool? isConfirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar guía'),
                              content: Text(
                                  '¿Estás seguro de que quieres eliminar la guía "${guide.name}"?'),
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
                            await ref
                                .read(guideProvider.notifier)
                                .deleteGuide(guide.id, categoryId);

                            showSnackbar(context,
                                'Se ha eliminado la guía correctamente.');
                            context.pushReplacement('/category/$categoryId');
                          }
                        },
                        icon: const Icon(Icons.delete_outlined),
                        tooltip: 'Eliminar guía',
                      ),
                    if (userLoggedIn)
                      IconButton(
                        onPressed: () {
                          context.push('/edit-guide/$categoryId/${guide.id}');
                        },
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Editar guía',
                      ),
                    TextButton(
                      onPressed: () {
                        context
                            .pushReplacement('/guide/$categoryId/${guide.id}');
                      },
                      child: const Text('Ver guía'),
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
