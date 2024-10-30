import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_constants.dart';


/// [ExpandableBottomSheet] is a BottomSheet with a draggable height like the
/// Google Maps App on Android.
///
/// __Example:__
///
/// ```dart
/// ExpandableBottomSheet(
///   background: Container(
///     color: Colors.red,
///     child: Center(
///       child: Text('Background'),
///     ),
///   ),
///   persistentHeader: Container(
///     height: 40,
///     color: Colors.blue,
///     child: Center(
///       child: Text('Header'),
///     ),
///   ),
///   expandableContent: Container(
///     height: 500,
///     color: Colors.green,
///     child: Center(
///       child: Text('Content'),
///     ),
///   ),
/// );
/// ```
class ExpandableBottomSheet extends StatefulWidget {


  /// [expandableContent] is the widget which you can hide and show by dragging.
  /// It has to be a widget with a constant height. It is required for the [ExpandableBottomSheet].
  final Widget expandableContent;

  /// [background] is the widget behind the [expandableContent] which holds
  /// usually the content of your page. It is required for the [ExpandableBottomSheet].
  final Widget background;

  final Widget lowerLeftFloatingButtons;

  final Widget lowerRightFloatingButtons;

  final Widget upperLeftFloatingButtons;

  final Widget upperRightFloatingButtons;

  final Widget topBar;

  @Deprecated(
      ''' Your header widget should be part of `expandableContent`. Then you set the height of your header widget to `persistentContentHeight`.
  This will be removed in version 2.0.0.
  ''')

  /// [persistentHeader] is a Widget which is on top of the [expandableContent]
  /// and will never be hidden. It is made for a widget which indicates the
  /// user he can expand the content by dragging.
  final Widget? persistentHeader;

  @Deprecated(
      ''' The persistentFooter should not be part of the ExpandableBottomSheet. Rather define it outside of ExpandableBottomSheet.
  This will be removed in version 2.0.0.
  ''')

  /// [persistentFooter] is a widget which is always shown at the bottom. The [expandableContent]
  /// is if it is expanded on top of it so you don't need margin to see all of
  /// your content. You can use it for example for navigation or a menu.
  final Widget? persistentFooter;

  /// [persistentContentHeight] is the height of the content which will never
  /// been contracted. It only relates to [expandableContent]. [persistentHeader]
  /// and [persistentFooter] will not be affected by this.
  final double persistentContentHeight;

  /// This refers to the bottom sheet's initial position in a 0 to 1 span.
  final double initialPos;

  /// [animationDurationExtend] is the duration for the animation if you stop
  /// dragging with high speed.
  final Duration animationDurationExtend;

  /// [animationDurationContract] is the duration for the animation to bottom
  /// if you stop dragging with high speed. If it is `null` [animationDurationExtend] will be used.
  final Duration animationDurationContract;

  /// [animationCurveExpand] is the curve of the animation for expanding
  /// the [expandableContent] if the drag ended with high speed.
  final Curve animationCurveExpand;

  /// [animationCurveContract] is the curve of the animation for contracting
  /// the [expandableContent] if the drag ended with high speed.
  final Curve animationCurveContract;

  /// [onIsExtendedCallback] will be executed if the extend reaches its maximum.
  final Function()? onIsExtendedCallback;

  /// [onIsContractedCallback] will be executed if the extend reaches its minimum.
  final Function()? onIsContractedCallback;

  /// [enableToggle] will enable tap to toggle option on header.
  final bool enableToggle;

  /// [initialDraggableState] will make the [ExpandableBottomSheet] draggable by the user or not.
  final bool initialDraggableState;

  /// [isLazyModeEnabled] will make the [ExpandableBottomSheet] lazy
  final bool isLazyModeEnabled;

  /// The [ExpandableBottomSheet] will never be able to expand upon this value (0 to 1)
  final double initialMaxExpandableHeight;

  /// The [ExpandableBottomSheet] will never be able to expand under this value (0 to 1)
  final double initialMinExpandableHeight;

