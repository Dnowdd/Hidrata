import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  int totalMl = 0;

  Future<void> loadTotal() async {
    final prefs = await SharedPreferences.getInstance();

    // Pega a data salva
    final lastSavedDate = prefs.getString('lastSavedDate');

    // Data de hoje (só parte da data, sem hora)
    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month}-${today.day}";

    // Se não tem data ou é de outro dia → zera
    if (lastSavedDate == null || lastSavedDate != todayStr) {
      totalMl = 0;
      await prefs.setInt('totalWater', 0);
      await prefs.setString('lastSavedDate', todayStr);
    } else {
      // Se for o mesmo dia → carrega valor
      totalMl = prefs.getInt('totalWater') ?? 0;
    }
  }

  Future<void> drinkWater(int amount) async {
    totalMl += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalWater', totalMl);

    // Atualiza a data
    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month}-${today.day}";
    await prefs.setString('lastSavedDate', todayStr);
  }

  Future<void> setWater(int amount) async {
    totalMl = amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalWater', totalMl);

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month}-${today.day}";
    await prefs.setString('lastSavedDate', todayStr);
  }
}
