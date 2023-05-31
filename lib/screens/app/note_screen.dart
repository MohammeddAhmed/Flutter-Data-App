import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data/bloc/bloc/note_bloc.dart';
import 'package:data/bloc/events/crud_event.dart';
import 'package:data/bloc/states/crud_state.dart';
import 'package:data/models/note.dart';
import 'package:data/pref/shared_pref_controller.dart';
import 'package:data/utils/context_extension.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  String? _titleError;
  String? _infoError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.title);
    _infoTextController = TextEditingController(text: widget.note?.info);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(title),
      ),
      body: BlocListener<NoteBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState &&
            (current.processType == ProcessType.create ||
                current.processType == ProcessType.update),
        listener: (context, state) {
          state as ProcessState;
          if (state.success) {
            state.processType == ProcessType.create
                ? _clear()
                : Navigator.pop(context);
          }
          context.showSnackBar(message: state.message, erorr: !state.success);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            children: [
              TextField(
                controller: _titleTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: InputDecoration(
                  errorText: _titleError,
                  hintText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  hintMaxLines: 1,
                  // errorText: _passwordError,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _infoTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: InputDecoration(
                  errorText: _infoError,
                  hintText: 'info',
                  hintMaxLines: 1,
                  prefixIcon: const Icon(Icons.info),
                  // errorText: _passwordError,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _performSave();
                  Future.delayed(
                    const Duration(microseconds: 500),
                    () {
                      Navigator.pop(context);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF6A90F2),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  minimumSize: const Size(double.infinity, 53),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get title => isNewNote ? 'Create Note' : 'Update Note';

  bool get isNewNote => widget.note == null;

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    context.showSnackBar(
        message: context.localizations.insert_required_data, erorr: true);
    return false;
  }

  void _save() {
    isNewNote
        ? BlocProvider.of<NoteBloc>(context).add(CreateEvent(note))
        : BlocProvider.of<NoteBloc>(context).add(UpdateEvent(note));
  }

  void _clear() {
    _titleTextController.clear();
    _infoTextController.clear();
  }

  Note get note {
    Note note = isNewNote ? Note() : widget.note!;
    note.title = _titleTextController.text;
    note.info = _infoTextController.text;
    note.userId = SharedPrefController().getValue<int>(PrefKeys.id.name)!;
    return note;
  }
}
