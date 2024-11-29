import 'package:azwijn/constants/app_colors.dart';
import 'package:azwijn/data/Chat/Model/message.dart';
import 'package:azwijn/data/Chat/Provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ReportDialog extends StatelessWidget {
  ReportDialog({
    super.key,
    required this.chatProvider,
    required this.message,
  });
  final ChatProvider chatProvider;
  final Message message;

  final GlobalKey<FormState> validateKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    bool closeDialog = false;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      contentPadding: const EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'هل أنت متأكد من الإبلاغ عن هذه الرسالة؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3.h),
          Form(
            key: validateKey,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "يرجى إدخال سبب التبليغ";
                }
                return null;
              },
              controller: chatProvider.reportController,
              decoration: InputDecoration(
                hintText: 'سبب التبليغ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          ChangeNotifierProvider.value(
            value: chatProvider,
            child: Consumer<ChatProvider>(
              builder: (context, value, _) {
                if (value.sendReportLoading) {
                  closeDialog = true;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (closeDialog) {
                  Navigator.pop(context);
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16.0),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (validateKey.currentState!.validate()) {
                          chatProvider.reportOnMessage(message: message);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.seconedaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: const Text(
                        'إبلاغ',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
