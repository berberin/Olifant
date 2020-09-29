String fundToDisplay(double fund) {
  if (fund.abs() <= 9999) {
    return fund.toStringAsFixed(2);
  }
  if (fund.abs() > 9999 && fund.abs() <= 9999999) {
    return (fund / 1000).toStringAsFixed(2) + " k";
  }
  if (fund.abs() > 9999999 && fund.abs() <= 9999999999) {
    return (fund / 1000000).toStringAsFixed(3) + " M";
  }
  return (fund / 1000000000).toStringAsFixed(3) + " G";
}
