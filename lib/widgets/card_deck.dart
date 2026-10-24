import 'package:flutter/material.dart';

import '../theme.dart';

/// Cards stacked like a slideshow. The next card peeks out behind the
/// current one; swipe to bring it forward. A button below gives the same
/// navigation for people who cannot swipe.
///
/// All cards get the height of the tallest card, so nothing is cut off.
class CardDeck extends StatefulWidget {
  final List<String> titles;
  final List<Widget> cards;

  const CardDeck({super.key, required this.titles, required this.cards})
      : assert(titles.length == cards.length);

  @override
  State<CardDeck> createState() => _CardDeckState();
}

class _CardDeckState extends State<CardDeck> {
  static const _peek = 12.0; // how far the card behind sticks out

  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The current scroll position, e.g. 0.4 while swiping from card 0 to 1.
  double get _page => _controller.hasClients && _controller.position.haveDimensions
      ? _controller.page!
      : _current.toDouble();

  void _goTo(int index) => _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

  @override
  Widget build(BuildContext context) {
    final isLast = _current == widget.cards.length - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => IntrinsicHeight(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Stack(
                fit: StackFit.expand,
                children: [
                  // Paint from the back of the deck to the front.
                  for (var i = widget.cards.length - 1; i >= 0; i--)
                    _positionedCard(i, constraints.maxWidth),
                  // An invisible PageView on top handles the swipe gesture.
                  Positioned.fill(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (index) => setState(() => _current = index),
                      children: [for (final _ in widget.cards) const SizedBox.expand()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < widget.cards.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 6),
                width: i == _current ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _current ? AppColors.green : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _goTo(isLast ? 0 : _current + 1),
                  iconAlignment: IconAlignment.end,
                  icon: Icon(isLast ? Icons.replay : Icons.chevron_right, size: 20),
                  label: Text(
                    isLast
                        ? 'Back to ${widget.titles.first}'
                        : 'Next: ${widget.titles[_current + 1]}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _positionedCard(int index, double width) {
    // 0 = front card, 1 = next card behind it, negative = already swiped away.
    final depth = index - _page;
    if (depth > 1.5) return const SizedBox.shrink();

    final Offset offset;
    final double scale;
    if (depth <= 0) {
      offset = Offset(depth * (width + _peek), 0); // slides off to the left
      scale = 1;
    } else {
      offset = Offset(depth * _peek, 0); // peeks out on the right
      scale = 1 - 0.06 * depth;
    }
    return Padding(
      padding: const EdgeInsets.only(right: _peek),
      child: Transform.translate(
        offset: offset,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.centerRight,
          child: Opacity(
            opacity: (1 - 0.35 * depth.clamp(0, 1)).toDouble(),
            child: ExcludeSemantics(excluding: index != _current, child: widget.cards[index]),
          ),
        ),
      ),
    );
  }
}
