class Item {
  double price; // 单价
  int count; //数量
  Item(this.price, this.count);

  @override
  String toString() {
    return 'Item{price: $price, count: $count}';
  }
}
