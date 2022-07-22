import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class Core_screen extends StatefulWidget {
  final String display_text;

  const Core_screen({Key key, this.display_text}) : super(key: key);

  @override
  State<Core_screen> createState() => _Core_screenState();
}

class _Core_screenState extends State<Core_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recognized Text'),
        backgroundColor: Colors.orange[600],
        actions: [
          IconButton(
            onPressed: () {
              FlutterClipboard.copy(widget.display_text)
                  .then((value) => print('copied'));
            },
            icon: Icon(Icons.copy),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        // Container(
        child: SelectableText('${widget.display_text}'),
        // ),
      ),
    );
  }
}
