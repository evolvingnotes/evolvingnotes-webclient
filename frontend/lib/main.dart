import "package:flutter/material.dart";
import "login.dart" as login;
import "dashboard.dart" as dashboard;
import "global.dart" as G;
import "coursepage.dart" as coursepage;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: "Evolving Notes",
      initialRoute: "/login",
      routes: {
        "/login": (context) => login.LoginScreen(),
        "/dashboard": (context) => dashboard.Dashboard(),
        "/course": (context) => coursepage.CoursePage(),
      },
      theme: ThemeData(
        primaryColor: Colors.pink,
        accentColor: Colors.pink,
        backgroundColor: Colors.grey[100],
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: G.DefaultScroll(),
          child: child,
        );
      },
    );
  }
}
