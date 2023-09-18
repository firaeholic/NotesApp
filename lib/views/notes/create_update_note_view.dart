import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState(){
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  // void _textControllerListener() async{
  //   final note = _note;
  //   if(note == null){
  //     return;
  //   }
  //   final text = _textController.text;
    
  //   await _notesService.updateNote(documentId: note.documentId, text: text);
  // }

  // void _setUpTextControllerListener(){
  //   _textController.removeListener(_textControllerListener);
  //   _textController.addListener(_textControllerListener);
  // }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if(widgetNote != null){
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if(existingNote != null){
      return existingNote; 
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  //  _deleteNoteIfTextIsEmpty() async{
  //   final note = _note;
  //   if(_textController.text.isEmpty && note != null){
  //     await _notesService.deleteNote(documentId: note.documentId);
  //   }
  // }

  // void _saveNoteIfTextIsNotEmpty() async{
  //   final note = _note;
  //   final text = _textController.text;
  //   if(note != null && text.isNotEmpty){
  //     await _notesService.updateNote(documentId: note.documentId, text: text);
  //   }
  // }

//   void _cancelButtonAction() {
//   final text = _textController.text;
//   if (text.isEmpty) {
//     _deleteNoteIfTextIsEmpty();
//   }
//   Navigator.of(context).pop();
// }

  @override
  void dispose() {
    // _cancelButtonAction();
    // _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      final note = _note;
      final text = _textController.text;
      if (note != null && text.isEmpty) {
        await _notesService.deleteNote(documentId: note.documentId);
      }
      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('New note'),
        backgroundColor: const Color(0xFF1B1B1B),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      // autofocus: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Type your new note...',
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 86, 83, 83)),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 69, 65, 65))
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ElevatedButton(
                            onPressed: () async {
                              final note = _note;
                              final text = _textController.text;
                              if (note != null && text.isNotEmpty) {
                                await _notesService.updateNote(
                                  documentId: note.documentId,
                                  text: text,
                                );
                              } else if (_textController.text.isEmpty && note != null) {
                                await _notesService.deleteNote(
                                  documentId: note.documentId,
                                );
                              }
                              if (context.mounted) {
                                Navigator.of(context).pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, 
                            ),
                            child: const Text('Add'),

                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ElevatedButton(
                            onPressed: () async {
                              final note = _note;
                              if(note != null){
                                await _notesService.deleteNote(
                                documentId: note.documentId,
                              );
                              }
                              if (context.mounted) {
                                Navigator.of(context).pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 237, 99, 89),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ),
  );
}
}