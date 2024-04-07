import 'package:one_fa/util/supabase_query.dart';

querySystem supabase_connector = querySystem();

extension StringExtensions on String {
  String capitalize() {
    final list = this.split(' ');
    final modlist = [];
    for (String l in list) {
      modlist.add(l[0].toUpperCase() + l.substring(1));
    }
    return modlist.join(' ');
  }

  String reverse() => this.split('').reversed.join('');
}

