import 'package:budz/bloc/external/external.dart';
import 'package:budz/bloc/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:budz/utils/picture_paths.dart';
import 'package:budz/modules/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserAccCubit>(
      create: (context) => UserAccCubit(doGetUserData: UserDataExternal()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          primaryColor: Colors.blueAccent,
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      pageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          ProfilePage(),
        ],
        // onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              PicturePaths.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              PicturePaths.journey,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              PicturePaths.chatbot,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              PicturePaths.profileBlue,
            ),
          ),
        ],
        currentIndex: 0,
        activeColor: Colors.brown,
        inactiveColor: Colors.grey,
      ),
    );
  }
}
