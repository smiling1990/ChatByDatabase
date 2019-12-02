/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:chatbydatabase/config/config.dart';


/// Created On 2019/12/2
/// Description: Custom Play Recording Slider
///
typedef SlideDragCallback = void Function(int percentage);

class CustomPlayRecordingSlider extends StatefulWidget {
  /// Width
  final double width;

  /// Height
  final double height;

  /// Padding
  final EdgeInsets padding;

  /// Color
  final Color positiveColor;
  final Color negativeColor;

  /// Text
  final TextStyle leftStyle;
  final TextStyle rightStyle;

  /// Icon
  final Color iconColor;

  /// Drag Call back
  final SlideDragCallback callback;

  /// URL, Path
  final String soundUrl;
  final int soundDuration; // Seconds

  CustomPlayRecordingSlider({
    Key key,
    this.width,
    this.height,
    this.padding,
    this.positiveColor,
    this.negativeColor,
    this.leftStyle,
    this.rightStyle,
    this.iconColor,
    this.callback,
    @required this.soundUrl,
    @required this.soundDuration,
  }) : super(key: key);

  @override
  _CustomPlayRecordingSliderState createState() =>
      _CustomPlayRecordingSliderState();
}

class _CustomPlayRecordingSliderState extends State<CustomPlayRecordingSlider> {
  /// Current
  int _curPercentage;

  /// Text
  String _leftText;
  String _rightText;
  bool _correctRightText; // Adjustment text

  /// Play
  FlutterSound _flutterSound;
  bool _isPlaying;
  StreamSubscription _playerSubscription;

  StreamSubscription _playListener;

  String _soundPath;

  @override
  void initState() {
    super.initState();
    _init();
    // Get local path
    _getLocalCachePath();
  }

  _init() {
    _curPercentage = 0;
    _flutterSound = FlutterSound();
    _isPlaying = false;
    _correctRightText = false;
    // Total duration
    if (widget.soundDuration > 0) {
      _rightText = _toTwo(widget.soundDuration);
    } else {
      _rightText = '00:00';
    }
  }

  /// Get local path
  _getLocalCachePath() async {

  }

  /// Play
  _startPlayer() async {

  }

  /// Update
  _updatePlayState() {

  }

  /// Stop
  _stopPlayer() async {

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding ?? EdgeInsets.only(left: 4.0, right: 12.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(top: 3.0),
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: widget.iconColor ?? Colors.white,
                size: 36.0,
              ),
              onPressed: () async {
                // Play Or Pause
                if (_isPlaying) {
                  await _stopPlayer();
                } else {
                  _startPlayer();
                }
              },
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        _leftText ?? '00:00',
                        style: widget.leftStyle ??
                            TextStyle(
                              color: Colors.white,
                              fontSize: Config.smallTextSize_2,
                            ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        _rightText ?? '00:00',
                        style: widget.rightStyle ??
                            TextStyle(
                              color: Colors.white,
                              fontSize: Config.smallTextSize_2,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 3.0,
                          color: widget.negativeColor ?? Colors.white,
                        ),
                        flex: _curPercentage,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.negativeColor ?? Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3.0,
                          color: widget.positiveColor ?? Colors.grey,
                        ),
                        flex: 100 - _curPercentage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        if (_isPlaying != null && !_isPlaying) {
          await _stopPlayer();
        }
        return Future.value(true);
      },
    );
  }

  /// 55 -- >> 00:55
  String _toTwo(int duration) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(duration);
    int m = date.minute;
    int s = date.second;
    String ms = m < 10 ? '0$m' : '$m';
    String ss = s < 10 ? '0$s' : '$s';
    return '$ms:$ss';
  }

  @override
  void dispose() {
    super.dispose();
    if (_playListener != null) _playListener.cancel();
    if (_playerSubscription != null) _playerSubscription.cancel();
  }
}
