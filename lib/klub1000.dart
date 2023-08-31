import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spotify_sdk/spotify_sdk.dart';

class Klub1000 extends StatefulWidget {
  const Klub1000({super.key, required this.title});

  final String title;

  @override
  State<Klub1000> createState() => _Klub1000();
}

class _Klub1000 extends State<Klub1000> {
  final bool isAuthenticating = false;
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  Future<void> authenticateSpotify() async {
    bool connected = await SpotifySdk.connectToSpotifyRemote(
        clientId: dotenv.env['CLIENT_ID']!,
        redirectUrl: dotenv.env['REDIRECT_URI']!);
    if (connected) {
      print('connected');
    } else if (!connected) {
      print('not connected');
    }
  }

  bool checkAuthenticationStatus() {
    return isAuthenticating;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hello World App',
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange,
              title: Text('Camp Idiot - Klub 1000'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('Velkommen til den årlige klub 1000'),
                  SizedBox(height: 20), // Adding some spacing
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                    onPressed: () {
                      print("pressed here");
                      authenticateSpotify();
                    },
                    child: Text('Authenticate with Spotify'),
                  )
                ]))));
  }
}
