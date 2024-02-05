// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/utils/utils.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen({super.key, this.isTwitt = false, required this.snap});

  bool isTwitt;
  final snap;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _postBioController;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _postBioController =
        TextEditingController(text: widget.snap['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(36),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _postBioController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 4,
                        decoration: InputDecoration(
                            label: Text(widget.isTwitt
                                ? 'Testo del twitt da modificare'
                                : 'Bio del post da modificare'),
                            border: OutlineInputBorder()),
                        // decoration: textFieldDecoration(
                        //     label: widget.isTwitt!
                        //         ? 'Testo del twitt'
                        //         : 'Bio del post'),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                            if (widget.isTwitt) {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                            }

                            String msg = await FirestoreMethods().editPost(
                                postId: widget.snap['postId'],
                                bio: _postBioController.text);

                            if (msg != "") {
                              showSnackBar(context, msg);
                            } else {
                              showSnackBar(
                                  context,
                                  widget.isTwitt
                                      ? 'Twitt modificato'
                                      : 'Post modificato');
                            }

                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Salva'))
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
