import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'guest_book.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';
import 'yes_no_selection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.MMMMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Meetup'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          IconAndDetail(Icons.calendar_today, dateFormat),
          const IconAndDetail(Icons.location_city, 'Tashkent'),
          // Add from here
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          // to here
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a day full of Firebase Workshops'
            ' and Pizza at T.Shevchenko, 21A!',
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.attendees >= 2)
                  Paragraph('${appState.attendees} people going')
                else if (appState.attendees == 1)
                  const Paragraph('1 person going')
                else
                  const Paragraph('No one going'),
                if (appState.loggedIn) ...[
                  YesNoSelection(
                    state: appState.attending,
                    onSelection: (attending) => appState.attending = attending,
                  ),
                  const Header('Discussion'),
                  GuestBook(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.guestBookMessages,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
