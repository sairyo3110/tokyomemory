String formatPrice(String price) {
  if (price.contains('.')) {
    return price.split('.')[0]; // 小数点以下を取り除く
  }
  return price;
}
