import '../../clients/domain/client.dart';
import '../../clients/domain/site_mission.dart';

class ActiveSession {
  final Client client;
  final SiteMission site;

  const ActiveSession({
    required this.client,
    required this.site,
  });

  ActiveSession copyWith({
    Client? client,
    SiteMission? site,
  }) {
    return ActiveSession(
      client: client ?? this.client,
      site: site ?? this.site,
    );
  }
}
