import 'dart:async';

import 'package:flutter/material.dart';

/// Types each phrase one letter at a time, pauses, deletes it, then moves on
/// to the next phrase. If the phone's "remove animations" setting is on, it
/// simply shows the first phrase.
class TypewriterText extends StatefulWidget {
  final List<String> phrases;
  final TextStyle? style;

  const TypewriterText({super.key, required this.phrases, this.style});

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  static const _typeDelay = Duration(milliseconds: 70);
  static const _deleteDelay = Duration(milliseconds: 35);
  static const _pauseWhenTyped = Duration(milliseconds: 1600);
  static const _pauseWhenEmpty = Duration(milliseconds: 300);

  Timer? _timer;
  int _phrase = 0; // which phrase is showing
  int _length = 0; // how many letters of it are visible
  bool _deleting = false;
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _timer?.cancel();
      _timer = null;
    } else {
      _timer ??= Timer(_typeDelay, _tick);
    }
  }

  void _tick() {
    final phrase = widget.phrases[_phrase];
    setState(() => _length += _deleting ? -1 : 1);

    Duration next;
    if (!_deleting && _length == phrase.length) {
      _deleting = true;
      next = _pauseWhenTyped;
    } else if (_deleting && _length == 0) {
      _deleting = false;
      _phrase = (_phrase + 1) % widget.phrases.length;
      next = _pauseWhenEmpty;
    } else {
      next = _deleting ? _deleteDelay : _typeDelay;
    }
    _timer = Timer(next, _tick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _reduceMotion
        ? widget.phrases.first
        : widget.phrases[_phrase].substring(0, _length);
    // Screen readers hear the first phrase instead of every letter changing.
    return Semantics(
      label: widget.phrases.first,
      child: ExcludeSemantics(
        child: Text(text, style: widget.style, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
