import 'package:plantnfc/features/scan/data/nfc_manager_service.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfc_providers.g.dart';

/// The platform NFC service. Tests override this with a fake.
@Riverpod(keepAlive: true)
NfcService nfcService(Ref ref) => NfcManagerService();

/// Whether NFC is usable right now. Refresh it when the app resumes, because
/// the user may have turned NFC on in settings.
@riverpod
Future<NfcAvailability> nfcAvailability(Ref ref) =>
    ref.watch(nfcServiceProvider).availability();
