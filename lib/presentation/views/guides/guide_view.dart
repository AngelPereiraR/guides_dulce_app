import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guides_dulce_app/presentation/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/domain.dart';

class GuideView extends ConsumerStatefulWidget {
  final Guide guide;
  const GuideView(this.guide, {super.key});

  @override
  GuideViewState createState() => GuideViewState();
}

class GuideViewState extends ConsumerState<GuideView> {
  late VideoPlayerController? _controller;
  bool _isTapped = true;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    if (widget.guide.type == 'video') {
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.guide.url.replaceFirst('http', 'https')))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
        key: scaffoldKey,
        appBar: !_isFullScreen
            ? AppBar(
                title: Tooltip(
                    message: widget.guide.name,
                    child: Text(
                      widget.guide.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )),
              )
            : null,
        body: !_isFullScreen
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    if (widget.guide.type == 'image')
                      FutureBuilder(
                        future: Future.delayed(const Duration(milliseconds: 1)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 400,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Center(
                                child: Stack(
                              children: [
                                Image.network(
                                  widget.guide.url,
                                  height: 400,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.zoom_in_outlined,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isFullScreen = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    if (widget.guide.type == 'video')
                      _controller!.value.isInitialized
                          ? Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isTapped = !_isTapped;
                                    });
                                  },
                                  onDoubleTap: () {
                                    setState(() {
                                      if (_controller!.value.isPlaying) {
                                        _controller!.pause();
                                      } else {
                                        _controller!.play();
                                      }
                                    });
                                  },
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: AspectRatio(
                                            aspectRatio:
                                                _controller!.value.aspectRatio,
                                            child: VideoPlayer(_controller!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  left: 16,
                                  bottom: 20,
                                  child: _isTapped
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (_controller!
                                                  .value.isPlaying) {
                                                _controller!.pause();
                                              } else {
                                                _controller!.play();
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            _controller!.value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  left: 60,
                                  bottom: 20,
                                  child: _isTapped
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _controller!.seekTo(_controller!
                                                      .value.position -
                                                  const Duration(seconds: 5));
                                              _controller!.play();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.replay_5_outlined,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  left: 100,
                                  bottom: 20,
                                  child: _isTapped
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _controller!.seekTo(_controller!
                                                      .value.position +
                                                  const Duration(seconds: 5));
                                              _controller!.play();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.forward_5_outlined,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  left: 120,
                                  right: 50,
                                  bottom: 20,
                                  child: _isTapped
                                      ? VideoProgressIndicatorModified(
                                          _controller!,
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            playedColor: Colors.white,
                                            bufferedColor:
                                                Colors.grey.withOpacity(0.5),
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.2),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                        )
                                      : const SizedBox(),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  right: 16,
                                  bottom: 20,
                                  child: _isTapped
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isFullScreen = true;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.fullscreen,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            )
                          : const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Descripción:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.guide.description,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              )
            : widget.guide.type == 'image'
                ? Center(
                    child: Stack(
                      children: [
                        Image.network(
                          widget.guide.url,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.zoom_out_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isFullScreen = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : _controller!.value.aspectRatio > 1
                    ? _buildVideoPlayerHorizontal()
                    : _buildVideoPlayerVertical());
  }

  Widget _buildVideoPlayerVertical() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isTapped = !_isTapped;
            });
          },
          onDoubleTap: () {
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 16,
          bottom: 80,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (_controller!.value.isPlaying) {
                        _controller!.pause();
                      } else {
                        _controller!.play();
                      }
                    });
                  },
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 60,
          bottom: 80,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _controller!.seekTo(_controller!.value.position -
                          const Duration(seconds: 5));
                    });
                  },
                  icon: const Icon(
                    Icons.replay_5_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 100,
          bottom: 80,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _controller!.seekTo(_controller!.value.position +
                          const Duration(seconds: 5));
                    });
                  },
                  icon: const Icon(
                    Icons.forward_5_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 120,
          right: 50,
          bottom: 80,
          child: _isTapped
              ? VideoProgressIndicatorModified(
                  _controller!,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.white,
                    bufferedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: 16,
          bottom: 80,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isFullScreen = false;
                    });
                  },
                  icon: const Icon(
                    Icons.fullscreen_exit_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildVideoPlayerHorizontal() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isTapped = !_isTapped;
            });
          },
          onDoubleTap: () {
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 16,
          bottom: 20,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (_controller!.value.isPlaying) {
                        _controller!.pause();
                      } else {
                        _controller!.play();
                      }
                    });
                  },
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 60,
          bottom: 20,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _controller!.seekTo(_controller!.value.position -
                          const Duration(seconds: 5));
                    });
                  },
                  icon: const Icon(
                    Icons.replay_5_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 100,
          bottom: 20,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _controller!.seekTo(_controller!.value.position +
                          const Duration(seconds: 5));
                    });
                  },
                  icon: const Icon(
                    Icons.forward_5_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 130,
          right: 50,
          bottom: 20,
          child: _isTapped
              ? VideoProgressIndicatorModified(
                  _controller!,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.white,
                    bufferedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                )
              : const SizedBox(),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: 16,
          bottom: 20,
          child: _isTapped
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isFullScreen = false;
                    });
                  },
                  icon: const Icon(
                    Icons.fullscreen_exit_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
