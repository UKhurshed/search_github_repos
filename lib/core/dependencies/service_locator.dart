import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  void registerDependency(BuildContext context) {
    getIt.registerSingleton<AppLocalizations>(AppLocalizations.of(context)!);
  }
}
