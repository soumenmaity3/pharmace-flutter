import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/auth/secure_storage_service.dart';
import 'package:pharmace/Frontend/responsive_utils.dart';
import 'package:pharmace/Frontend/screens/auth_screens/add_shop_screen.dart';
import 'package:pharmace/Frontend/screens/auth_screens/login_screen.dart';
import 'package:pharmace/Frontend/screens/auth_screens/signup_screen.dart';
import 'package:pharmace/Frontend/screens/auth_screens/splash_screen.dart';
import 'package:pharmace/Frontend/screens/fragment_screen/employees_screen.dart';
import 'package:pharmace/Frontend/screens/fragment_screen/home_screen.dart';
import 'package:pharmace/Frontend/screens/fragment_screen/inventory_screen.dart';
import 'package:pharmace/Frontend/screens/fragment_screen/profile_screen.dart';
import 'package:pharmace/Frontend/screens/fragment_screen/sales_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Provider/database_provider.dart';
import 'package:pharmace/Provider/inventory_provider.dart';
import 'package:pharmace/Provider/sales_provider.dart';
import 'package:pharmace/Provider/owner_provider.dart';
import 'package:pharmace/Provider/recent_sales_provider.dart';
import 'package:pharmace/Provider/employee_provider.dart';
import 'package:pharmace/Provider/shop_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:pharmace/Provider/app_view_provider.dart';

import 'theme/app_theme.dart';

void main() async {
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(500, 700),
      minimumSize: Size(450, 365),
      center: true,
      title: 'My App',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(ProviderScope(child: PharmaceApp()));
}

class PharmaceApp extends ConsumerStatefulWidget {
  const PharmaceApp({super.key});

  @override
  ConsumerState<PharmaceApp> createState() => _PharmaceAppState();
}

class _PharmaceAppState extends ConsumerState<PharmaceApp> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();
  static Future<bool> _isTokenExpired() async {
    final token = await SecureStorageService.getToken();

    if (token == null || token.isEmpty) {
      return true;
    }

    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  Future<void> _clearAllData() async {
    final db = ref.read(databaseProvider);
    await db.ownerAuthDao.deleteOwner();
    await db.billDao.deleteAllData();
    await db.inventoryMedicineDao.deleteAllData();
    await db.shopDao.deleteAllData();
    await db.employeeDao.deleteAll();
    await SecureStorageService.deleteToken();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.deviceType(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Pharmace',

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.system,

      scrollBehavior: MaterialScrollBehavior().copyWith(scrollbars: false),

      home: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: switch (ref.watch(appViewProvider)) {
          AppView.splash => SplashScreen(
            key: const ValueKey('splash'),
            onFinished: () async {
              final isExpired = await _isTokenExpired();
              if (isExpired) {
                await _clearAllData();
                if (!mounted) return;
                setState(() {
                  _selectedIndex = 0;
                });
                ref.read(appViewProvider.notifier).state = AppView.login;
                return;
              }

              final db = ref.read(databaseProvider);
              final shopOwnerModel = await db.ownerAuthDao.getOwner();

              if (!mounted) return;

              final result = await _apiService.isHaveThisOwner();
              final bool isHaveThisOwner = result.data ?? false;
              final bool haveShop = shopOwnerModel?.isShopHave ?? false;

              if (!mounted) return;

              if (!isHaveThisOwner) {
                await _clearAllData();
              }

              setState(() {
                _selectedIndex = 0;
              });

              if (isHaveThisOwner) {
                ref.read(appViewProvider.notifier).state =
                    haveShop ? AppView.dashboard : AppView.addScreen;
              } else {
                ref.read(appViewProvider.notifier).state = AppView.login;
              }
            },
          ),
          AppView.addScreen => AddShopScreen(
            key: const ValueKey('addScreen'),
            onCompleted: () {
              ref.read(appViewProvider.notifier).state = AppView.login;
            },
          ),
          AppView.login => LoginScreen(
            key: ValueKey('login'),
            onLogin: () async {
              ref.invalidate(ownerProvider);
              ref.invalidate(shopProvider);
              ref.invalidate(inventoryProvider);
              ref.invalidate(salesProvider);
              ref.invalidate(recentSalesProvider);
              ref.invalidate(employeeProvider);
              ref.read(appViewProvider.notifier).state = AppView.dashboard;
            },
            onCreateAccount: () =>
                ref.read(appViewProvider.notifier).state = AppView.signup,
          ),
          AppView.signup => SignupScreen(
            key: ValueKey('signup'),
            onSignup: () async {
              ref.invalidate(ownerProvider);
              ref.invalidate(shopProvider);
              ref.invalidate(inventoryProvider);
              ref.invalidate(salesProvider);
              ref.invalidate(recentSalesProvider);
              ref.invalidate(employeeProvider);
              ref.read(appViewProvider.notifier).state = AppView.dashboard;
            },
            onSignIn: () =>
                ref.read(appViewProvider.notifier).state = AppView.login,
          ),
          AppView.dashboard =>
            deviceType == DeviceType.mobile
                ? _buildMainScaffold()
                : Container(decoration: BoxDecoration(color: Colors.red)),
        },
      ),
    );
  }

  Widget _buildMainScaffold() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color unselectedColor = isDark
        ? AppColors.white
        : AppColors.lightTextTertiary;

    return Scaffold(
      body: [
        HomeScreen(),
        SalesScreen(),
        InventoryScreen(),
        EmployeesScreen(),
        ProfileScreen(
          onLogout: () async {
            final db = ref.read(databaseProvider);
            await db.ownerAuthDao.deleteOwner();
            await db.inventoryMedicineDao.deleteAllData();
            await db.shopDao.deleteAllData();
            await db.billDao.deleteAllData();
            await SecureStorageService.deleteToken();
            ref.invalidate(ownerProvider);
            ref.invalidate(shopProvider);
            ref.invalidate(inventoryProvider);
            ref.invalidate(salesProvider);
            ref.invalidate(recentSalesProvider);
            ref.invalidate(employeeProvider);

            if (!mounted) return;
            setState(() {
              _selectedIndex = 0;
            });
            ref.read(appViewProvider.notifier).state = AppView.login;
          },
        ),
      ][_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 64,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            overlayColor: WidgetStateProperty.resolveWith((state) {
              return Colors.transparent;
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(color: AppColors.primary, size: 28);
              }

              return IconThemeData(color: unselectedColor);
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                );
              }

              return TextStyle(color: unselectedColor);
            }),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: _svgNavIcon(
                  "assets/icons/home_outline.svg",
                  unselectedColor,
                ),
                label: "Home",
                selectedIcon: _svgNavIcon(
                  "assets/icons/home_outline.svg",
                  AppColors.primary,
                ),
              ),
              NavigationDestination(
                icon: _svgNavIcon("assets/icons/sales_up.svg", unselectedColor),
                label: "Sales",
                selectedIcon: _svgNavIcon(
                  "assets/icons/sales_up.svg",
                  AppColors.primary,
                ),
              ),
              NavigationDestination(
                icon: _svgNavIcon(
                  "assets/icons/inventory_outline.svg",
                  unselectedColor,
                ),
                label: "Inventory",
                selectedIcon: _svgNavIcon(
                  "assets/icons/inventory_outline.svg",
                  AppColors.primary,
                ),
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                label: "Employees",
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _svgNavIcon(String path, Color color) {
    return SvgPicture.asset(
      path,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}


