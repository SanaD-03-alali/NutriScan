import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'models/classifier.dart';
import 'models/prediction_history.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/saved_barcodes_screen.dart';
import 'providers/saved_products_provider.dart';
import 'models/database_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Classifier.loadModel();
  await DatabaseService.initialize();  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<PredictionResult> _predictions = [];
  final List<Map<String, dynamic>> _savedBarcodes = [];

  void _addPrediction(PredictionResult prediction) {
    setState(() {
      _predictions.insert(0, prediction);
    });
  }

  void _addSavedProduct(Map<String, dynamic> product) {
    setState(() {
      _savedBarcodes.add(product);
    });
  }

  void _removeSavedProduct(String barcode) {
    setState(() {
      _savedBarcodes.removeWhere((product) => product['barcode'] == barcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SavedProductsProvider(
      savedProducts: _savedBarcodes,
      addProduct: _addSavedProduct,
      removeProduct: _removeSavedProduct,
      child: MaterialApp(
        title: 'NutriScan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              HomeScreen(onNewPrediction: _addPrediction),
              SavedBarcodesScreen(savedBarcodes: _savedBarcodes),
              HistoryScreen(predictions: _predictions),
            ],
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return TextStyle(
                      color: Colors.lightBlue[100],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    );
                  }
                  return TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  );
                }),
              ),
            ),
            child: NavigationBar(
              height: 65,
              backgroundColor: Colors.green[800],
              elevation: 0,
              selectedIndex: _selectedIndex,
              indicatorColor: Colors.lightBlue[700]!,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: FaIcon(
                    FontAwesomeIcons.house,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.house,
                    size: 22,
                    color: Colors.lightGreen[100],
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: FaIcon(
                    FontAwesomeIcons.bookmark,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.solidBookmark,
                    size: 22,
                    color: Colors.lightGreen[100],
                  ),
                  label: 'Products',
                ),
                NavigationDestination(
                  icon: FaIcon(
                    FontAwesomeIcons.list,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.listUl,
                    size: 22,
                    color: Colors.lightGreen[100],
                  ),
                  label: 'History',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
