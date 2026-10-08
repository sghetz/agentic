import 'config.dart';
import 'repositories/org_store.dart';
import 'repositories/registry_store.dart';
import 'services/analyst_extraction_service.dart';
import 'services/chat_stream_hub.dart';
import 'services/claude_conversation_service.dart';
import 'services/erf_import_service.dart';
import 'services/failure_diagnosis_service.dart';
import 'services/flutter_version_detector.dart';
import 'services/git_service.dart';
import 'services/health_check_service.dart';
import 'services/health_runner.dart';
import 'services/onboarding_service.dart';
import 'services/trivial_fix_service.dart';
import 'storage/org_database.dart';
import 'storage/registry_database.dart';

/// Holds the registry store plus a cache of opened [OrgStore]s. Resolving
/// an orgId always checks the registry first, so an unknown orgId -- or
/// one that belongs to a database that was never opened -- behaves exactly
/// like a nonexistent id (`null`), never like a second organization's data.
class AppContext {
  AppContext({
    required this.registryStore,
    required OrgDatabase Function(String orgId) openOrgDatabase,
    required this.onboardingService,
    required this.healthCheckService,
    required this.trivialFixService,
    required this.paths,
    this.conversationService = const ClaudeConversationService(),
    this.analystExtractionService = const AnalystExtractionService(),
    ErfImportService? erfImportService,
    ChatStreamHub? chatStreamHub,
  }) : _openOrgDatabase = openOrgDatabase,
       chatStreamHub = chatStreamHub ?? ChatStreamHub(),
       erfImportService =
           erfImportService ??
           ErfImportService(extractionService: analystExtractionService);

  factory AppContext.standard(AgenticPaths paths) {
    const gitService = GitService();
    const detector = FlutterVersionDetector();
    const runner = HealthRunner();
    return AppContext(
      registryStore: RegistryStore(RegistryDatabase.file(paths.registryDbPath)),
      openOrgDatabase: (orgId) => OrgDatabase.file(paths.orgDbPath(orgId)),
      onboardingService: OnboardingService(
        paths: paths,
        gitService: gitService,
        detector: detector,
      ),
      healthCheckService: HealthCheckService(
        paths: paths,
        gitService: gitService,
        detector: detector,
        runner: runner,
        diagnosisService: const FailureDiagnosisService(),
      ),
      trivialFixService: TrivialFixService(
        paths: paths,
        gitService: gitService,
        runner: runner,
      ),
      paths: paths,
    );
  }

  final RegistryStore registryStore;
  final OnboardingService onboardingService;
  final HealthCheckService healthCheckService;
  final TrivialFixService trivialFixService;
  final ClaudeConversationService conversationService;
  final AnalystExtractionService analystExtractionService;
  final ErfImportService erfImportService;
  final ChatStreamHub chatStreamHub;
  final AgenticPaths paths;
  final OrgDatabase Function(String orgId) _openOrgDatabase;
  final Map<String, OrgStore> _orgStores = {};

  Future<OrgStore?> orgStore(String orgId) async {
    final cached = _orgStores[orgId];
    if (cached != null) return cached;

    if (await registryStore.get(orgId) == null) return null;

    final store = OrgStore(orgId, _openOrgDatabase(orgId));
    _orgStores[orgId] = store;
    return store;
  }

  Future<void> close() async {
    for (final store in _orgStores.values) {
      await store.close();
    }
  }
}
