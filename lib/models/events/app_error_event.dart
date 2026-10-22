class AppErrorEvent {
  final dynamic error;
  const AppErrorEvent(this.error);

  @override
  String toString() => error.toString();
}
