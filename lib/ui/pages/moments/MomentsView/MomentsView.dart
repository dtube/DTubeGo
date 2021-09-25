import 'package:dtube_go/ui/pages/moments/MomentsView/MomentsItem.dart';
import 'package:dtube_go/ui/pages/moments/MomentsView/controller/MomentsController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart' show IterableExtension;

import 'package:flutter/material.dart';

class MomentsView extends StatefulWidget {
  final List<MomentsItem?> momentsItems;
  final VoidCallback? onComplete;
  final ValueChanged<MomentsItem>? onStoryShow;
  final bool repeat;
  final bool inline;
  final MomentsController controller;

  MomentsView({
    required this.momentsItems,
    required this.controller,
    this.onComplete,
    this.onStoryShow,
    this.repeat = false,
    this.inline = false,
  })  : assert(momentsItems != null && momentsItems.length > 0,
            "[momentsItems] should not be null or empty"),
        assert(
          repeat != null,
          "[repeat] cannot be null",
        ),
        assert(inline != null, "[inline] cannot be null");

  @override
  State<StatefulWidget> createState() {
    return MomentsViewState();
  }
}

class MomentsViewState extends State<MomentsView>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _currentAnimation;
  Timer? _nextDebouncer;

  StreamSubscription<PlaybackState>? _playbackSubscription;

  MomentsItem? get _currentStory {
    return widget.momentsItems.firstWhereOrNull((it) => !it!.shown);
  }

  Widget get _currentView {
    var item = widget.momentsItems.firstWhereOrNull((it) => !it!.shown);
    item ??= widget.momentsItems.last;
    return item?.view ?? Container();
  }

  @override
  void initState() {
    super.initState();
    final firstPage = widget.momentsItems.firstWhereOrNull((it) => !it!.shown);
    if (firstPage == null) {
      widget.momentsItems.forEach((it2) {
        it2!.shown = false;
      });
    } else {
      final lastShownPos = widget.momentsItems.indexOf(firstPage);
      widget.momentsItems.sublist(lastShownPos).forEach((it) {
        it!.shown = false;
      });
    }

    this._playbackSubscription =
        widget.controller.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.play:
          _removeNextHold();
          this._animationController?.forward();
          break;

        case PlaybackState.pause:
          _holdNext(); // then pause animation
          this._animationController?.stop(canceled: false);
          break;

        case PlaybackState.next:
          _removeNextHold();
          _goForward();
          break;

        case PlaybackState.previous:
          _removeNextHold();
          _goBack();
          break;
      }
    });

    _play();
  }

  @override
  void dispose() {
    _clearDebouncer();

    _animationController?.dispose();
    _playbackSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    _animationController?.dispose();
    // get the next playing page
    final momentsItem = widget.momentsItems.firstWhere((it) {
      return !it!.shown;
    })!;

    if (widget.onStoryShow != null) {
      widget.onStoryShow!(momentsItem);
    }

    _animationController =
        AnimationController(duration: momentsItem.duration, vsync: this);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        momentsItem.shown = true;
        if (widget.momentsItems.last != momentsItem) {
          _beginPlay();
        } else {
          // done playing
          _onComplete();
        }
      }
    });

    _currentAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    widget.controller.play();
  }

  void _beginPlay() {
    setState(() {});
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller.pause();
      widget.onComplete!();
    }

    if (widget.repeat) {
      widget.momentsItems.forEach((it) {
        it!.shown = false;
      });

      _beginPlay();
    }
  }

  void _goBack() {
    _animationController!.stop();

    if (this._currentStory == null) {
      widget.momentsItems.last!.shown = false;
    }

    if (this._currentStory == widget.momentsItems.first) {
      _beginPlay();
    } else {
      this._currentStory!.shown = false;
      int lastPos = widget.momentsItems.indexOf(this._currentStory);
      final previous = widget.momentsItems[lastPos - 1]!;

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (this._currentStory != widget.momentsItems.last) {
      _animationController!.stop();

      // get last showing
      final _last = this._currentStory;

      if (_last != null) {
        _last.shown = true;
        if (_last != widget.momentsItems.last) {
          _beginPlay();
        }
      }
    } else {
      // this is the last page, progress animation should skip to end
      _animationController!
          .animateTo(1.0, duration: Duration(milliseconds: 10));
    }
  }

  void _clearDebouncer() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _removeNextHold() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _holdNext() {
    _nextDebouncer?.cancel();
    _nextDebouncer = Timer(Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          _currentView,
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              bottom: widget.inline ? false : true,
              // we use SafeArea here for notched and bezeles phones
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 1,
                ),
                child: PageBar(
                  widget.momentsItems
                      .map((it) => PageData(it!.duration, it.shown))
                      .toList(),
                  this._currentAnimation,
                  key: UniqueKey(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageData {
  Duration duration;
  bool shown;

  PageData(this.duration, this.shown);
}

class PageBar extends StatefulWidget {
  final List<PageData> pages;
  final Animation<double>? animation;

  PageBar(
    this.pages,
    this.animation, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageBarState();
  }
}

class PageBarState extends State<PageBar> {
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.pages.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);

    widget.animation!.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isPlaying(PageData page) {
    return widget.pages.firstWhereOrNull((it) => !it.shown) == page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.pages.map((it) {
        return Expanded(
          child: Container(
            padding: EdgeInsets.only(
                right: widget.pages.last == it ? 0 : this.spacing),
            child: StoryProgressIndicator(
              isPlaying(it) ? widget.animation!.value : (it.shown ? 1 : 0),
              indicatorHeight: 5,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class StoryProgressIndicator extends StatelessWidget {
  final double value;
  final double indicatorHeight;

  StoryProgressIndicator(
    this.value, {
    this.indicatorHeight = 5,
  }) : assert(indicatorHeight != null && indicatorHeight > 0,
            "[indicatorHeight] should not be null or less than 1");

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        this.indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        Colors.white.withOpacity(0.8),
        this.value,
      ),
      painter: IndicatorOval(
        Colors.white.withOpacity(0.4),
        1.0,
      ),
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  IndicatorOval(this.color, this.widthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = this.color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * this.widthFactor, size.height),
            Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
