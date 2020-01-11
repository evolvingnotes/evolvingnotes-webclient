import "dart:async";
import "package:flutter/material.dart";
import "api.dart" as api;
import "global.dart" as G;

class LoginScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Theme.of(context).backgroundColor,
			body: Center(
				child: SizedBox(
					width: 400,
					child: Card(
						child: LoginForm(),
					),
				),
			)
		);
	}
}

class LoginForm extends StatefulWidget {
	@override
	_LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
	final TextEditingController _usernameController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	FocusNode _focusNode = FocusNode();
	bool _formComplete = false;

	List<TextEditingController> get controllers => [_usernameController, _passwordController];

	@override
	void initState() {
		super.initState();
		controllers.forEach((c) => c.addListener(() => _updateComplete()));
	}

	void _updateComplete() {
		for (var controller in controllers) {
			if (controller.value.text.isEmpty) {
				setState(() {
					_formComplete = false;
				});
				return;
			}
		}
		setState(() {
			_formComplete = true;
		});
	}

	void _login() async {
		var username = _usernameController.text;
		var password = _passwordController.text;

		showGeneralDialog(
			context: context,
			barrierDismissible: false,
			barrierColor: Color.fromRGBO(100, 100, 100, 0.30),
			transitionDuration: const Duration(milliseconds: 200),
			pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
				return Center(
					child: Container(
						width: MediaQuery.of(context).size.width,
						height: MediaQuery.of(context).size.height,
						padding: EdgeInsets.all(20),
						color: Colors.transparent,
						child: Center(
							child: CircularProgressIndicator()
						),
					),
				);
			},
		);


		await api.requestGET(G.test);

		// do authentication as needed
		// ...
		// if success, go to dashboard
		Navigator.pop(context);
		Navigator.pushNamed(context, "/dashboard");
	}

	@override
	void dispose() {
		_focusNode.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				Padding(
					padding: EdgeInsets.symmetric(horizontal: 16.0),
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							TextFormField(
								decoration: const InputDecoration(
									icon: Icon(Icons.person),
									labelText: "Username",
								),
								controller: _usernameController,
								onFieldSubmitted: (value) {
									FocusScope.of(context).requestFocus(_focusNode);
								},
							),
							TextFormField(
								focusNode: _focusNode,
								decoration: const InputDecoration(
									icon: Icon(Icons.lock),
									labelText: "Password",
								),
								controller: _passwordController,
								obscureText: true,
								onFieldSubmitted: (value) {
									if (_formComplete) _login();
								},
							),
						],
					),
				),
				Container(
					height: 40,
					width: double.infinity,
					margin: EdgeInsets.all(12),
					child: FlatButton(
						color: Theme.of(context).primaryColor,
						textColor: Colors.white,
						onPressed: _formComplete ? _login : null,
						child: Text("Login"),
					),
				),
			],
		);
	}
}
