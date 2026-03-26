// import 'package:flutter/material.dart';
// import 'package:second_hand_electronics_marketplace/core/widget/Component_attachments icons/attachment_icon.dart';
// import 'package:second_hand_electronics_marketplace/core/widget/Component_msgChip/suggestions.dart';

// class ChatInputBar extends StatefulWidget {
//   final bool showSuggestions;
//   final Function(String)? onSend;
//   final VoidCallback? onAttach;
//   final VoidCallback? onCamera;
//   final VoidCallback? onEmoji;
//   final Function()? onStartRecording;
//   final Function()? onStopRecording;
//   final bool isRecording;

//   const ChatInputBar({
//     super.key,
//     this.showSuggestions = true,
//     this.onSend,
//     this.onAttach,
//     this.onCamera,
//     this.onEmoji,
//     this.onStartRecording,
//     this.onStopRecording,
//     this.isRecording = false,
//   });

//   @override
//   State<ChatInputBar> createState() => _ChatInputBarState();
// }

// class _ChatInputBarState extends State<ChatInputBar> {
//   final TextEditingController _controller = TextEditingController();
//   bool _isHasText = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() {
//       setState(() {
//         _isHasText = _controller.text.trim().isNotEmpty;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleVoiceButtonTap() {
//     if (_isHasText) {
//       widget.onSend?.call(_controller.text.trim());
//       _controller.clear();
//     } else {
//       if (widget.isRecording) {
//         widget.onStopRecording?.call();
//       } else {
//         widget.onStartRecording?.call();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade200, width: 0.5),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // حالة التسجيل - تظهر فقط أثناء التسجيل
//           if (widget.isRecording) ...[
//             _buildRecordingIndicator(),
//             const SizedBox(height: 16),
//           ],
          
//           // 1. الاقتراحات (Chips) - مثل فيغما
//           if (widget.showSuggestions && !widget.isRecording) ...[
//             _buildSuggestions(),
//             const SizedBox(height: 16),
//           ],
          
//           // 2. حقل الإدخال والأزرار
//           Row(
//             children: [
//               // زر الإيموجي - يختفي أثناء التسجيل
//               if (!widget.isRecording) ...[
//                 IconButton(
//                   onPressed: widget.onEmoji,
//                   icon: Icon(
//                     Icons.emoji_emotions_outlined,
//                     color: Colors.grey[600],
//                     size: 24,
//                   ),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//                 const SizedBox(width: 8),
//               ],
              
//               Expanded(
//                 child: Container(
//                   height: 44,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: widget.isRecording ? Colors.red[50] : Colors.grey[50],
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color: widget.isRecording ? Colors.red[300]! : Colors.grey[300]!,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: widget.isRecording
//                             ? _buildRecordingContent()
//                             : TextField(
//                                 controller: _controller,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black87,
//                                 ),
//                                 decoration: const InputDecoration(
//                                   hintText: "Message...",
//                                   border: InputBorder.none,
//                                   hintStyle: TextStyle(
//                                     color: Color(0xFF9CA3AF),
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   contentPadding: EdgeInsets.zero,
//                                 ),
//                               ),
//                       ),
                      
//                       // أيقونة المرفقات والكاميرا - تختفي أثناء التسجيل
//                       if (!widget.isRecording) ...[
//                         AttachmentButtons(onAttach: () {  }, onCamera: () {  },)
//                         // Transform.rotate(
//                         //   angle: -0.8,
//                         //   child: IconButton(
//                         //     onPressed: widget.onAttach,
//                         //     icon: Icon(
//                         //       Icons.attach_file,
//                         //       size: 20,
//                         //       color: Colors.grey[600],
//                         //     ),
//                         //     padding: EdgeInsets.zero,
//                         //     constraints: const BoxConstraints(),
//                         //   ),
//                         // ),
//                         // const SizedBox(width: 8),
//                         // IconButton(
//                         //   onPressed: widget.onCamera,
//                         //   icon: Icon(
//                         //     Icons.camera_alt_outlined,
//                         //     size: 20,
//                         //     color: Colors.grey[600],
//                         //   ),
//                         //   padding: EdgeInsets.zero,
//                         //   constraints: const BoxConstraints(),
//                         // ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(width: 8),
              
//               // 3. زر الإرسال / الميكروفون
//               // GestureDetector(
//               //   onTap: _handleVoiceButtonTap,
//               //   onLongPress: _isHasText ? null : widget.onStartRecording,
//               //   child: Container(
//               //     width: 44,
//               //     height: 44,
//               //     decoration: BoxDecoration(
//               //       color: widget.isRecording
//               //           ? Colors.red
//               //           : _isHasText
//               //               ? const Color(0xFF007AFF)
//               //               : Colors.grey[200],
//               //       shape: BoxShape.circle,
//               //     ),
//               //     child: Stack(
//               //       children: [
//               //         Center(
//               //           child: Icon(
//               //             widget.isRecording
//               //                 ? Icons.stop_rounded
//               //                 : _isHasText
//               //                     ? Icons.send_rounded
//               //                     : Icons.mic_outlined,
//               //             color: widget.isRecording || _isHasText
//               //                 ? Colors.white
//               //                 : Colors.grey[600],
//               //             size: 22,
//               //           ),
//               //         ),
                      
