import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guides_dulce_app/presentation/screens/auth/splash_screen.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class EditCategoryScreen extends ConsumerStatefulWidget {
  final int id;
  static const name = 'edit-category-screen';

  const EditCategoryScreen({super.key, required this.id});

  @override
  EditCategoryState createState() => EditCategoryState();
}

class EditCategoryState extends ConsumerState<EditCategoryScreen> {
  late Category category;
  bool _isLoading = true;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  Future<void> getCategory() async {
    final fetchedCategory =
        await ref.read(categoryProvider.notifier).getCategory(widget.id);

    setState(() {
      category = fetchedCategory;
      _isLoading = false;
    });
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final categoryEditForm = ref.watch(categoryEditFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

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
                        Icons.edit_outlined,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Text('Editar categoría de juego',
                              style: textStyles.titleLarge),
                          const SizedBox(height: 50),
                          CustomTextFormField(
                            label: 'Nombre del juego',
                            keyboardType: TextInputType.text,
                            initialValue: category.name,
                            onChanged: (newValue) {
                              setState(() {
                                _isChanged = true;
                              });
                              ref
                                  .read(categoryEditFormProvider.notifier)
                                  .onNameChanged(newValue);
                            },
                            errorMessage: categoryEditForm.isFormPosted
                                ? categoryEditForm.name.errorMessage
                                : null,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: CustomFilledButton(
                                text: 'Editar',
                                onPressed: categoryEditForm.isPosting
                                    ? null
                                    : () {
                                        if (_isChanged == false) {
                                          ref
                                              .read(categoryEditFormProvider
                                                  .notifier)
                                              .onNameChanged(category.name);
                                        }
                                        Future<bool> futureIsEdited = ref
                                            .read(categoryEditFormProvider
                                                .notifier)
                                            .onFormSubmit(category.id);
                                        futureIsEdited.then((isEdited) {
                                          if (isEdited) {
                                            showSnackbar(context,
                                                'Se ha editado la categoría correctamente.');
                                            context.pushReplacement('/');
                                          }
                                        });
                                      }),
                          ),
                        ],
                      ),
                    ),
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
