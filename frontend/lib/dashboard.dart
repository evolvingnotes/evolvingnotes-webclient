import "package:flutter/material.dart";
import "package:expandable/expandable.dart";
import "global.dart";

class Dashboard extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Theme.of(context).backgroundColor,
			body: Scrollbar(
				child: TopBar(
					mode: TopBar.top,
					centerPiece: DashboardContent(),
				),
			),
		);
	}
}

class DashboardContent extends StatefulWidget {
	@override
	_DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> with TickerProviderStateMixin {
	final ExpandableController _controllerExpansionActive = ExpandableController();
	final ExpandableController _controllerExpansionArchived = ExpandableController();
	AnimationController _controllerAnimationActive;
	AnimationController _controllerAnimationArchived;
	Animatable<Color> _color;

	@override
	void initState() {
		super.initState();
		_controllerExpansionActive.expanded = true;
		_controllerAnimationActive = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 200),
		);
		_controllerAnimationArchived = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 200),
		);
		_color = ColorTween(
			begin: Colors.white,
			end: Colors.pink.withOpacity(0.5),
		);
	}

	@override
	void dispose() {
		_controllerAnimationActive.dispose();
		_controllerAnimationArchived.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Align(
			alignment: Alignment.topCenter,
			child: SingleChildScrollView(
				child: Padding(
					padding: EdgeInsets.all(16),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							GestureDetector(
								child: Listener(
									child: Expandable(
										controller: _controllerExpansionActive,
										expanded: Card(
											color: Colors.white,
											child: ContentColumn(
												type: ContentColumn.active,
												expanded: true,
											),
										),
										collapsed:AnimatedBuilder(
											animation: _controllerAnimationActive,
											child: ContentColumn(
												type: ContentColumn.active,
												expanded: false,
											),
											builder: (context, child) {
												return Card(
													color: _color.evaluate(AlwaysStoppedAnimation(_controllerAnimationActive.value)),
													child: child,
												);
											},
										),
									),
									onPointerEnter: (event) {
										_controllerAnimationActive.animateTo(1);
									},
									onPointerExit: (event) {
										_controllerAnimationActive.animateTo(0);
									},
								),
								onTap: () {
									if (!_controllerExpansionActive.expanded) {
										setState(() {
											_controllerExpansionActive.toggle();
											_controllerExpansionArchived.toggle();
										});
									}
								},
							),
							Divider(),
							GestureDetector(
								child: Listener(
									child: Expandable(
										controller: _controllerExpansionArchived,
										expanded: Card(
											color: Colors.white,
											child: ContentColumn(
												type: ContentColumn.archived,
												expanded: true,
											),
										),
										collapsed: AnimatedBuilder(
											animation: _controllerAnimationArchived,
											child: ContentColumn(
												type: ContentColumn.archived,
												expanded: false,
											),
											builder: (context, child) {
												return Card(
													color: _color.evaluate(AlwaysStoppedAnimation(_controllerAnimationArchived.value)),
													child: child,
												);
											},
										),
									),
									onPointerEnter: (event) {
										_controllerAnimationArchived.animateTo(1);
									},
									onPointerExit: (event) {
										_controllerAnimationArchived.animateTo(0);
									},
								),
								onTap: () {
									if (!_controllerExpansionArchived.expanded) {
										setState(() {
											_controllerExpansionArchived.toggle();
											_controllerExpansionActive.toggle();
										});
									}
								},
							),
						],
					),
				),
			),
		);
	}
}

// Obtain course information from somwhere (store as object in global)
// Reason for doing so is so that we don't need to reload everything.
// Just store all user related information because this method is called
// everytime there is a collapse/expand. Do all the loading in the same phase
// as the login.
Widget _getContent(String type) {
	List<Course> courses;

	if (type == ContentColumn.active) {
		courses = [
			Course(
				id: "10.007",
				title: "Modelling the Systems World",
				progress: 0.5895395254121474,
			),
			Course(
				id: "10.008",
				title: "Engineering in the Physical World",
				progress: 0.593885837123569,
			),
			Course(
				id: "10.009",
				title: "The Digital World",
				progress: 0.87363116267133,
			),
			Course(
				id: "10.011",
				title: "Introduction to Physical Chemistry",
				progress: 0.08510187734673058,
			),
			Course(
				id: "10.012",
				title: "Introduction to Biology",
				progress: 0.8556604775422854,
			),
		];
	} else if (type == ContentColumn.archived) {
		courses = [
			Course(
				id: "02.003",
				title: "Theorizing Society, the Self, and Culture",
				progress: 0.6624654780236179,
			),
			Course(
				id: "03.007",
				title: "Introduction to Cancer",
				progress: 0.7326873884865354,
			),
			Course(
				id: "10.004",
				title: "Advanced Math II",
				progress: 0.4793653604257845,
			),
			Course(
				id: "10.005",
				title: "Physics II",
				progress: 0.29227195937616346,
			),
		];
	}

	return Padding(
		padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
		child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: courses.map((course) => CourseCard(course: course)).toList(),
		),
	);
}

class CourseCard extends StatefulWidget {
	final Course course;

	const CourseCard({
		Key key,
		@required this.course,
	}) : super(key: key);

	@override
	_CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> with SingleTickerProviderStateMixin {
	AnimationController _controllerAnimation;
	Animatable<Color> _color;

	@override
	void initState() {
		super.initState();
		_controllerAnimation = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 200),
		);
		_color = ColorTween(
			begin: Colors.white,
			end: Colors.pink.withOpacity(0.5),
		);
	}

	@override
	void dispose() {
		_controllerAnimation.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			child: Listener(
			child: AnimatedBuilder(
					animation: _controllerAnimation,
					child: Padding(
						padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
						child: Row(
							children: [
								Expanded(
									child: Align(
										alignment: Alignment.centerLeft,
										child: Text(
											widget.course.toString(),
											style: isWeb() ? TextStyle(fontSize: 24) : TextStyle(fontSize: 14),
										),
									),
								),
								Expanded(
									child: Align(
										alignment: Alignment.centerRight,
										child: SizedBox(
											height: 10,
											width: 400,
											child: LinearProgressIndicator(
												value: widget.course.progress,
												valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
												backgroundColor: Colors.grey[300],
											),
										),
									),
								),
							],
						),
					),
					builder: (context, child) {
						return Card(
							elevation: 0,
							color: _color.evaluate(AlwaysStoppedAnimation(_controllerAnimation.value)),
							child: child,
						);
					},
				),
				onPointerEnter: (event) {
					_controllerAnimation.animateTo(1);
				},
				onPointerExit: (event) {
					_controllerAnimation.animateTo(0);
				},
			),
			onTap: () {
				Navigator.pushNamed(
					context,
					"/course",
					arguments: widget.course
				);
			},
		);
	}
}

class ContentColumn extends StatelessWidget {
	final bool expanded;
	final String type;

	static const String active = "ACTIVE";
	static const String archived = "ARCHIVED";

	const ContentColumn({
		Key key,
		@required this.expanded,
		@required this.type,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		String title;

		if (type == active) {
			title = "Active Courses";
		} else if (type == archived) {
			title = "Archived Courses";
		}

		Widget header = Padding(
			padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
			child: Text(
				title,
				style: isWeb() ? TextStyle(fontSize: 42) : TextStyle(fontSize: 36),
			),
		);

		if (expanded) {
			Widget content = _getContent(type);
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					header,
					content,
				],
			);
		} else {
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					header,
				],
			);
		}
	}
}
