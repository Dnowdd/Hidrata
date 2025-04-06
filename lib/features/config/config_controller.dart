import 'package:shared_preferences/shared_preferences.dart';

class ConfigController {
  int rapidDrink = 0;
  int dailyGoal = 0;

  Future<void> loadRapidDrink() async {
    final prefs = await SharedPreferences.getInstance();
    rapidDrink = prefs.getInt('rapidDrink') ?? 0;
  }

  Future<void> setRapidDrink(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rapidDrink', amount);
  }

  Future<void> loadDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    dailyGoal = prefs.getInt('dailyGoal') ?? 0;
  }

  Future<void> setDailyGoal(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyGoal', amount);
  }
}
