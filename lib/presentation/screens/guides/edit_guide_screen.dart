import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guides_dulce_app/presentation/screens/auth/splash_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class EditGuideScreen extends ConsumerStatefulWidget {
  final int categoryId;
  final int id;
  static const name = 'edit-guide-screen';

  const EditGuideScreen({
    super.key,
    required this.id,
    required this.categoryId,
  });

  @override
  EditGuideState createState() => EditGuideState();
}

class EditGuideState extends ConsumerState<EditGuideScreen> {
  late Guide guide;
  late Category category;
  bool _isLoading = true;
  bool _isNameChanged = false;
  bool _isTypeChanged = false;
  bool _isDescriptionChanged = false;

  @override
  void initState() {
    super.initState();
    getGuide();
  }

  Future<void> getGuide() async {
    final fetchedGuide =
        await ref.read(guideProvider.notifier).getGuide(widget.id);
    final fetchedCategory = await ref
        .read(categoryProvider.notifier)
        .getCategory(widget.categoryId);

    setState(() {
      guide = fetchedGuide;
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
    final guideEditForm = ref.watch(guideEditFormProvider);
    final guideAddArchive = ref.watch(guideAddImageVideoProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;
    const borderRadius = Radius.circular(15);
    const padding = 15.0;

    return OrientationBuilder(
      builder: (context, orientation) {
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
                      const SizedBox(height: 100),
                    if (orientation == Orientation.landscape)
                      const SizedBox(height: 50),
                    Container(
                      height: orientation == Orientation.portrait
                          ? size.height - 275
                          : size.height + 200,
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
                            Text('Editar guía', style: textStyles.titleLarge),
                            const SizedBox(height: 50),
                            CustomTextFormField(
                              label: 'Nombre de la guía',
                              keyboardType: TextInputType.multiline,
                              initialValue: guide.name,
                              onChanged: (newValue) {
                                setState(() {
                                  _isNameChanged = true;
                                });
                                ref
                                    .read(guideEditFormProvider.notifier)
                                    .onNameChanged(newValue);
                              },
                              errorMessage: guideEditForm.isFormPosted
                                  ? guideEditForm.name.errorMessage
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: borderRadius,
                                      bottomLeft: borderRadius,
                                      bottomRight: borderRadius),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5))
                                  ]),
                              child: DropdownButtonFormField<String>(
                                padding: const EdgeInsets.only(
                                    left: padding,
                                    bottom: padding,
                                    right: padding),
                                decoration: InputDecoration(
                                  labelText: 'Tipo',
                                  errorText: guideEditForm.isFormPosted
                                      ? guideEditForm.type.errorMessage
                                      : null,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: borderRadius,
                                  bottomLeft: borderRadius,
                                  bottomRight: borderRadius,
                                ),
                                value: guide.type,
                                items: const [
                                  DropdownMenuItem(
                                      value: 'image', child: Text('Imagen')),
                                  DropdownMenuItem(
                                      value: 'video', child: Text('Vídeo')),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _isTypeChanged = true;
                                  });
                                  ref
                                      .read(guideEditFormProvider.notifier)
                                      .onTypeChanged(newValue ?? 'image');
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              label: 'Descripción',
                              keyboardType: TextInputType.multiline,
                              initialValue: guide.description,
                              onChanged: (newValue) {
                                setState(() {
                                  _isDescriptionChanged = true;
                                });
                                ref
                                    .read(guideEditFormProvider.notifier)
                                    .onDescriptionChanged(newValue);
                              },
                              errorMessage: guideEditForm.isFormPosted
                                  ? guideEditForm.description.errorMessage
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image;
                                final XFile? video;
                                if (guideEditForm.type.value == 'image') {
                                  image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  ref
                                      .read(guideAddImageVideoProvider.notifier)
                                      .setImageVideoType('image');
                                  if (image == null) {
                                    ref
                                        .read(
                                            guideAddImageVideoProvider.notifier)
                                        .setImageVideoError(
                                            'Error al seleccionar imagen');
                                    return;
                                  }
                                } else {
                                  image = null;
                                }

                                if (guideEditForm.type.value == 'video') {
                                  video = await picker.pickVideo(
                                      source: ImageSource.gallery);
                                  ref
                                      .read(guideAddImageVideoProvider.notifier)
                                      .setImageVideoType('video');
                                  if (video == null) {
                                    ref
                                        .read(
                                            guideAddImageVideoProvider.notifier)
                                        .setImageVideoError(
                                            'Error al seleccionar vídeo');
                                    return;
                                  }
                                } else {
                                  video = null;
                                }

                                ref
                                    .read(guideAddImageVideoProvider.notifier)
                                    .setImageVideoError('Sin errores');

                                if (image != null) {
                                  ref
                                      .read(guideAddImageVideoProvider.notifier)
                                      .onImageVideoChanged(image);
                                }
                                if (video != null) {
                                  ref
                                      .read(guideAddImageVideoProvider.notifier)
                                      .onImageVideoChanged(video);
                                }
                              },
                              child: Text(guideEditForm.type.value == 'image'
                                  ? 'Seleccionar imagen${guideAddArchive.file.value.name.isNotEmpty ? ' - ${guideAddArchive.file.value.name}' // Agregar el nombre del archivo al texto del botón
                                      : ''}'
                                  : guideEditForm.type.value == 'video'
                                      ? 'Seleccionar vídeo${guideAddArchive.file.value.name.isNotEmpty ? ' - ${guideAddArchive.file.value.name}' // Agregar el nombre del archivo al texto del botón
                                          : ''}'
                                      : 'Vuelve a seleccionar el tipo de archivo si quieres cambiar el archivo seleccionado'),
                            ),
                            Text(
                                guideAddArchive.error != 'Sin errores'
                                    ? guideAddArchive.error
                                    : '',
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: CustomFilledButton(
                                text: 'Editar',
                                onPressed: (guideEditForm.isPosting ||
                                        guideAddArchive.isPosting)
                                    ? null
                                    : () {
                                        if (guideAddArchive.error ==
                                            'Sin errores') {
                                          if (guideAddArchive.type ==
                                              guideEditForm.type.value) {
                                            if (!_isNameChanged) {
                                              ref
                                                  .read(guideEditFormProvider
                                                      .notifier)
                                                  .onNameChanged(guide.name);
                                            }
                                            if (!_isTypeChanged) {
                                              ref
                                                  .read(guideEditFormProvider
                                                      .notifier)
                                                  .onTypeChanged(guide.type);
                                            }
                                            if (!_isDescriptionChanged) {
                                              ref
                                                  .read(guideEditFormProvider
                                                      .notifier)
                                                  .onDescriptionChanged(
                                                      guide.description);
                                            }
                                            Future<bool> futureIsEdited = ref
                                                .read(guideEditFormProvider
                                                    .notifier)
                                                .onFormSubmit(
                                                    guide.id, category.id);
                                            futureIsEdited.then(
                                              (isEdited) async {
                                                if (isEdited) {
                                                  showSnackbar(context,
                                                      'Se ha editado la guía correctamente.');
                                                  List<Guide> guides = await ref
                                                      .read(guideProvider
                                                          .notifier)
                                                      .getAllGuidesByCategoryId(
                                                          category.id);
                                                  Guide guide =
                                                      guides[guides.length - 1];
                                                  Future<bool> futureIsAdded = ref
                                                      .read(
                                                          guideAddImageVideoProvider
                                                              .notifier)
                                                      .onFormSubmit(
                                                          guide.id, guide.type);
                                                  futureIsAdded.then(
                                                    (isAdded) {
                                                      showSnackbar(context,
                                                          'El archivo ha sido subido correctamente.');
                                                      context.pushReplacement(
                                                          '/category/${category.id}');
                                                    },
                                                  );
                                                }
                                              },
                                            );
                                          } else {
                                            ref
                                                .read(guideAddImageVideoProvider
                                                    .notifier)
                                                .setImageVideoError(
                                                    'El tipo de archivo seleccionado no corresponde con el tipo del archivo');
                                          }
                                        } else {
                                          ref
                                              .read(guideAddImageVideoProvider
                                                  .notifier)
                                              .setImageVideoError(
                                                  'Archivo no añadido');
                                        }
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
