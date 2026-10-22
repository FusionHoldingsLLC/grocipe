import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:grocipe/ui/provider/main_provider.dart';
import 'package:grocipe/ui/provider/recipe_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => RecipeProvider()),
    ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
    ChangeNotifierProvider(create: (_) => MainProvider()),
  ];
}
