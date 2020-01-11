import "package:flutter/material.dart";
import "global.dart";

class CoursePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final Course course = ModalRoute.of(context).settings.arguments;

		return Scaffold(
			backgroundColor: Theme.of(context).backgroundColor,
			body: Scrollbar(
				child: TopBar(
					mode: TopBar.top,
					centerPiece: Container(
						child: Text(course.toString()),
					),
				),
			),
		);
	}
}
