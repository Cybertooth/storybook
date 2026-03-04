import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/export_service.dart';
import 'database_provider.dart';

final exportServiceProvider = Provider<ExportService>(
    (ref) => ExportService(ref.watch(databaseProvider)));
