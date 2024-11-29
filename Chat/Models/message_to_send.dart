 
class MessageToSend {
  final String type;
  final String? file;
  final String? content;
  final int uniqId;
    bool isError;
   MessageToSend({
    this.file,
    this.isError=false,
    required this.type,
    required this.uniqId,
      this.content,
  });
}
