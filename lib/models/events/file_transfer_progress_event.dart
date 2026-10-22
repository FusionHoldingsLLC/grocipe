class FileTransferProgressEvent {
  final num sent, total;
  final String tag;

  FileTransferProgressEvent(this.sent, this.total, this.tag);
}