  /// Creates the [ExpandableBottomSheet].
  ///
  /// [persistentContentHeight] has to be greater 0.
  const ExpandableBottomSheet({
    Key? key,
    required this.expandableContent,
    required this.background,
    required this.lowerLeftFloatingButtons,
    required this.lowerRightFloatingButtons,
    required this.topBar,
    this.persistentHeader,
    this.persistentFooter,
    this.persistentContentHeight = 0.0,
    this.animationCurveExpand = Curves.ease,
    this.animationCurveContract = Curves.ease,
    this.animationDurationExtend = const Duration(milliseconds: 250),
    this.animationDurationContract = const Duration(milliseconds: 250),
    this.onIsExtendedCallback,
    this.onIsContractedCallback,
    this.enableToggle = false,
    this.initialDraggableState = true,
    this.isLazyModeEnabled = false,
    this.initialPos = 1.0,
    this.initialMaxExpandableHeight = 1.0,
    this.initialMinExpandableHeight = 1.0,
    required this.upperLeftFloatingButtons,
    required this.upperRightFloatingButtons,
  })  : assert(persistentContentHeight >= 0),
        super(key: key);

  @override
  ExpandableBottomSheetState createState() => ExpandableBottomSheetState();
}

class ExpandableBottomSheetState extends State<ExpandableBottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'contentKey');
  final GlobalKey _headerKey = GlobalKey(debugLabel: 'headerKey');
  final GlobalKey _footerKey = GlobalKey(debugLabel: 'footerKey');

  late AnimationController _controller;

  /// Listens for the sheetPosition
  final _sheetPosition = ValueNotifier<SheetPositionPair>(SheetPositionPair(sheetPosition: 0.0, gSheetPosition: 0.0));

  double _draggableHeight = 0;
  double? _positionOffset;
  double _startOffsetAtDragDown = 0;
  double? _startPositionAtDragDown = 0;
  double _maxExpandableHeight = 1.0;

  double _minDraggableOffset = 0;
  double _maxDraggableOffset = 0;
  double _maxOffset = 0;
  double _minOffset = 0;
  bool _isDraggable = true;
  bool _isLazyDrag = true;
  double _onGoingPosOffset = 0;
  double _newOpacity = 0.0;


  double _animationMinOffset = -1.0;

  AnimationStatus _oldStatus = AnimationStatus.dismissed;

  bool _useDrag = true;
  bool _callCallbacks = false;

  /// Setter for maxDraggableOffset
  void setMinExpandableHeight(double newMax){
    if(newMax <= 1.0 && newMax >= 0.0){
      setState(() {
        _maxDraggableOffset = newMax;
      });
    }
  }

  /// Setter for isLazyDrag
  // void is(double newMax){
  //   if(newMax <= 1.0 && newMax >= 0.0){
  //     setState(() {
  //       _maxDraggableOffset = newMax;
  //     });
  //   }
  // }



  /// Setter for max expandable height :
  void setMaxExpandableHeight({required double newMax, Function? updateMax, double? animateTo}) {

      if(newMax > _maxExpandableHeight){

      setState(() {
        _maxExpandableHeight = newMax;
      });
      // double newVal = 1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset));
      //
      // _sheetPosition.value = SheetPositionPair(sheetPosition: newVal, gSheetPosition: newVal * _maxExpandableHeight);

      // _sheetPosition.value = SheetPositionPair(sheetPosition: _sheetPosition.value.sheetPosition, gSheetPosition: _sheetPosition.value.sheetPosition * _maxExpandableHeight);
      debugPrint("We were there");

      updateMax!();
      animateToPos(animateTo ?? newMax / _maxExpandableHeight, (){});

    }else{

      animateToPos(animateTo ?? newMax / _maxExpandableHeight, (){
      setState(() {
        _maxExpandableHeight = newMax;
      });
      double newVal = 1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset));

      _sheetPosition.value = SheetPositionPair(sheetPosition: newVal, gSheetPosition: newVal * _maxExpandableHeight);
      debugPrint("We were here : ${_sheetPosition.value}");
      updateMax!();

    });

    }

  }



  /// Expands the content of the widget.
  void expand() {
    _afterUpdateWidgetBuild(false);
    _callCallbacks = true;
    _animateToTop();
  }

  /// Contracts the content of the widget.
  void contract() {
    _afterUpdateWidgetBuild(false);
    _callCallbacks = true;
    _animateToBottom();
  }

  /// Animates to a specific position. pos should be between 0 and 1
  void animateToPos(double pos, Function? then) {
    _afterUpdateWidgetBuild(false);
    _callCallbacks = true;
    if(pos <= 1.0 && pos >= 0.0){
      _animateOnIsAnimating();

      // Une méthode pour convertir de sheetPos a gsheetPos ne serait pa de trop sinon tu risque de ne plus comprendre ton code !!!
      double finalPos = pos * _maxExpandableHeight < _maxDraggableOffset ? _maxDraggableOffset / _maxExpandableHeight : pos;

      _controller.value = (_positionOffset! - _minDraggableOffset) / _draggableHeight;
      _animationMinOffset = _minDraggableOffset;
      // _oldStatus = AnimationStatus.reverse;
      _oldStatus = finalPos < 0.5 ? AnimationStatus.reverse : AnimationStatus.forward;
      _onGoingPosOffset = finalPos == 0 ? _maxOffset : finalPos == 1 ? _minDraggableOffset : _maxOffset + (finalPos * (_minDraggableOffset - _maxOffset));

      _controller.addListener(() {
        // Calculate value
        double value = 1.0 - (_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset);

        // Update position
        debugPrint("New Opacity :" + _newOpacity.toString());
        _sheetPosition.value = SheetPositionPair(sheetPosition: double.parse(value.toStringAsFixed(2)), gSheetPosition: double.parse(value.toStringAsFixed(2)) * _maxExpandableHeight);
      });

      if(then != null){


      _controller.animateTo(
        // We reverse it back
        1.0 - finalPos,
        duration: widget.animationDurationContract,
        curve: widget.animationCurveContract,
      ).then((value) => then());

      }else{

        _controller.animateTo(
          // We reverse it back
          1.0 - finalPos,
          duration: widget.animationDurationContract,
          curve: widget.animationCurveContract,
        );

      }

      _controller.removeListener(() {
        // remove when done
      });
    }

  }


  /// The status of the expansion.
  ExpansionStatus get expansionStatus {
    if (_positionOffset == null) return ExpansionStatus.contracted;
    if (_positionOffset == _maxOffset) return ExpansionStatus.contracted;
    if (_positionOffset == _minDraggableOffset) return ExpansionStatus.expanded;
    return ExpansionStatus.middle;
  }

  /// The current sheet position.
  ValueNotifier<SheetPositionPair> get sheetPosition => _sheetPosition;

  /// The current maxExpandableHeight
  double get maxExpandableHeight => _maxExpandableHeight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _controller.addStatusListener(_handleAnimationStatusUpdate);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _afterUpdateWidgetBuild(true));
    _maxExpandableHeight = widget.initialMaxExpandableHeight;
    _maxDraggableOffset = widget.initialMinExpandableHeight;
    // Je doute que la valeur que tu as passée à sheetPosition soit valide ici mais on teste pour voir
    _sheetPosition.value = SheetPositionPair(sheetPosition: widget.initialPos, gSheetPosition: widget.initialPos * _maxExpandableHeight);

  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _afterUpdateWidgetBuild(false));
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[


              Align(
                alignment: Alignment.topLeft,
                child: RepaintBoundary(child: widget.background),
              ),

              Positioned(
                right: 20.0,
                top: 85.0 + MediaQuery.of(context).padding.top,
                // duration: const Duration(milliseconds: 200),
                child: RepaintBoundary(child: widget.upperRightFloatingButtons),
              ),
              Positioned(
                left: 20.0,
                top: 85.0 + MediaQuery.of(context).padding.top,
                // duration: const Duration(milliseconds: 200),
                child: RepaintBoundary(child: widget.upperLeftFloatingButtons),
              ),
              if(_positionOffset != null && _positionOffset! >= _maxOffset/2 - 60)...[
                AnimatedPositioned(
                  left: 20.0,
                  top:  _positionOffset! <= _maxOffset/2 ? _maxOffset/2 : _positionOffset! - 130,
                  duration: const Duration(milliseconds: 200),
                  child: RepaintBoundary(child: widget.lowerLeftFloatingButtons),
                ),
                AnimatedPositioned(
                  right: 20.0,
                  top: _positionOffset! <= _maxOffset/2 ? _maxOffset/2 : _positionOffset! - 130,
                  duration: const Duration(milliseconds: 200),
                  child: RepaintBoundary(child: widget.lowerRightFloatingButtons),
                ),
              ],

              AnimatedBuilder(
                animation: _controller,
                builder: (_, Widget? child) {
                  if (_controller.isAnimating) {
                    _positionOffset = _animationMinOffset +
                        _controller.value * _draggableHeight;

                    // if(_positionOffset! >= 500){
                    // }
                  }
                  return Positioned(
                    top: _positionOffset,
                    right: 0.0,
                    left: 0.0,
                    child: child!,
                  );
                },

                child: RepaintBoundary(
                  child: GestureDetector(
                    onTap: _toggle,
                    onVerticalDragDown: widget.initialDraggableState ? _dragDown : (_) {},
                    onVerticalDragUpdate: widget.initialDraggableState ? _dragUpdate : (_) {},
                    onVerticalDragEnd: widget.initialDraggableState ? _dragEnd : (_) {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        AnimatedBuilder(
                          animation: _controller,
                          builder: (_, Widget? child) {
                            return Container(
                                key: _headerKey,
                                child: widget.persistentHeader ?? Container(
                                  constraints: const BoxConstraints(maxHeight: 38),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular( (1.0 - _newOpacity) * 30), topRight: Radius.circular((1.0 - _newOpacity) * 30)),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 1.5),
                                            color: Colors.grey.withOpacity((1.0 - _newOpacity).clamp(0.0, 0.7)))
                                      ]
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Container(
                                          height: 4.0,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryText.withOpacity((1.0 - _newOpacity).clamp(0.0, 0.5)),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                        Container(
                          key: _contentKey,
                          child: widget.expandableContent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              AnimatedBuilder(
                  animation: _sheetPosition,
                  builder: (_, Widget? child) {

                    // if(sheetPosition.value.gSheetPosition >= 0.7){
                    //   _newOpacity = 1.0;
                    // }else {
                    //   _newOpacity = _newOpacity.clamp(0.0, 1.0);
                    // }
                    debugPrint("n side : " + sheetPosition.value.gSheetPosition.toString());
                    debugPrint("o side : " + (1.0 - ((1.0 - sheetPosition.value.gSheetPosition) / 0.3).clamp(0.0, 1.0)).toString());
                    _newOpacity =  1.0 - ((1.0 - sheetPosition.value.gSheetPosition) / 0.3).clamp(0.0, 1.0);

                    // if(_positionOffset != null){

                      // if (_positionOffset! >= _minDraggableOffset + 0.7 * (_maxOffset - _minDraggableOffset)) {
                      //   _newOpacity = 1.0;
                      // } else {
                      //   _newOpacity = (_positionOffset! - _minDraggableOffset) / (0.3 * (_maxOffset - _minDraggableOffset));
                      //   _newOpacity = _newOpacity.clamp(0.0, 1.0); // Assure que newOpacity reste entre 0.0 et 1.0
                      // }

                    // }


                  // double newOpacity = (1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset))) * maxExpandableHeight;
                  return Align(
                      alignment: Alignment.topCenter,
                      child: RepaintBoundary(
                        child: Stack(children: [
                          Container(
                            height: 100,
                            color: Colors.white.withOpacity(_newOpacity),
                          ),
                          if(widget != null) ...[
                            child!
                          ]
                        ]),
                      ),
                    );
                  },
                  child: RepaintBoundary(child: widget.topBar)
              ),

            ],
          ),
        ),
        Container(
            key: _footerKey, child: widget.persistentFooter ?? Container()),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant ExpandableBottomSheet oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(widget.expandableContent != oldWidget.expandableContent){
      // Nous ne sommes pas entré dans cette condition et tu dois trouver why.
    }

  }

  void _handleAnimationStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_oldStatus == AnimationStatus.forward) {
        setState(() {
          _draggableHeight = _maxOffset - _minDraggableOffset;
          _positionOffset = _onGoingPosOffset != -1 ? _onGoingPosOffset : _minDraggableOffset;
          double newVal = 1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset));
          _sheetPosition.value = SheetPositionPair(sheetPosition: newVal, gSheetPosition: newVal * _maxExpandableHeight);

        });
        if (widget.onIsExtendedCallback != null && _callCallbacks) {
          widget.onIsExtendedCallback!();
        }
      }
      if (_oldStatus == AnimationStatus.reverse) {
        setState(() {
          _draggableHeight = _maxOffset - _minDraggableOffset;
          _positionOffset = _onGoingPosOffset != -1 ? _onGoingPosOffset : getOffsetFromIndice(_maxDraggableOffset,true);
          double newVal = 1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset));
          _sheetPosition.value = SheetPositionPair(sheetPosition: newVal, gSheetPosition: newVal * _maxExpandableHeight);

        });
        if (widget.onIsContractedCallback != null && _callCallbacks) {
          widget.onIsContractedCallback!();
        }
      }
    }
  }

  void _afterUpdateWidgetBuild(bool isFirstBuild) {
    double headerHeight = _headerKey.currentContext!.size!.height;
    double footerHeight = _footerKey.currentContext!.size!.height;
    double contentHeight = _contentKey.currentContext!.size!.height;

    double checkedPersistentContentHeight =
    (widget.persistentContentHeight < contentHeight)
        ? widget.persistentContentHeight
        : contentHeight;

    _minOffset = context.size!.height - headerHeight - contentHeight - footerHeight;
    _minDraggableOffset = context.size!.height - headerHeight - (_maxExpandableHeight * (AppConstants.screenHeight - 130)) - footerHeight;
    _maxOffset = context.size!.height -
        headerHeight -
        footerHeight -
        checkedPersistentContentHeight;

    double checkedInitialPos = widget.initialPos <= 1 && widget.initialPos >= 0 ? _minDraggableOffset + ((1.0 - widget.initialPos) * (_maxOffset - _minDraggableOffset)) : _minDraggableOffset;

    if (!isFirstBuild) {
      _positionOutOfBounds();
    } else {
      setState(() {
        _positionOffset = checkedInitialPos;
        // double newVal = 1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset));
        // _sheetPosition.value = SheetPositionPair(sheetPosition: newVal, gSheetPosition: newVal * _maxExpandableHeight);

        // sheetPosition.value = SheetPositionPair(sheetPosition: sheetPosition, gSheetPosition: gSheetPosition),
        _draggableHeight = _maxOffset - _minDraggableOffset;
      });
    }
  }

  void _positionOutOfBounds() {
    if (_positionOffset! < _minDraggableOffset) {
      //the extend is larger than contentHeight
      _callCallbacks = false;
      _animateToMin();
    } else {
      if (_positionOffset! > _maxOffset) {
        //the extend is smaller than persistentContentHeight
        _callCallbacks = false;
        _animateToMax();
      } else {
        _draggableHeight = _maxOffset - _minDraggableOffset;
      }
    }
  }

  void _animateOnIsAnimating() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  void _toggle() {
    if (widget.enableToggle) {
      if (expansionStatus == ExpansionStatus.expanded) {
        _callCallbacks = true;
        _animateToBottom();
      }
      if (expansionStatus == ExpansionStatus.contracted) {
        _callCallbacks = true;
        _animateToTop();
      }
    }
  }

  void _dragDown(DragDownDetails details) {
    if (_controller.isAnimating) {
      _useDrag = false;
    } else {
      _useDrag = true;
      _startOffsetAtDragDown = details.localPosition.dy;
      _startPositionAtDragDown = _positionOffset;
    }
  }

  void _dragUpdate(DragUpdateDetails details) {

    if(_isLazyDrag){
        if (!_useDrag) return;
        double offset = details.localPosition.dy;
        double newOffset = _startPositionAtDragDown! + offset - _startOffsetAtDragDown;
        double headerHeight = _headerKey.currentContext!.size!.height;
        double footerHeight = _footerKey.currentContext!.size!.height;
        // double contentHeight = _contentKey.currentContext!.size!.height;

        double newMaxOffset = context.size!.height -
            headerHeight -
            footerHeight - (AppConstants.screenHeight - 130) * _maxDraggableOffset;

        // if(_sheetPosition.value.gSheetPosition > _maxDraggableOffset){

        if(widget.isLazyModeEnabled){

          if (_minDraggableOffset <= newOffset && _maxOffset >= newOffset) {

            setState(() {
              _positionOffset = newOffset;
            });

          } else {
            if (_minDraggableOffset > newOffset) {
              setState(() {
                _positionOffset = _minDraggableOffset;
              });
            }
            if (_maxOffset < newOffset) {
              setState(() {
                _positionOffset = _maxOffset;
              });
            }
          }

        }else{

          if (_minDraggableOffset <= newOffset && newMaxOffset >= newOffset) {

            setState(() {
              _positionOffset = newOffset;
            });
          } else {
            if (_minDraggableOffset > newOffset) {
              setState(() {
                _positionOffset = _minDraggableOffset;
              });
            }
            if (newMaxOffset < newOffset) {
              setState(() {
                _positionOffset = newMaxOffset;
              });
            }
          }

        }

        double value = 1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset));
        _sheetPosition.value = SheetPositionPair(sheetPosition: double.parse(value.toStringAsFixed(2)), gSheetPosition: double.parse(value.toStringAsFixed(2)) * _maxExpandableHeight);
        // print(_sheetPosition);

    }else{

    if (!_useDrag) return;
    double offset = details.localPosition.dy;
    double newOffset = _startPositionAtDragDown! + offset - _startOffsetAtDragDown;
    double headerHeight = _headerKey.currentContext!.size!.height;
    double footerHeight = _footerKey.currentContext!.size!.height;
    // double contentHeight = _contentKey.currentContext!.size!.height;

    double newMaxOffset = context.size!.height -
        headerHeight -
        footerHeight - (AppConstants.screenHeight - 130) * _maxDraggableOffset;

    if(_sheetPosition.value.gSheetPosition > _maxDraggableOffset){

    if(widget.isLazyModeEnabled){

        if (_minDraggableOffset <= newOffset && _maxOffset >= newOffset) {
          setState(() {
            _positionOffset = newOffset;
          });
        }
        } else {
            if (_minDraggableOffset > newOffset) {
              setState(() {
                _positionOffset = _minDraggableOffset;
              });
            }
            if (_maxOffset < newOffset) {
              setState(() {
                _positionOffset = _maxOffset;
              });
            }
          }

    }else{

      if (_minDraggableOffset <= newOffset && newMaxOffset >= newOffset) {

        setState(() {
          _positionOffset = newOffset;
        });
      } else {
        if (_minDraggableOffset > newOffset) {
          setState(() {
            _positionOffset = _minDraggableOffset;
          });
        }
        if (newMaxOffset < newOffset) {
            setState(() {
              _positionOffset = newMaxOffset;
            });
          }
      }

    }

    double value = 1.0 - ((_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset));
    _sheetPosition.value = SheetPositionPair(sheetPosition: double.parse(value.toStringAsFixed(2)), gSheetPosition: double.parse(value.toStringAsFixed(2)) * _maxExpandableHeight);
    // print(_sheetPosition);

    }

  }

  void _dragEnd(DragEndDetails details) {
    // print("called when drag ends");
    if (_startPositionAtDragDown == _positionOffset || !_useDrag) return;
    if(widget.isLazyModeEnabled){

      // Don't forget, _minPos is actually the highest border and _maxPos the lowest border.
      double mid = lerpDouble(_minDraggableOffset, getOffsetFromIndice(_maxDraggableOffset,false), 0.5)!;
      // print(mid);
      if(_positionOffset! < mid){
        _callCallbacks = true;
        _animateToTop();
      }else{
        _callCallbacks = true;
        _animateToBottom();
      }
    }

    if (details.primaryVelocity! < -250) {
      //drag up ended with high speed
      _callCallbacks = true;
      _animateToTop();
    } else {
      if (details.primaryVelocity! > 250) {
        //drag down ended with high speed
        _callCallbacks = true;
        _animateToBottom();
      } else {
        if (_positionOffset == _maxOffset &&
            widget.onIsContractedCallback != null) {
          widget.onIsContractedCallback!();
        }
        if (_positionOffset == _minDraggableOffset &&
            widget.onIsExtendedCallback != null) {
          widget.onIsExtendedCallback!();
        }
      }
    }
  }

  void _animateToTop() {
    _animateOnIsAnimating();
    _controller.value = (_positionOffset! - _minDraggableOffset) / _draggableHeight;
    _animationMinOffset = _minDraggableOffset;
    _oldStatus = AnimationStatus.forward;
    _onGoingPosOffset = _minDraggableOffset;

    _controller.addListener(() {

      // Update position
      _sheetPosition.value = SheetPositionPair(sheetPosition: 1.0, gSheetPosition: 1.0 * _maxExpandableHeight);
    });

    _controller.animateTo(
      0.0,
      duration: widget.animationDurationExtend,
      curve: widget.animationCurveExpand,
    );

    _controller.removeListener(() {
      // remove when done
    });


  }

  void _animateToBottom() {
    _animateOnIsAnimating();

    double finalPos = 0.0;
    if (_maxExpandableHeight != 0) {
      finalPos = _maxDraggableOffset / _maxExpandableHeight;
    }

    _controller.value = (_positionOffset! - _minDraggableOffset) / _draggableHeight;
    _animationMinOffset = _minDraggableOffset;
    _oldStatus = finalPos < 0.5 ? AnimationStatus.reverse : AnimationStatus.forward;
    _onGoingPosOffset = finalPos == 0.0 ? _maxOffset : finalPos == 1.0 ? _minDraggableOffset : _maxOffset + (finalPos * (_minDraggableOffset - _maxOffset));

    _controller.addListener(() {
      double value = 1.0 - (_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset);
      _sheetPosition.value = SheetPositionPair(sheetPosition: value, gSheetPosition: value * _maxExpandableHeight);
    });

    _controller.animateTo(
      1.0 - finalPos,
      duration: widget.animationDurationContract,
      curve: widget.animationCurveContract,
    );
  }


  // void _animateToBottom() {
  //
  //     _animateOnIsAnimating();
  //
  //     // Une méthode pour convertir de sheetPos a gsheetPos ne serait pa de trop sinon tu risque de ne plus comprendre ton code !!!
  //     double finalPos = 0 * _maxExpandableHeight < _maxDraggableOffset ? _maxDraggableOffset / _maxExpandableHeight : 0;
  //
  //     _controller.value = (_positionOffset! - _minDraggableOffset) / _draggableHeight;
  //     _animationMinOffset = _minDraggableOffset;
  //     // _oldStatus = AnimationStatus.reverse;
  //     _oldStatus = finalPos < 0.5 ? AnimationStatus.reverse : AnimationStatus.forward;
  //     _onGoingPosOffset = finalPos == 0 ? _maxOffset : finalPos == 1 ? _minDraggableOffset : _maxOffset + (finalPos * (_minDraggableOffset - _maxOffset));
  //
  //     _controller.addListener(() {
  //       // Calculate value
  //       double value = 1.0 - (_positionOffset! - _minDraggableOffset) / (_maxOffset - _minDraggableOffset);
  //
  //       // Update position
  //       _sheetPosition.value = SheetPositionPair(sheetPosition: double.parse(value.toStringAsFixed(2)), gSheetPosition: double.parse(value.toStringAsFixed(2)) * _maxExpandableHeight);
  //     });
  //
  //     _controller.animateTo(
  //       // We reverse it back
  //       1.0 - finalPos,
  //       duration: widget.animationDurationContract,
  //       curve: widget.animationCurveContract,
  //     );
  //
  //     _controller.removeListener(() {
  //       // remove when done
  //     });
  //
  // }

  void _animateToMax() {
    _animateOnIsAnimating();

    _controller.value = 1.0;
    _draggableHeight = _positionOffset! - _maxOffset;
    _animationMinOffset = _maxOffset;
    _oldStatus = AnimationStatus.reverse;
    _onGoingPosOffset = _maxOffset;

    _controller.animateTo(
      0.0,
      duration: widget.animationDurationExtend,
      curve: widget.animationCurveExpand,
    );
  }

  void _animateToMin() {
    _animateOnIsAnimating();

    _controller.value = 1.0;
    _draggableHeight = _positionOffset! - _minDraggableOffset;
    _animationMinOffset = _minDraggableOffset;
    _oldStatus = AnimationStatus.forward;
    _controller.animateTo(
      0.0,
      duration: widget.animationDurationContract,
      curve: widget.animationCurveContract,
    );
  }

  double getOffsetFromIndice(double value, bool isGlobal){

    if(value <= 1.0 && value >= 0.0){
      double newPositionOffset = _minDraggableOffset + (_maxOffset - _minDraggableOffset) * (1.0 - value);
      if(isGlobal){
        return newPositionOffset * _maxExpandableHeight;
      }else{
        return newPositionOffset;
      }
    }else{
      return -1;
    }
  }

  // double getIndiceFromOffset(double value, bool isGlobal){
  //
  //   if(value <= AppConstants.screenHeight - 130 && value >= 0.0){
  //     double newPositionIndice = 1.0 - (value - _minDraggableOffset) / (_maxOffset - _minDraggableOffset);
  //     if(isGlobal){
  //       return newPositionIndice / _maxExpandableHeight;
  //     }else{
  //       return newPositionIndice;
  //     }
  //   }else{
  //     return -1;
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


/// The status of the expandable content.
enum ExpansionStatus {
  expanded,
  middle,
  contracted,
}

class SheetPositionPair {
  final double sheetPosition;
  final double gSheetPosition;

  SheetPositionPair({required this.sheetPosition, required this.gSheetPosition});

  @override
  String toString() {
    return 'SheetPositionPair{sheetPosition: $sheetPosition, gSheetPosition: $gSheetPosition}';
  }
}

