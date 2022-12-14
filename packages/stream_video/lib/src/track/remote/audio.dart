import 'package:stream_video/src/track/remote/remote.dart';
import 'package:stream_video/src/track/track.dart';
import 'package:stream_video/src/track/web/audio_api.dart'
    if (dart.library.html) '../web/audio_html.dart' as audio;

class RemoteAudioTrack extends RemoteTrack with AudioTrack {
  RemoteAudioTrack({
    required super.type,
    required super.mediaStream,
    required super.mediaStreamTrack,
    super.receiver,
  });

  @override
  Future<bool> start() async {
    final didStart = await super.start();
    if (didStart) {
      // web support
      audio.startAudio(cid, mediaStreamTrack);
    }
    return didStart;
  }

  @override
  Future<bool> stop() async {
    final didStop = await super.stop();
    if (didStop) {
      // web support
      audio.stopAudio(cid);
    }
    return didStop;
  }
}
