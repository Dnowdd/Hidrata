import 'package:flutter/material.dart';
import 'config_controller.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final controller = ConfigController();
  final TextEditingController rapidDrinkController = TextEditingController();
  final TextEditingController dailyGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadDailyGoal().then((_) {
      dailyGoalController.text = controller.dailyGoal.toString();
      setState(() {});
    });
    controller.loadRapidDrink().then((_) {
      rapidDrinkController.text = controller.rapidDrink.toString();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  'Quantidade rápida padrão (ml)',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: rapidDrinkController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Ex: 250',
                    prefixIcon: const Icon(Icons.local_drink_outlined),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                Text(
                  'Meta diária (ml)',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: dailyGoalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Ex: 2500',
                    prefixIcon: const Icon(Icons.flag),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final rapidDrink = int.tryParse(rapidDrinkController.text) ?? 0;
                  final dailyGoal = int.tryParse(dailyGoalController.text) ?? 0;

                  await controller.setRapidDrink(rapidDrink);
                  await controller.setDailyGoal(dailyGoal);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configurações salvas!')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
