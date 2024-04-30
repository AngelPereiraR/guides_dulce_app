import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class CreateGuideScreen extends StatelessWidget {
  static const name = 'create-guide-screen';
  final int categoryId;

  const CreateGuideScreen({super.key, required this.categoryId});

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
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.article_outlined,
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
                        topLeft: Radius.circular(100),
                      ),
                    ),
                    child: _CreateGuideForm(categoryId),
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

class _CreateGuideForm extends ConsumerWidget {
  final int categoryId;
  const _CreateGuideForm(this.categoryId);

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideAddForm = ref.watch(guideAddFormProvider);
    final guideAddArchive = ref.watch(guideAddImageVideoProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;
    const borderRadius = Radius.circular(15);
    const padding = 15.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Crear guía', style: textStyles.titleLarge),
          const SizedBox(height: 50),
          CustomTextFormField(
            label: 'Nombre',
            keyboardType: TextInputType.multiline,
            onChanged: ref.read(guideAddFormProvider.notifier).onNameChanged,
            errorMessage: guideAddForm.isFormPosted
                ? guideAddForm.name.errorMessage
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
                  left: padding, bottom: padding, right: padding),
              decoration: InputDecoration(
                labelText: 'Tipo',
                errorText: guideAddForm.isFormPosted
                    ? guideAddForm.type.errorMessage
                    : null,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: borderRadius,
                bottomLeft: borderRadius,
                bottomRight: borderRadius,
              ),
              items: const [
                DropdownMenuItem(value: 'image', child: Text('Imagen')),
                DropdownMenuItem(value: 'video', child: Text('Vídeo')),
              ],
              onChanged: (String? newValue) {
                ref
                    .read(guideAddFormProvider.notifier)
                    .onTypeChanged(newValue ?? 'image');
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            onChanged:
                ref.read(guideAddFormProvider.notifier).onDescriptionChanged,
            errorMessage: guideAddForm.isFormPosted
                ? guideAddForm.description.errorMessage
                : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image;
              final XFile? video;
              if (guideAddForm.type.value == 'image') {
                image = await picker.pickImage(source: ImageSource.gallery);
                ref
                    .read(guideAddImageVideoProvider.notifier)
                    .setImageVideoType('image');
                if (image == null) {
                  ref
                      .read(guideAddImageVideoProvider.notifier)
                      .setImageVideoError('Error al seleccionar imagen');
                  return;
                }
              } else {
                image = null;
              }

              if (guideAddForm.type.value == 'video') {
                video = await picker.pickVideo(source: ImageSource.gallery);
                ref
                    .read(guideAddImageVideoProvider.notifier)
                    .setImageVideoType('video');
                if (video == null) {
                  ref
                      .read(guideAddImageVideoProvider.notifier)
                      .setImageVideoError('Error al seleccionar vídeo');
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
            child: Text(guideAddForm.type.value == 'image'
                ? 'Seleccionar imagen${guideAddArchive.file.value.name.isNotEmpty ? ' - ${guideAddArchive.file.value.name}' // Agregar el nombre del archivo al texto del botón
                    : ''}'
                : guideAddForm.type.value == 'video'
                    ? 'Seleccionar vídeo${guideAddArchive.file.value.name.isNotEmpty ? ' - ${guideAddArchive.file.value.name}' // Agregar el nombre del archivo al texto del botón
                        : ''}'
                    : 'Tipo no seleccionado'),
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
              text: 'Crear',
              onPressed: (guideAddForm.isPosting || guideAddArchive.isPosting)
                  ? null
                  : () {
                      if (guideAddArchive.error == 'Sin errores') {
                        if (guideAddArchive.type == guideAddForm.type.value) {
                          Future<bool> futureIsAdded = ref
                              .read(guideAddFormProvider.notifier)
                              .onFormSubmit(categoryId);
                          futureIsAdded.then(
                            (isAdded) async {
                              if (isAdded) {
                                showSnackbar(context,
                                    'La guía se ha creado correctamente.');
                                List<Guide> guides = await ref
                                    .read(guideProvider.notifier)
                                    .getAllGuidesByCategoryId(categoryId);
                                Guide guide = guides[guides.length - 1];
                                Future<bool> futureIsAdded = ref
                                    .read(guideAddImageVideoProvider.notifier)
                                    .onFormSubmit(guide.id, guide.type);
                                futureIsAdded.then(
                                  (isAdded) {
                                    showSnackbar(context,
                                        'El archivo ha sido subido correctamente.');
                                    context.pushReplacement(
                                        '/category/$categoryId');
                                  },
                                );
                              }
                            },
                          );
                        } else {
                          ref
                              .read(guideAddImageVideoProvider.notifier)
                              .setImageVideoError(
                                  'El tipo de archivo seleccionado no corresponde con el tipo del archivo');
                        }
                      } else {
                        ref
                            .read(guideAddImageVideoProvider.notifier)
                            .setImageVideoError('Archivo no añadido');
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
