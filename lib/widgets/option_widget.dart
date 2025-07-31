import 'package:flutter/material.dart';

class OptionWidget extends StatefulWidget {
  const OptionWidget({super.key});

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        // height: 50,
        width: 200,
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // color: Colors.white,
              border: Border.all(color: Colors.white)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ktm',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                // SizedBox(height: 4),
                Row(
                  children: [
                    Text('10',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 10 / 100, // Normalizza il punteggio tra 0 e 1
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )

                // SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
