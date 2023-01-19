import '../../types/other.dart';
import '../model/call_cid.dart';
import 'peer_connection_factory.dart';
import 'rtc_manager.dart';

class RtcManagerFactory {
  RtcManagerFactory({
    required this.sessionId,
    required this.callCid,
    required this.configuration,
    this.mediaConstraints = const {},
  }) : pcFactory = StreamPeerConnectionFactory(
          sessionId: sessionId,
          callCid: callCid,
        );

  final String sessionId;
  final StreamCallCid callCid;
  final RTCConfiguration configuration;
  final StreamPeerConnectionFactory pcFactory;
  final Map<String, dynamic> mediaConstraints;

  Future<RtcManager> makeRtcManager(String localTrackId) async {
    final publisher = await pcFactory.makePublisher(
      configuration,
      mediaConstraints,
    );
    final subscriber = await pcFactory.makeSubscriber(
      configuration,
      mediaConstraints,
    );

    return RtcManager(
      sessionId: sessionId,
      callCid: callCid,
      localTrackId: localTrackId,
      publisher: publisher,
      subscriber: subscriber,
    );
  }
}
