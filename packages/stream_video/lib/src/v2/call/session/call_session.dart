import '../../../../stream_video.dart';
import '../../../disposable.dart';
import '../../action/call_control_action.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';

abstract class CallSession extends Disposable {
  String get sessionId;

  SharedEmitter<SfuEventV2> get events;

  Future<Result<None>> start();

  Future<Result<None>> apply(SessionControlAction action);

  List<RtcTrack> getTracks(String userId);

  RtcTrack? getTrack(String userId, SfuTrackType trackType);

  void updateTrackSize({
    required String userId,
    required SfuTrackType trackType,
    required double width,
    required double height,
  });
}
