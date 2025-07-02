// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../cubit/chatbot_cubit.dart';
// import '../cubit/chatbot_state.dart';
// import '../widgets/chat_message_widget.dart';

// class ChatbotScreen extends StatefulWidget {
//   const ChatbotScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatbotScreen> createState() => _ChatbotScreenState();
// }

// class _ChatbotScreenState extends State<ChatbotScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     context.read<ChatbotCubit>().loadMessages();
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() {
//     final message = _messageController.text.trim();
//     if (message.isNotEmpty) {
//       context.read<ChatbotCubit>().sendMessage(message);
//       _messageController.clear();
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: const BoxDecoration(
//                 color: Colors.blue,
//                 shape: BoxShape.circle,
//               ),
//               child: const Center(
//                 child: Text(
//                   'R',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Roomly Assistant',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Online',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Colors.black),
//             onPressed: () {
//               // Show options menu
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Messages list
//           Expanded(
//             child: BlocConsumer<ChatbotCubit, ChatbotState>(
//               listener: (context, state) {
//                 if (state is ChatbotLoaded) {
//                   _scrollToBottom();
//                 }
//                 if (state is ChatbotError) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Error: ${state.message}'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 if (state is ChatbotInitial) {
//                   return const Center(
//                     child: Text(
//                       'Start a conversation with Roomly Assistant',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   );
//                 }
                
//                 if (state is ChatbotLoaded) {
//                   if (state.messages.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'Start a conversation with Roomly Assistant',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     );
//                   }
                  
//                   return ListView.builder(
//                     controller: _scrollController,
//                     itemCount: state.messages.length,
//                     itemBuilder: (context, index) {
//                       return ChatMessageWidget(
//                         message: state.messages[index],
//                       );
//                     },
//                   );
//                 }
                
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//             ),
//           ),
          
//           // Message input
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, -1),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 12,
//                       ),
//                     ),
//                     maxLines: null,
//                     textInputAction: TextInputAction.send,
//                     onSubmitted: (_) => _sendMessage(),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.blue,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.send,
//                       color: Colors.white,
//                     ),
//                     onPressed: _sendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// v2 ------------------------------------------------------------------------------------


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_state.dart';
import '../widgets/chat_message_widget.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatbotCubit>().loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatbotCubit>().sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roomly Assistant',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: BlocConsumer<ChatbotCubit, ChatbotState>(
              listener: (context, state) {
                if (state is ChatbotLoaded) {
                  _scrollToBottom();
                }
                if (state is ChatbotError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatbotInitial) {
                  return const Center(
                    child: Text(
                      'Start a conversation with Roomly Assistant',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                
                if (state is ChatbotLoaded) {
                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'Start a conversation with Roomly Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageWidget(
                        message: state.messages[index],
                      );
                    },
                  );
                }
                
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

