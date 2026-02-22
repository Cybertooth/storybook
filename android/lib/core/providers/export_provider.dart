import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/export_service.dart';

final exportServiceProvider = Provider<ExportService>((_) => ExportService());
