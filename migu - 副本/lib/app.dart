import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/user_provider.dart';
import 'providers/video_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/warehouse_provider.dart';
import 'providers/message_provider.dart';
import 'config/routes.dart';

class NongDuanApp extends StatelessWidget {
  const NongDuanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => WarehouseProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MaterialApp(
        title: '农短视频',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationPage(),
      ),
    );
  }
}