//               //         // مؤشر التسجيل (موجة صوت) - يظهر فقط أثناء التسجيل
//               //         if (widget.isRecording)
//               //           Positioned(
//               //             right: 0,
//               //             top: 0,
//               //             child: Container(
//               //               width: 10,
//               //               height: 10,
//               //               decoration: BoxDecoration(
//               //                 color: Colors.white,
//               //                 shape: BoxShape.circle,
//               //                 border: Border.all(color: Colors.red, width: 1),
//               //               ),
//               //               child: const Center(
//               //                 child: Icon(
//               //                   Icons.fiber_manual_record,
//               //                   color: Colors.red,
//               //                   size: 6,
//               //                 ),
//               //               ),
//               //             ),
//               //           ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//               // في جزء زر الإرسال/الميكروفون:
// GestureDetector(
//   onTap: _handleVoiceButtonTap,
//   onLongPress: () {
//     if (!_isHasText && !widget.isRecording) {
//       widget.onStartRecording?.call();
//     }
//   },
//   child: Container(
//     width: 44,
//     height: 44,
//     decoration: BoxDecoration(
//       color: widget.isRecording
//           ? Colors.red
//           : _isHasText
//               ? const Color(0xFF007AFF)
//               : Colors.grey[200],
//       shape: BoxShape.circle,
//     ),
//     child: Stack(
//       children: [
//         Center(
//           child: Icon(
//             widget.isRecording
//                 ? Icons.stop_rounded
//                 : _isHasText
//                     ? Icons.send_rounded
//                     : Icons.mic_outlined,
//             color: widget.isRecording || _isHasText
//                 ? Colors.white
//                 : Colors.grey[600],
//             size: 22,
//           ),
//         ),
        
//         // مؤشر التسجيل (موجة صوت) - يظهر فقط أثناء التسجيل
//         if (widget.isRecording)
//           Positioned(
//             right: 0,
//             top: 0,
//             child: Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.red, width: 1),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.fiber_manual_record,
//                   color: Colors.red,
//                   size: 6,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     ),
//   ),
// ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecordingIndicator() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.keyboard_voice,
//               color: Colors.red,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               "Recording...",
//               style: TextStyle(
//                 color: Colors.red[700],
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // مؤشر الوقت
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.red[50],
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.red[100]!),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     "0:00",
//                     style: TextStyle(
//                       color: Colors.red[800],
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     "/ 0:05",
//                     style: TextStyle(
//                       color: Colors.red[600],
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             // زر إلغاء التسجيل
//             GestureDetector(
//               onTap: widget.onStopRecording,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   "Cancel",
//                   style: TextStyle(
//                     color: Colors.grey[800],
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRecordingContent() {
//     return Row(
//       children: [
//         Icon(
//           Icons.keyboard_voice,
//           color: Colors.red,
//           size: 20,
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // مؤشر الموجة الصوتية (يمكن استبداله بمؤشر حقيقي)
//               Row(
//                 children: [
//                   for (int i = 0; i < 5; i++)
//                     Container(
//                       width: 4,
//                       height: 8 + i * 3,
//                       margin: const EdgeInsets.only(right: 3),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 "Slide to cancel",
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// Widget _buildSuggestions() {
//     return SuggestionChips(
//       suggestions: const [
//         "Is it still available?",
//         "Can you send another picture?",
//         "What's the condition?",
//         "Would you take an offer?"
//       ],
//       onSelected: (selectedText) {
//         setState(() {
//           _controller.text = selectedText;
//           _isHasText = true;
//         });
//       },
//     );
//   }
//   // Widget _buildSuggestions() {
//   //   final suggestions = [
//   //     "Is it still available?", 
//   //     "Can you send another picture?",
//   //     "What's the condition?",
//   //     "Would you take an offer?"
//   //   ];
    
//   //   return SizedBox(
//   //     height: 36,
//   //     child: ListView.separated(
//   //       scrollDirection: Axis.horizontal,
//   //       itemCount: suggestions.length,
//   //       separatorBuilder: (_, __) => const SizedBox(width: 8),
//   //       itemBuilder: (context, index) {
//   //         return GestureDetector(
//   //           onTap: () {
//   //             _controller.text = suggestions[index];
//   //             setState(() {
//   //               _isHasText = true;
//   //             });
//   //           },
//   //           child: Container(
//   //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   //             decoration: BoxDecoration(
//   //               color: Colors.grey[50],
//   //               borderRadius: BorderRadius.circular(18),
//   //               border: Border.all(color: Colors.grey[300]!),
//   //             ),
//   //             child: Center(
//   //               child: Text(
//   //                 suggestions[index],
//   //                 style: TextStyle(
//   //                   fontSize: 14,
//   //                   color: Colors.grey[800],
//   //                   fontWeight: FontWeight.w500,
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }
// }















// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Voice/chat_input_bar_modified.dart';
// import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_attachments icons/attachment_icon.dart';
// import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_msgChip/suggestions.dart';

// class ChatInputBar extends StatefulWidget {
//   final bool showSuggestions;
//   final Function(String)? onSend;
//   final VoidCallback? onAttach;
//   final VoidCallback? onCamera;
//   final VoidCallback? onEmoji;

//   const ChatInputBar({
//     super.key,
//     this.showSuggestions = true,
//     this.onSend,
//     this.onAttach,
//     this.onCamera,
//     this.onEmoji, 
//   });

//   @override
//   State<ChatInputBar> createState() => _ChatInputBarState();
// }

// class _ChatInputBarState extends State<ChatInputBar> {
//   final TextEditingController _controller = TextEditingController();

//   bool _hasText = false;
//   bool _isRecording = false;

//   Timer? _timer;
//   int _seconds = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() {
//       setState(() {
//         _hasText = _controller.text.trim().isNotEmpty;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }


//   void _startRecording() {
//     setState(() {
//       _isRecording = true;
//       _seconds = 0;
//     });

//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() => _seconds++);
//     });
//   }

//   void _stopRecording() {
//     _timer?.cancel();
//     setState(() => _isRecording = false);

//     // هنا مستقبلاً ترسلي الصوت
//     debugPrint("Voice message sent ($_seconds sec)");
//   }

//   void _cancelRecording() {
//     _timer?.cancel();
//     setState(() => _isRecording = false);
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // 🎙 Recording Bubble
//           if (_isRecording) ...[
//             RecordingBubble(
//               seconds: _seconds,
//               onCancel: _cancelRecording,
//               onSend: _stopRecording,
//             ),
//             const SizedBox(height: 16),
//           ],

//           // 💬 Suggestions
//           if (widget.showSuggestions && !_isRecording) ...[
//             _buildSuggestions(),
//             const SizedBox(height: 16),
//           ],

//           // ✍️ Input Row
//           if (!_isRecording) _buildInputRow(),
//         ],
//       ),
//     );
//   }


//   Widget _buildInputRow() {
//     return Row(
//       children: [
//         IconButton(
//           onPressed: widget.onEmoji,
//           icon: Icon(
//             Icons.emoji_emotions_outlined,
//             color: Colors.grey[600],
//           ),
//         ),

//         Expanded(
//           child: Container(
//             height: 44,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: 
//                  TextField(
//   controller: _controller,
//   maxLines: null, // يسمح بتمدد الحقل حسب النص
//   keyboardType: TextInputType.multiline,
//   style: const TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w400,
//     color: Colors.black87,
//   ),
//   decoration: const InputDecoration(
//     hintText: "Message...",
//     border: InputBorder.none,
//     hintStyle: TextStyle(
//       color: Color(0xFF9CA3AF),
//       fontSize: 15,
//       fontWeight: FontWeight.w400,
//     ),
//     contentPadding: EdgeInsets.zero,
//   ),
// )

//                   // child: TextField(
//                   //   controller: _controller,
//                   //   decoration: const InputDecoration(
//                   //     hintText: "Message...",
//                   //     border: InputBorder.none,
//                   //   ),
//                   // ),
//                 ),

//                 AttachmentButtons(
//                   onAttach: widget.onAttach ?? () {},
//                   onCamera: widget.onCamera ?? () {},
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(width: 8),

//         _buildMicOrSendButton(),
//       ],
//     );
//   }


//   Widget _buildMicOrSendButton() {
//     return GestureDetector(
//       onTap: () {
//         if (_hasText) {
//           widget.onSend?.call(_controller.text.trim());
//           _controller.clear();
//         }
//       },
//       onLongPress: _hasText ? null : _startRecording,
//       child: Container(
// constraints: BoxConstraints( minHeight: 44, maxHeight: 120, // أو حسب التصميم
// ),
//         width: 44,
//         // height: 44,
//         decoration: BoxDecoration(
//           color: _hasText
//               ? const Color(0xFF2563EB)
//               : Colors.grey.shade200,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           _hasText ? Icons.send_rounded : Icons.mic_outlined,
//           color: _hasText ? Colors.white : Colors.grey[600],
//         ),
//       ),
//     );
//   }


//   Widget _buildSuggestions() {
//     return SuggestionChips(
//       suggestions: const [
//         "Is it still available?",
//         "Can you send another picture?",
//         "What's the condition?",
//         "Would you take an offer?",
//       ],
//       onSelected: (text) {
//         setState(() {
//           _controller.text = text;
//           _hasText = true;
//         });
//       },
//     );
//   }
// }
