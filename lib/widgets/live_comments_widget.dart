// import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';

class LiveCommentsWidget extends StatefulWidget {
  @override
  _LiveCommentsWidgetState createState() => _LiveCommentsWidgetState();
}

class _LiveCommentsWidgetState extends State<LiveCommentsWidget> {
  final List<String> _comments = []; // Lista commenti
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _simulateLiveComments(); // Simula commenti in arrivo
  }

  // Simula commenti live automatici ogni 5 secondi (puoi rimuoverlo se usi Firestore)
  void _simulateLiveComments() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _comments.add("💬 Commento live ${_comments.length + 1}");
          _scrollToBottom();
        });
      }
    });
  }

  // Funzione per inviare un nuovo commento
  void _addComment(String comment) {
    if (comment.isNotEmpty) {
      setState(() {
        _comments.add(comment);
        _scrollToBottom(); // Auto-scroll al nuovo commento
        _commentController.clear();
      });
    }
  }

  // Auto-scroll all'ultimo commento
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * 0.6, // Altezza 60% dello schermo
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(
            "Commenti Live",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // Lista con animazione
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 500), // Effetto fade-in
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      tileColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(
                        _comments[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Campo di input + pulsante invio
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Scrivi un commento...",
                    hintStyle: TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () => _addComment(_commentController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
