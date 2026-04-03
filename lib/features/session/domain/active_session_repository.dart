import 'active_session.dart';

/// Accès à la session terrain active en mémoire (hors sync).
abstract class ActiveSessionRepository {
  ActiveSession? get currentSession;

  bool get hasSession;

  void startSession(ActiveSession session);

  void endSession();
}
