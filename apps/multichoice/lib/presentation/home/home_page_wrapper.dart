import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => coreSl<ProductBloc>(),
        ),
        BlocProvider(
          create: (_) => coreSl<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => coreSl<DetailsBloc>(),
        ),
      ],
      child: const HomePage(),
    );
  }
}
