import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const name = 'login-screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: PopScope(
          canPop: false,
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
                          Icons.person_outline_rounded,
                          color: Colors.white,
                          size: 100,
                        ),
                        const Spacer(),
                        const SizedBox(width: 50),
                      ],
                    ),
                    const SizedBox(height: 120),
                    Container(
                      height: orientation == Orientation.portrait
                          ? size.height - 320
                          : size.height + 25,
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
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('Iniciar Sesión', style: textStyles.titleLarge),
            const SizedBox(height: 50),
            CustomTextFormField(
              label: 'Correo',
              keyboardType: TextInputType.emailAddress,
              onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
              errorMessage:
                  loginForm.isFormPosted ? loginForm.email.errorMessage : null,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Contraseña',
              obscureText: true,
              onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
              onFieldSubmitted: (_) =>
                  ref.read(loginFormProvider.notifier).onFormSubmit(),
              errorMessage: loginForm.isFormPosted
                  ? loginForm.password.errorMessage
                  : null,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                  text: 'Ingresar',
                  onPressed: loginForm.isPosting
                      ? null
                      : () {
                          Future<bool> futureIsLogged = ref
                              .read(loginFormProvider.notifier)
                              .onFormSubmit();
                          futureIsLogged.then((isLogged) {
                            if (isLogged) {
                              showSnackbar(context,
                                  'Se ha iniciado sesión correctamente.');
                              context.pushReplacement('/');
                            }
                          });
                        }),
            ),
          ],
        ),
      ),
    );
  }
}
