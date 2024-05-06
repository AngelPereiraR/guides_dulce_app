import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressIndicatorModified extends StatefulWidget {
  const VideoProgressIndicatorModified(
    this.controller, {
    super.key,
    this.colors = const VideoProgressColors(),
    required this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  });

  final VideoPlayerController controller;
  final VideoProgressColors colors;
  final bool allowScrubbing;
  final EdgeInsets padding;

  @override
  State<VideoProgressIndicatorModified> createState() =>
      _VideoProgressIndicatorModifiedState();
}

class _VideoProgressIndicatorModifiedState
    extends State<VideoProgressIndicatorModified> {
  late VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (final DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = Slider(
        min: 0.0,
        max: duration.toDouble(),
        value: position.toDouble(),
        onChanged: (value) {
          controller.seekTo(Duration(milliseconds: value.toInt()));
        },
        activeColor: colors.playedColor,
        inactiveColor: colors.bufferedColor,
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return VideoScrubber(
        controller: controller,
        child: paddedProgressIndicator,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}

class VideoScrubber extends StatelessWidget {
  final VideoPlayerController controller;
  final Widget child;

  const VideoScrubber({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final position = controller.value.position;
        final duration = controller.value.duration;
        final newPosition =
            position + Duration(seconds: details.primaryDelta!.round());
        if (newPosition < Duration.zero) {
          controller.seekTo(Duration.zero);
        } else if (newPosition > duration) {
          controller.seekTo(duration);
        } else {
          controller.seekTo(newPosition);
        }
      },
      child: child,
    );
  }
}
