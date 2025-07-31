import 'package:flutter/material.dart';

class PollWidget extends StatefulWidget {
  @override
  _PollWidgetState createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  final Map<String, int> _votes = {
    "Opzione 1": 0,
    "Opzione 2": 0, // Aggiungi più opzioni senza problemi
    "Opzione 3": 0,
    "Opzione 4": 0,
  };

  void _vote(String option) {
    setState(() {
      _votes[option] = (_votes[option] ?? 0) + 1; // Incrementa il punteggio
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Quale preferisci?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),

          // Usa Wrap per distribuire le opzioni su più righe
          Wrap(
            spacing: 8, // Spazio orizzontale tra i pulsanti
            runSpacing: 8, // Spazio verticale tra le righe
            alignment: WrapAlignment.center,
            children: _votes.keys.map((option) {
              return _pollOption(option);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget per ogni opzione del sondaggio con punteggio
  Widget _pollOption(String option) {
    return ElevatedButton(
      onPressed: () => _vote(option),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.3),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(option),
          SizedBox(width: 6),
          Text(
            "(${_votes[option]})", // Mostra il punteggio accanto all'opzione
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
