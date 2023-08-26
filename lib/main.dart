import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Global {
  static bool isSpotifyConnected = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyPlayerWidget extends StatefulWidget {
  @override
  _MyPlayerWidgetState createState() => _MyPlayerWidgetState();
}

class _MyPlayerWidgetState extends State<MyPlayerWidget> {
  bool isPlaying = false;
  String currentTrackImage =
      "https://img.medscapestatic.com/pi/features/drugdirectory/octupdate/AUX00011.jpg";
  double playbackPosition = 0.0;
  double totalDuration = 1.0;
  String currentTrackImageUri =
      "https://img.medscapestatic.com/pi/features/drugdirectory/octupdate/AUX00011.jpg";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(currentTrackImageUri), // Display urrent track image
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _updatePlayerState();
  }

  void _updatePlayerState() async {
    try {
      print("updating player state");
      final playerState = await SpotifySdk.getPlayerState();
      if (playerState != null) {
        setState(() {
          isPlaying = playerState.isPaused ? false : true;
          currentTrackImage = playerState.track?.imageUri?.raw ??
              "https://img.fruugo.com/product/1/87/152194871_max.jpg";
          playbackPosition = playerState.playbackPosition?.toDouble() ?? 0.0;
          totalDuration = playerState.track?.duration?.toDouble() ?? 1.0;
          currentTrackImageUri = playerState.track?.imageUri?.raw ??
              "https://img.fruugo.com/product/1/87/152194871_max.jpg";
        });
        print("updated player state");
      }
    } catch (e) {
      print(e);
    }
  }
}

class MyApp extends StatelessWidget {
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
                  authenticateWithSpotify();
                },
                child: Text('Authenticate with Spotify'),
              ),
              SizedBox(height: 20), // Adding some spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // background
                  foregroundColor: Colors.white, // foreground
                ),
                onPressed: () {
                  print("pressed here");
                  disconnectFromSpotify();
                },
                child: Text('Disconnect from Spotify'),
              ),
              SizedBox(height: 20), // Adding some spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 166, 0), // background
                  foregroundColor: Colors.white, // foreground
                ),
                onPressed: () {
                  print("pressed here");
                  startKlub1000();
                },
                child: Text('Start Klub 1000'),
              ),
              MyPlayerWidget()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startKlub1000() async {
    try {
      await SpotifySdk.play(
          spotifyUri: "spotify:playlist:37i9dQZF1DX4dyzvuaRJ0n");
      _MyPlayerWidgetState()._updatePlayerState();
      print("Started Klub 1000");
    } catch (e) {
      print(e);
    }
  }

  Future<void> disconnectFromSpotify() async {
    try {
      await SpotifySdk.disconnect();
      print("Disconnected from Spotify");
      Global.isSpotifyConnected = false;
    } catch (e) {
      print(e);
    }
  }

  Future<void> authenticateWithSpotify() async {
    try {
      print(dotenv.env['CLIENT_ID'].toString());
      await SpotifySdk.connectToSpotifyRemote(
        clientId: dotenv.env['CLIENT_ID'].toString(),
        redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
        scope:
            "app-remote-control, user-read-playback-state, user-modify-playback-state",
      );
      print("Connected to Spotify");
      Global.isSpotifyConnected = true;
    } catch (e) {
      print(e);
    }
  }
}
