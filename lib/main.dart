import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api/dio_client.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/home/data/products_repository.dart';
import 'features/home/logic/products_cubit.dart';
import 'features/shop/logic/shop_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = DioClient.create();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(dio)),
        RepositoryProvider(create: (_) => ProductsRepository(dio)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(context.read<AuthRepository>())),
          BlocProvider(create: (context) => ProductsCubit(context.read<ProductsRepository>())..loadProducts()),
          BlocProvider(create: (_) => ShopCubit()),
        ],
        child: const Task4App(),
      ),
    ),
  );
}

class Task4App extends StatelessWidget {
  const Task4App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'E-commerce app',
        routerConfig: appRouter,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF40BFFF)),
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          fontFamily: 'Arial',
        ),
      );
}
