import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class CreateCategoryScreen extends StatelessWidget {
  static const name = 'create-category-screen';
  const CreateCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: GeometricalBackground(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (!context.canPop()) return;
                            context.pop();
                          },
                          icon: const Icon(Icons.arrow_back_rounded,
                              size: 40, color: Colors.white)),
                      const Spacer(),
                      const Icon(
                        Icons.games_outlined,
                        color: Colors.white,
                        size: 100,
                      ),
                      const Spacer(),
                      const SizedBox(width: 50),
                    ],
                  ),
                  if (orientation == Orientation.portrait)
                    const SizedBox(height: 200),
                  if (orientation == Orientation.landscape)
                    const SizedBox(height: 50),
                  Container(
                    height: orientation == Orientation.portrait
                        ? size.height - 400
                        : size.height - 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          topLeft: Radius.circular(100)),
                    ),
                    child: const _LoginForm(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAddForm = ref.watch(categoryAddFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Crear categoría de juego', style: textStyles.titleLarge),
          const SizedBox(height: 50),
          CustomTextFormField(
            label: 'Nombre del juego',
            keyboardType: TextInputType.text,
            onChanged: ref.read(categoryAddFormProvider.notifier).onNameChanged,
            errorMessage: categoryAddForm.isFormPosted
                ? categoryAddForm.name.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
                text: 'Crear',
                onPressed: categoryAddForm.isPosting
                    ? null
                    : () {
                        Future<bool> futureIsAdded = ref
                            .read(categoryAddFormProvider.notifier)
                            .onFormSubmit();
                        futureIsAdded.then((isAdded) {
                          if (isAdded) {
                            showSnackbar(context,
                                'Se ha creado la categoría correctamente.');
                            context.pushReplacement('/');
                          }
                        });
                      }),
          ),
        ],
      ),
    );
  }
}
