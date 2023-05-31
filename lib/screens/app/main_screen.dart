import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data/bloc/bloc/note_bloc.dart';
import 'package:data/bloc/events/crud_event.dart';
import 'package:data/bloc/states/crud_state.dart';
import 'package:data/models/note.dart';
import 'package:data/pref/shared_pref_controller.dart';
import 'package:data/screens/app/note_screen.dart';
import 'package:data/utils/context_extension.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<NoteBloc>(context).add(ReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          context.localizations.home,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () => _showLogoutConfirmationDialog(),
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
      ),
      body: BlocConsumer<NoteBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState &&
            current.processType == ProcessType.delete,
        listener: (context, state) {
          state as ProcessState;
          context.showSnackBar(message: state.message, erorr: !state.success);
        },
        buildWhen: (previous, current) =>
            current is LoadingState || current is ReadState<Note>,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReadState<Note> && state.data.isNotEmpty) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.note,
                    color: Colors.blue,
                  ),
                  title: Text(
                    state.data[index].title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    state.data[index].info,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                  ),
                  trailing: IconButton(
                    onPressed: () => BlocProvider.of<NoteBloc>(context)
                        .add(DeleteEvent(index)),
                    icon: const Icon(Icons.delete),
                    color: Colors.red.shade600,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(
                          note: state.data[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No Notes !!',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showLogoutConfirmationDialog() async {
    bool? result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            context.localizations.confirm_hint,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: Text(
            context.localizations.confirm_massage,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.black45,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                context.localizations.yes,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                context.localizations.no,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
    if (result ?? false) {
      SharedPrefController().setValue(PrefKeys.loggedIn.name, false);
      Future.delayed(const Duration(microseconds: 500), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }
}
