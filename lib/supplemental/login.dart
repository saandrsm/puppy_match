import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  bool _isVisible = true;

  void _toggleVisible(){
    setState(() {
      if(_isVisible) {
        _isVisible = false;
      } else {
        _isVisible = true;
      }
    });
  }

  bool shouldPop = true;  //vueltra atrás activada
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(  //devuelve un Future
      onWillPop: () async {  //volver a pantalla anterior
        return shouldPop;
    },
    child: Scaffold(
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget> [
          const SizedBox(height: 16.0),
          Column(
            children: <Widget> [
              Image.asset(
                'assets/logo_doggy.png',
                height: 120,
                width: 100,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 16.0),
              // const Text('SHRINE'),
            ],
    ),
          const SizedBox(height: 70.0),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              filled: false,
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: InputDecoration(
              filled: false,
              labelText: 'Password',
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                icon: (_isVisible
                    ? const Icon(Icons.lock)
                    : const Icon(Icons.lock_open)
                ),
                color: Colors.orangeAccent,
                onPressed: _toggleVisible,
              ),
            ),
            obscureText: _isVisible,
            controller: _passwordController,
          ),
          const SizedBox(height: 10.0),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed:(){
                    _usernameController.clear();
                    _passwordController.clear();
                 },
                  child: const Text('CANCEL'),
              ),
              ElevatedButton(
                  onPressed:(){
                    if(_usernameController.text.isEmpty || _passwordController.text.isEmpty){
                      showAlertDialog(context);
                    } else {
                      setState(() {
                        shouldPop = !shouldPop; //en false hace que no funcione el swip back de ios
                      });
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  child: const Text('LOG IN'),
              )
            ],
          ),
          const SizedBox(height: 240.0),
          const Text(
              '¿Todavía no estás registrado?',
              textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: (){
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Sign up')
          ),
    ],
    ),
    )
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Error'),
    content: Text('Los campos deben estar completos.'),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


// class PasswordVisible extends StatefulWidget {
//   const PasswordVisible({super.key});
//
//   @override
//   State<PasswordVisible> createState() => _PasswordVisibleState();
// }
//
// class _PasswordVisibleState extends State<PasswordVisible> {
//   bool _isVisible = true;
//
//   void _toggleVisible(){
//     setState(() {
//       if(_isVisible) {
//         _isVisible = false;
//       } else {
//         _isVisible = true;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         filled: false,
//         labelText: 'Password',
//         suffixIcon: IconButton(
//           padding: const EdgeInsets.all(0),
//           alignment: Alignment.center,
//           icon: (_isVisible
//               ? const Icon(Icons.lock)
//               : const Icon(Icons.lock_open)
//           ),
//           color: Colors.orangeAccent,
//           onPressed: _toggleVisible,
//           ),
//         ),
//       obscureText: _isVisible,
//     );
//   }
// }
