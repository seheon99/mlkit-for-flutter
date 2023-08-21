class BlockFrame {
  int top;
  int bottom;
  int left;
  int right;

  BlockFrame(this.top, this.bottom, this.left, this.right);
  
  BlockFrame copyWith({
    int? top,
    int? bottom,
    int? left,
    int? right,
  }) {
    return BlockFrame(
      top ?? this.top,
      bottom ?? this.bottom,
      left ?? this.left,
      right ?? this.right,
    );
  }
}