import 'dart:ui';

extension RectExtension on Rect {
  Rect copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Rect.fromLTRB(
      left ?? this.left,
      top ?? this.top,
      right ?? this.right,
      bottom ?? this.bottom,
    );
  }
}
