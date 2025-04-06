import 'package:flutter/material.dart';
import 'package:hidrata/features/config/config_controller.dart';
import 'package:intl/intl.dart';
import 'home_controller.dart';
import '../config/config_page.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final homeController = HomeController();
  final configController = ConfigController();

  @override
  void initState() {
    super.initState();

    homeController.loadTotal().then((_) {
      setState(() {});
    });
    loadConfig();

    _setTaskDescriptionColor();
    _setStatusBarColor();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
  void _setTaskDescriptionColor() {
    SystemChrome.setApplicationSwitcherDescription(
      const ApplicationSwitcherDescription(
        primaryColor: 0xFFFFFFFF,
      ),
    );
  }

  Future<void> loadConfig() async {
    await configController.loadDailyGoal();
    await configController.loadRapidDrink();
    setState(() {});
  }

  Future<void> _showWaterInputDialog({
    required BuildContext context,
    required String title,
    required void Function(int value) onConfirm,
  }) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(24),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Color(0xFF4E81FF),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Ex: 250 ml',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(
                Icons.water_drop_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              filled: true,
              fillColor: Color(0xFFF4F8FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Color(0xFF878787)),
              ),
            ),
            FilledButton(
              onPressed: () {
                final amount = int.tryParse(controller.text);
                if (amount != null) {
                  onConfirm(amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekday = DateFormat.EEEE('pt_BR').format(now);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF608DFF), Color(0xFFFFFFFF)],
            stops: [0, 0.55],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 65),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConfigPage(),
                              ),
                            );

                            await loadConfig();
                            setState(() {});
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'MUITO\nBEM',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 58,
                      fontWeight: FontWeight.w900,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    weekday[0].toUpperCase() + weekday.substring(1),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    '${homeController.totalMl}ml',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Color(0xFF4E81FF),
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 100),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Text(
                          'Meta diária',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: Color(0xFF4E81FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: LinearProgressIndicator(value: homeController.totalMl / configController.dailyGoal),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      children: [
                        Text(
                          '${homeController.totalMl}ml',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Color(0xFF4E81FF)),
                        ),
                        Expanded(child: Container()),
                        Text(
                          '${configController.dailyGoal}ml',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Color(0xFF4E81FF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      onPressed: () {
                        _showWaterInputDialog(
                          context: context,
                          title: 'Definir água bebida',
                          onConfirm: (amount) async {
                            await homeController.setWater(amount);
                            setState(() {});
                          },
                        );
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: CircleBorder(),
                      elevation: 1,
                      child: const Icon(Icons.edit),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await homeController.drinkWater(configController.rapidDrink);
                        setState(() {});
                      },
                      child: Text('Beber ${configController.rapidDrink}ml'),
                    ),
                    SizedBox(width: 12),
                    FloatingActionButton.small(
                      onPressed: () {
                        _showWaterInputDialog(
                          context: context,
                          title: 'Adicionar água bebida',
                          onConfirm: (amount) async {
                            await homeController.drinkWater(amount);
                            setState(() {});
                          },
                        );
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: CircleBorder(),
                      elevation: 1,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
