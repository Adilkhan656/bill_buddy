// import 'package:flutter/material.dart';
// // Optional, or use Icon

// class ChatbotScreen extends StatelessWidget {
//   const ChatbotScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("AI Assistant")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.smart_toy_rounded, size: 80, color: Theme.of(context).primaryColor.withOpacity(0.5)),
//             const SizedBox(height: 20),
//             const Text(
//               "AI Chatbot Coming Soon!",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Ask about your spending habits\nand get financial advice.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

import 'package:bill_buddy/ui/chatbot/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Optional: for nicer text


class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatbotService _service = ChatbotService();
  final ScrollController _scrollController = ScrollController();

  // Chat History: Starts with a welcome message
  final List<Map<String, String>> _messages = [
    {
      "role": "ai", 
      "text": "Hi! I'm Bill Buddy AI. 👋\n\nAsk me how to use the app or for simple saving tips!"
    }
  ];

  bool _isLoading = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // 1. Add User Message
    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    // 2. Get AI Response
    final response = await _service.getResponse(text);

    // 3. Add AI Message
    if (mounted) {
      setState(() {
        _messages.add({"role": "ai", "text": response});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final chatBgColor = isDark ? Colors.grey[900] : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: chatBgColor,
      appBar: AppBar(
        title: Row(
          children: [
             Image.asset(
            'assets/images/aichatbot.gif',
            width: 38,
            height: 38,
          ),
            SizedBox(width: 2),
            Text("AI Assistant"),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ------------------------------------
          // 1. CHAT LIST
          // ------------------------------------
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return _buildChatBubble(msg['text']!, isUser, primaryColor, isDark);
              },
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  ),
                ),
              ),
            ),

          // ------------------------------------
          // 2. INPUT FIELD
          // ------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: "Ask about expenses...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  backgroundColor: _isLoading ? Colors.grey : primaryColor,
                  elevation: 2,
                  mini: true,
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 💬 Chat Bubble Widget
  Widget _buildChatBubble(String text, bool isUser, Color primary, bool isDark) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser 
            ? primary 
            : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
          boxShadow: [
            if (!isDark) 
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        // Use MarkdownBody to render bold text properly
        child: MarkdownBody(
          data: text,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
              fontSize: 15,
            ),
            strong: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}