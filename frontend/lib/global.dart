import "dart:math";
import "package:path/path.dart";
import "package:flutter/material.dart";

const String local = "http://127.0.0.1:5000";
const String api = "http://35.247.131.102/api";
const String test = "https://jsonplaceholder.typicode.com/posts/1";
Random random = Random();

class Course {
	String id;
	String title;
	double progress;

	Course({this.id, this.title, this.progress});

	String toString() {
		return id + "\t" + title;
	}
}

class User {
	String id;
	String name;
	Map<String, Course> courses;

	User({this.id, this.name, this.courses});
}

class DefaultScroll extends ScrollBehavior {
	@override
	Widget buildViewportChrome(
		BuildContext context, Widget child, AxisDirection axisDirection) {
		return child;
	}
}

void navigateTo(BuildContext context, String route) {
	if (ModalRoute.of(context).settings.name != route) Navigator.pushNamed(context, route);
}

bool isWeb() {
	return identical(0, 0.0);
}

class TopBar extends StatelessWidget {
	final Widget centerPiece;
	final String mode;

	static const String sides = "SIDES";
	static const String top = "TOP";

	const TopBar ({
		Key key,
		@required this.mode,
		@required this.centerPiece,
	}) : super(key: key);

	void _homePressed(BuildContext context) {
		navigateTo(context, "/dashboard");
	}

	void _personPressed(BuildContext context) {
		// Profile page or something
	}


	@override
	Widget build(BuildContext context) {
		if (mode == sides) {
			return SafeArea(
				child: Row(
					mainAxisSize: MainAxisSize.max,
					children: [
						Align(
							alignment: Alignment.topLeft,
							child: OutlineButton(
								child: Icon(Icons.home),
								onPressed: () => _homePressed(context),
							),
						),
						Expanded(
							child: centerPiece,
						),
						Align(
							alignment: Alignment.topRight,
							child: OutlineButton(
								child: Icon(Icons.person),
								onPressed: () => _personPressed(context),
							),
						),
					],
				),
			);
		} else if (mode == top) {
			return SafeArea(
				child: Column(
					mainAxisSize: MainAxisSize.max,
					children: [
						Row(
							children: [
								Expanded(
									child: Align(
										alignment: Alignment.topLeft,
										child: OutlineButton(
											child: Icon(Icons.home),
											onPressed: () => _homePressed(context),
										),
									),
								),
								Expanded(
									child: Align(
										alignment: Alignment.topRight,
										child: OutlineButton(
											child: Icon(Icons.person),
											onPressed: () => _personPressed(context),
										),
									),
								),
							],
						),
						Expanded(
							child: centerPiece,
						),
					],
				),
			);
		}
		
	}
}