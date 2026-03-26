import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/chat_bubble.dart';

class ReplyMessageBubble extends ChatBubbleBase {
  final String repliedTo;
  final String message;
  final String time;
  
  final bool isRead;

  ReplyMessageBubble({
    super.key,
    required super.isSender,
    required this.repliedTo,
    required this.message,
    required this.time,
     required   this.isRead,

  }) : super(child: const SizedBox());

  @override
  Widget build(BuildContext context) {
    return ChatBubbleBase(
      isSender: isSender,
      child: Column(
  crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSender 
                  ? AppColors.mainColor5 
                  : AppColors.secondaryColor5, 
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSender 
                    ? AppColors.mainColor20 
                    : AppColors.secondaryColor20,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Icon(
                //       Icons.reply,
                //       size: 12,
                //       color: isSender ? AppColors.mainColor : AppColors.secondaryColor,
                //     ),
                //     const SizedBox(width: 4),
                //     Text(
                //       'رد على',
                //       style: AppTypography.label10Medium.copyWith(
                //         color: isSender ? AppColors.mainColor : AppColors.secondaryColor,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 4),
                Text(
                  repliedTo,
                  style: AppTypography.body16Regular.copyWith(
                    color: AppColors.titles,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          Text(
            message,
            style: AppTypography.body14Regular.copyWith(
              color: AppColors.text,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
               mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                time,
                style: AppTypography.label10Regular.copyWith(
                  color: AppColors.hint,fontWeight: FontWeight.w400
                ),
              ),
              
              const SizedBox(width: 4),
              if (isSender)
                Icon(
                      isRead ? Icons.done_all : Icons.done,
                      size: 14,
                      color: isRead ?
                     AppColors.success
                      //  const Color(0xFF2563EB) 
                      : AppColors.hint,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
// import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
// import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/chat_bubble.dart';
// import 'package:iconsax/iconsax.dart';

// enum MessageType { text, image, audio, file, location }

// class ReplyMessageBubble extends ChatBubbleBase {
//   final String repliedTo;
//   final String repliedContent;
//   final String repliedTime;
//   final MessageType repliedType;
//   final String currentMessage;
//   final String currentTime;
//   final bool isRead;

//   ReplyMessageBubble({
//     super.key,
//     required super.isSender,
//     required this.repliedTo,
//     required this.repliedContent,
//     required this.repliedTime,
//     required this.repliedType,
//     required this.currentMessage,
//     required this.currentTime,
//     required this.isRead,
//   }) : super(child: const SizedBox());

//   @override
//   Widget build(BuildContext context) {
//     return ChatBubbleBase(
//       isSender: isSender,
//       child: Column(
//         crossAxisAlignment:
//             isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           // Preview of the replied message
//           _buildReplyPreview(),
          
//           const SizedBox(height: 12),
          
//           // Current message content
//           _buildCurrentMessage(),
          
//           const SizedBox(height: 8),
          
//           // Message footer (time + read status)
//           _buildMessageFooter(),
//         ],
//       ),
//     );
//   }

//   Widget _buildReplyPreview() {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: isSender 
//             ? AppColors.mainColor.withOpacity(0.08)
//             : AppColors.secondaryColor.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isSender 
//               ? AppColors.mainColor.withOpacity(0.3)
//               : AppColors.secondaryColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Reply header
//           Row(
//             children: [
//               Icon(
//                 _getReplyIcon(),
//                 size: 14,
//                 color: isSender ? AppColors.mainColor : AppColors.secondaryColor,
//               ),
//               const SizedBox(width: 6),
//               Expanded(
//                 child: Text(
//                   'رد على $repliedTo',
//                   style: AppTypography.label12Medium.copyWith(
//                     color: isSender ? AppColors.mainColor : AppColors.secondaryColor,
//                   ),
//                 ),
//               ),
//               Text(
//                 repliedTime,
//                 style: AppTypography.label10Regular.copyWith(
//                   color: AppColors.hint,
//                 ),
//               ),
//             ],
//           ),
          
//           const SizedBox(height: 6),
          
//           // Reply content based on type
//           _buildReplyContentByType(),
//         ],
//       ),
//     );
//   }

//   Widget _buildReplyContentByType() {
//     switch (repliedType) {
//       case MessageType.text:
//         return Text(
//           repliedContent,
//           style: AppTypography.body14Regular.copyWith(
//             color: AppColors.text.withOpacity(0.8),
//             fontStyle: FontStyle.italic,
//           ),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         );
      
//       case MessageType.image:
//         return Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: const Color(0xFFE0E0E0),
//                 image: DecorationImage(
//                   image: NetworkImage(repliedContent),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: const Icon(
//                 Icons.photo,
//                 size: 20,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'صورة',
//                     style: AppTypography.body14Medium.copyWith(
//                       color: AppColors.text,
//                     ),
//                   ),
//                   Text(
//                     'انقر لعرض الصورة',
//                     style: AppTypography.label12Regular.copyWith(
//                       color: AppColors.hint,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
      
//       case MessageType.audio:
//         return Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.mainColor.withOpacity(0.1),
//               ),
//               child: Icon(
//                 Iconsax.voice_square,
//                 size: 20,
//                 color: AppColors.mainColor,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'رسالة صوتية',
//                     style: AppTypography.body14Medium.copyWith(
//                       color: AppColors.text,
//                     ),
//                   ),
//                   Text(
//                     _formatAudioDuration(repliedContent),
//                     style: AppTypography.label12Regular.copyWith(
//                       color: AppColors.hint,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
      
//       case MessageType.file:
//         return Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: const Color(0xFFE0E0E0),
//               ),
//               child: Icon(
//                 _getFileIcon(repliedContent),
//                 size: 20,
//                 color: AppColors.text,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _getFileName(repliedContent),
//                     style: AppTypography.body14Medium.copyWith(
//                       color: AppColors.text,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     _getFileSize(repliedContent),
//                     style: AppTypography.label12Regular.copyWith(
//                       color: AppColors.hint,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
      
//       case MessageType.location:
//         return Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: AppColors.success.withOpacity(0.1),
//               ),
//               child: Icon(
//                 Iconsax.location,
//                 size: 20,
//                 color: AppColors.success,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 'موقع: $repliedContent',
//                 style: AppTypography.body14Regular.copyWith(
//                   color: AppColors.text.withOpacity(0.8),
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         );
//     }
//   }

//   Widget _buildCurrentMessage() {
//     return Text(
//       currentMessage,
//       style: AppTypography.body14Regular.copyWith(
//         color: AppColors.text,
//       ),
//     );
//   }

//   Widget _buildMessageFooter() {
//     return Row(
//       mainAxisAlignment:
//           isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Text(
//           currentTime,
//           style: AppTypography.label10Regular.copyWith(
//             color: AppColors.hint,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
        
//         const SizedBox(width: 4),
        
//         if (isSender)
//           Icon(
//             isRead ? Icons.done_all : Icons.done,
//             size: 14,
//             color: isRead ? AppColors.success : AppColors.hint,
//           ),
//       ],
//     );
//   }

//   // Helper methods
//   IconData _getReplyIcon() {
//     switch (repliedType) {
//       case MessageType.text:
//         return Icons.reply;
//       case MessageType.image:
//         return Icons.photo;
//       case MessageType.audio:
//         return Iconsax.voice_square;
//       case MessageType.file:
//         return Icons.insert_drive_file;
//       case MessageType.location:
//         return Iconsax.location;
//     }
//   }

//   String _formatAudioDuration(String duration) {
//     try {
//       final seconds = int.tryParse(duration) ?? 0;
//       final minutes = seconds ~/ 60;
//       final remainingSeconds = seconds % 60;
//       return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return duration;
//     }
//   }

//   IconData _getFileIcon(String fileName) {
//     if (fileName.toLowerCase().endsWith('.pdf')) {
//       return Icons.picture_as_pdf;
//     } else if (fileName.toLowerCase().endsWith('.doc') || 
//                fileName.toLowerCase().endsWith('.docx')) {
//       return Icons.description;
//     } else if (fileName.toLowerCase().endsWith('.xls') || 
//                fileName.toLowerCase().endsWith('.xlsx')) {
//       return Icons.table_chart;
//     } else if (fileName.toLowerCase().endsWith('.ppt') || 
//                fileName.toLowerCase().endsWith('.pptx')) {
//       return Icons.slideshow;
//     } else if (fileName.toLowerCase().endsWith('.zip') || 
//                fileName.toLowerCase().endsWith('.rar')) {
//       return Icons.archive;
//     } else {
//       return Icons.insert_drive_file;
//     }
//   }

//   String _getFileName(String path) {
//     final parts = path.split('/');
//     return parts.last;
//   }

//   String _getFileSize(String path) {
//     // يمكنك هنا إضافة منطق لحساب حجم الملف
//     return 'ملف';
//   }
// }

// // Example of how to use the new ReplyMessageBubble:

// /*
// ReplyMessageBubble(
//   isSender: true,
//   repliedTo: "علي",
//   repliedContent: "https://example.com/image.jpg", // أو نص أو مسار صوتي
//   repliedTime: "10:30",
//   repliedType: MessageType.image, // يمكن أن يكون text, image, audio, file, location
//   currentMessage: "هذه هي الصورة التي طلبتها",
//   currentTime: "10:35",
//   isRead: true,
// ),

// ReplyMessageBubble(
//   isSender: false,
//   repliedTo: "أنت",
//   repliedContent: "120", // مدة الرسالة الصوتية بالثواني
//   repliedTime: "10:25",
//   repliedType: MessageType.audio,
//   currentMessage: "سمعت الرسالة الصوتية",
//   currentTime: "10:40",
//   isRead: true,
// ),

// ReplyMessageBubble(
//   isSender: true,
//   repliedTo: "سارة",
//   repliedContent: "/path/to/document.pdf",
//   repliedTime: "09:15",
//   repliedType: MessageType.file,
//   currentMessage: "شكراً على إرسال الملف",
//   currentTime: "09:20",
//   isRead: false,
// ),
// */