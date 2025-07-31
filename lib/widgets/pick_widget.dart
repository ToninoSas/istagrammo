import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:istagrammo/widgets/live_comments_widget.dart';
import 'package:istagrammo/widgets/option_widget.dart';
import 'package:istagrammo/widgets/poll_widget.dart';

class PickWidget extends StatefulWidget {
  const PickWidget({super.key});

  @override
  State<PickWidget> createState() => _PickWidgetState();
}

class _PickWidgetState extends State<PickWidget> {
  final List<String> _comments = []; // Lista commenti
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _newComment = ""; // Ultimo commento in tempo reale

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
          _newComment = "💬 Commento live ${_comments.length + 1}";
          _comments.add(_newComment);
          // _scrollToBottom(); // Auto-scroll per il nuovo commento
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
    return Scaffold(
      body: Stack(
        children: [
          // Sfondo dell'immagine
          Positioned.fill(
            child: Image.asset(
              "images/fibra.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // Commenti live in basso a sinistra
          Positioned(
            left: 16,
            bottom: 16, // Distanza dal fondo, sopra il pulsante
            child: AnimatedOpacity(
              opacity: _newComment.isEmpty ? 0 : 1,
              duration: Duration(
                  milliseconds: 500), // Animazione fade-in per ogni commento
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  // color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _newComment,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Sondaggio in basso sovrapposto
          Positioned(
              left: 16,
              right: 16,
              bottom: 60, // Più in alto per lasciare spazio ai commenti
              child: PollWidget()),
          // Pulsante per mostrare i commenti completi
          Positioned(
            right: 12,
            bottom: 8,
            child: FloatingActionButton(
              onPressed: () {
                // Mostra la pagina con i commenti live
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.black.withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "Commenti Live",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),

                            // Lista commenti
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _comments.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      tileColor:
                                          Colors.white.withValues(alpha: 0.1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      title: Text(
                                        _comments[index],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Campo di input per il commento
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Scrivi un commento...",
                                      hintStyle:
                                          TextStyle(color: Colors.white60),
                                      filled: true,
                                      fillColor:
                                          Colors.white.withValues(alpha: 0.2),
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
                                  onPressed: () =>
                                      _addComment(_commentController.text),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              elevation: 0,
              child: Icon(Icons.chat, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
