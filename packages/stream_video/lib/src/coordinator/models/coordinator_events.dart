import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/call_cid.dart';
import '../../models/call_metadata.dart';
import '../../models/call_permission.dart';

/// Represents the events coming in from the socket.
@immutable
abstract class CoordinatorEvent with EquatableMixin {
  const CoordinatorEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

/// Sent one time after successful connection.
class CoordinatorConnectedEvent extends CoordinatorEvent {
  const CoordinatorConnectedEvent({
    required this.clientId,
    required this.userId,
  });

  final String clientId;
  final String userId;

  @override
  List<Object?> get props => [clientId, userId];
}

/// Fired when web socket is closed.
class CoordinatorDisconnectedEvent extends CoordinatorEvent {
  const CoordinatorDisconnectedEvent({
    this.clientId,
    this.userId,
    this.closeCode,
    this.closeReason,
  });

  final String? clientId;
  final String? userId;
  final int? closeCode;
  final String? closeReason;

  @override
  List<Object?> get props => [clientId, userId, closeCode, closeReason];
}

/// Sent periodically by the server to keep the connection alive.
class CoordinatorHealthCheckEvent extends CoordinatorEvent {
  const CoordinatorHealthCheckEvent({
    required this.clientId,
  });

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

abstract class CoordinatorCallEvent extends CoordinatorEvent {
  const CoordinatorCallEvent({required this.callCid});

  final StreamCallCid callCid;

  @override
  List<Object?> get props => [callCid];
}

/// Sent when someone creates a call and invites another person to participate.
class CoordinatorCallCreatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallCreatedEvent({
    required super.callCid,
    required this.ringing,
    required this.createdAt,
    required this.metadata,
  });

  final bool ringing;
  final DateTime createdAt;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [
        ...super.props,
        ringing,
        createdAt,
        metadata,
      ];
}

/// Sent when a call gets updated.
class CoordinatorCallUpdatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallUpdatedEvent({
    required super.callCid,
    required this.metadata,
    required this.capabilitiesByRole,
    required this.createdAt,
  });

  final CallMetadata metadata;
  final Map<String, List<String>> capabilitiesByRole;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        metadata,
        capabilitiesByRole,
        createdAt,
      ];
}

/// Sent when a calls gets ended.
class CoordinatorCallEndedEvent extends CoordinatorCallEvent {
  const CoordinatorCallEndedEvent({
    required super.callCid,
    required this.endedBy,
    required this.createdAt,
  });

  final CallUser? endedBy;
  final DateTime createdAt;

  String? get endedByUserId => endedBy?.id;

  @override
  List<Object?> get props => [
        ...super.props,
        endedBy,
        createdAt,
      ];
}

/// Sent when a user accepts the call.
class CoordinatorCallAcceptedEvent extends CoordinatorCallEvent {
  const CoordinatorCallAcceptedEvent({
    required super.callCid,
    required this.acceptedBy,
    required this.createdAt,
  });

  final CallUser acceptedBy;
  final DateTime createdAt;

  String get acceptedByUserId => acceptedBy.id;

  @override
  List<Object?> get props => [
        ...super.props,
        acceptedBy,
        createdAt,
      ];
}

/// Sent when a user rejects the call.
class CoordinatorCallRejectedEvent extends CoordinatorCallEvent {
  const CoordinatorCallRejectedEvent({
    required super.callCid,
    required this.rejectedBy,
    required this.createdAt,
  });

  final CallUser rejectedBy;
  final DateTime createdAt;

  String get rejectedByUserId => rejectedBy.id;

  @override
  List<Object?> get props => [
        ...super.props,
        rejectedBy,
        createdAt,
      ];
}

class CoordinatorCallPermissionRequestEvent extends CoordinatorCallEvent {
  const CoordinatorCallPermissionRequestEvent({
    required super.callCid,
    required this.createdAt,
    required this.permissions,
    required this.user,
  });

  final DateTime createdAt;
  final List<String> permissions;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        permissions,
        user,
      ];
}

class CoordinatorCallPermissionsUpdatedEvent extends CoordinatorCallEvent {
  const CoordinatorCallPermissionsUpdatedEvent({
    required super.callCid,
    required this.createdAt,
    required this.ownCapabilities,
    required this.user,
  });

  final DateTime createdAt;
  final Iterable<CallPermission> ownCapabilities;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        ownCapabilities,
        user,
      ];
}

class CoordinatorCallRecordingStartedEvent extends CoordinatorCallEvent {
  const CoordinatorCallRecordingStartedEvent({
    required super.callCid,
    required this.createdAt,
  });

  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

class CoordinatorCallRecordingStoppedEvent extends CoordinatorCallEvent {
  const CoordinatorCallRecordingStoppedEvent({
    required super.callCid,
    required this.createdAt,
  });

  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

class CoordinatorCallBroadcastingStartedEvent extends CoordinatorCallEvent {
  const CoordinatorCallBroadcastingStartedEvent({
    required super.callCid,
    required this.hlsPlaylistUrl,
    required this.createdAt,
  });

  final String hlsPlaylistUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        hlsPlaylistUrl,
        createdAt,
      ];
}

class CoordinatorCallBroadcastingStoppedEvent extends CoordinatorCallEvent {
  const CoordinatorCallBroadcastingStoppedEvent({
    required super.callCid,
    required this.createdAt,
  });

  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

class CoordinatorCallUserBlockedEvent extends CoordinatorCallEvent {
  const CoordinatorCallUserBlockedEvent({
    required super.callCid,
    required this.createdAt,
    required this.user,
  });

  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [...super.props, createdAt, user];
}

class CoordinatorCallUserUnblockedEvent extends CoordinatorCallEvent {
  const CoordinatorCallUserUnblockedEvent({
    required super.callCid,
    required this.createdAt,
    required this.user,
  });

  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [...super.props, createdAt, user];
}

class CoordinatorCallReactionEvent extends CoordinatorCallEvent {
  const CoordinatorCallReactionEvent({
    required super.callCid,
    required this.createdAt,
    required this.reactionType,
    required this.user,
    this.emojiCode,
    this.custom = const {},
  });

  final DateTime createdAt;
  final String reactionType;
  final String? emojiCode;
  final CallUser user;
  final Map<String, Object>? custom;

  @override
  List<Object?> get props => [...super.props, createdAt, emojiCode, custom];
}

class CoordinatorCallCustomEvent extends CoordinatorCallEvent {
  const CoordinatorCallCustomEvent({
    required super.callCid,
    required this.senderUserId,
    required this.createdAt,
    required this.eventType,
    required this.users,
    required this.custom,
  });

  final String senderUserId;
  final DateTime createdAt;
  final String eventType;
  final Map<String, Object>? custom;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        senderUserId,
        createdAt,
        eventType,
        custom,
        users,
      ];
}

// Unknown event.
class CoordinatorUnknownEvent extends CoordinatorEvent {
  const CoordinatorUnknownEvent();
}
