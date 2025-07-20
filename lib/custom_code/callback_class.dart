class CallbackC {
  CallbackC(this.value, this.getValue);
  double value;

  Function(double) getValue;

  double printValue() => value;
}
