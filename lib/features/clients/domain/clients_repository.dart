import 'client.dart';
import 'site_mission.dart';

/// Contrat local-first clients + sites/missions (voir impl. dans `data/clients_repository.dart`).
abstract class ClientsRepository {
  Future<void> initialize();

  List<Client> get clients;

  List<SiteMission> get sites;

  Client? getClientById(String id);

  SiteMission? getSiteById(String id);

  List<SiteMission> sitesForClient(String clientId);

  void addClient(Client client);

  void updateClient(Client client);

  void deleteClient(String id);

  void addSite(SiteMission site);

  void updateSite(SiteMission site);

  void deleteSite(String id);
}
