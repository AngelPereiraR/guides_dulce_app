// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guides_dulce_app/domain/domain.dart';
import 'package:guides_dulce_app/presentation/screens/screens.dart';

import '../../providers/providers.dart';
import '../../views/views.dart';

class GuideScreen extends ConsumerStatefulWidget {
  static const name = 'guide-screen';
  final int guideId;
  final int categoryId;

  const GuideScreen({
    super.key,
    required this.guideId,
    required this.categoryId,
  });

  @override
  GuideScreenState createState() => GuideScreenState();
}

class GuideScreenState extends ConsumerState<GuideScreen> {
  late Guide guide;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getGuide();
  }

  Future<void> getGuide() async {
    final fetchedGuide =
        await ref.read(guideProvider.notifier).getGuide(widget.guideId);

    setState(() {
      guide = fetchedGuide;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }
    return WillPopScope(
      onWillPop: () async {
        context.pushReplacement('/category/${widget.categoryId}');
        return false;
      },
      child: Scaffold(
        body: GuideView(guide),
      ),
    );
  }
}
