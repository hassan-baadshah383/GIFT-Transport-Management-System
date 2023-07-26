import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:video_player/video_player.dart';

import 'auth.dart';
import 'student/models/exception.dart';
//import '../screens/products_overview_screen.dart';

enum AuthMode { Signup, Login }

class AuthenticationScreen extends StatefulWidget {
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // static VideoPlayerController videoController;

  // @override
  // void initState() {
  //   videoController = VideoPlayerController.asset('assets/videos/LoginVid.mp4')
  //     ..initialize().then((_) {
  //       videoController.play();
  //       videoController.setLooping(true);
  //       setState(() {});
  //     });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
            height: deviceSize.height,
            width: deviceSize.width,
            //child: VideoPlayer(videoController),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 0, 128, 1),
                Color.fromRGBO(0, 0, 128, 1),
                Color.fromRGBO(230, 126, 0, 1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ))),
        Container(
          margin: const EdgeInsets.only(
            top: 100,
            left: 40,
            right: 40,
          ),
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 30),
              //transform: Matrix4.rotationZ(-8 * pi / 100),
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    )
                  ]),
              child: const Text(
                'GIFT University',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              flex: deviceSize.width > 600 ? 2 : 1,
              child: const AuthCard(),
            )
          ]),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, Object> _authData = {
    'name': '',
    'rollNo': '',
    'email': '',
    'password': '',
    'cnic': '',
    'phone': '',
    'location': '',
  };
  bool isChecked = false;
  var _isLoading = false;
  bool isAdmin = false;
  bool isStudent = false;
  bool isDriver = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AnimationController _animController;
  Animation<double> _opacityAnimation;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.linear));
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
            .animate(
                CurvedAnimation(parent: _animController, curve: Curves.linear));
    super.initState();
  }

  void triggerCheckedBox(bool value) {
    setState(() {
      isChecked = value;
    });
  }

  void _alertDialogueBox(String error) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            //title: const Text('Incorrect e-mail or password!'),
            //content: const Text('Incorrect e-mail or password!'),
            content: Text(error.toString()),

            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'))
            ],
          );
        }));
  }

  void checkAdmin() {
    if (_emailController.text == 'admin_transport@gift.edu.pk' &&
        _passwordController.text == 'admin12345' &&
        !isChecked) {
      isAdmin = true;
    }
  }

  Future<void> checkStudent() async {
    final s = await Provider.of<Auth>(context, listen: false)
        .checkStudent(_emailController.text);
    if (s == true && !isChecked) {
      isStudent = true;
    }
  }

  Future<void> checkDriver() async {
    final d = await Provider.of<Auth>(context, listen: false)
        .checkDriver(_emailController.text);
    if (d == true && isChecked) {
      isDriver = true;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    //_formKey.currentState.reset();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Signup) {
        //_AuthenticationScreenState.videoController.pause();
        await Provider.of<Auth>(context, listen: false).signUpUser(
          _authData['name'],
          int.parse(_authData['rollNo']),
          _authData['email'],
          _authData['password'],
          int.parse(_authData['phone']),
          _authData['cnic'],
          _authData['location'],
        );
      } else {
        checkAdmin();
        await checkStudent();
        await checkDriver();
        if (!isAdmin && !isStudent && !isDriver) {
          _alertDialogueBox('Please enter valid credentials');
          setState(() {
            _isLoading = false;
          });
          return;
        }
        await Provider.of<Auth>(context, listen: false).loginUser(
            _authData['email'],
            _authData['password'],
            isAdmin,
            isStudent,
            isDriver);
        //_AuthenticationScreenState.videoController.pause();
      }
    } on HttpExceptions catch (error) {
      var message = 'Something went wrong!';
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        message = 'Invalid e-mail.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        message = 'Invalid password.';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        message = 'This email already exist.';
      } else if (error.toString().contains('USER_DISABLED')) {
        message = 'The user account has been disabled by an administrator.';
      } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        message = 'Too many attempts. Try again later!';
      }
      _alertDialogueBox(message);
    } catch (error) {
      print({error, 'Error'});
      _alertDialogueBox('Please try again later');
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
        _formKey.currentState.reset();
      });
      _animController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _formKey.currentState.reset();
      });
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 350 : 290,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 410 : 340),
        width: kIsWeb ? deviceSize.width * 0.50 : deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(labelText: 'Name'),
                    textCapitalization: TextCapitalization.words,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value.length <= 5) {
                              return 'Username is too short!';
                            }
                            return null;
                          }
                        : null,
                    onSaved: ((value) {
                      _authData['name'] = value;
                    }),
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Roll No'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Roll No.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['rollNo'] = value;
                    },
                  ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@gift.edu.pk')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_authMode == AuthMode.Login)
                  Row(
                    children: [
                      const Text(
                        'Login as driver',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Checkbox(
                          value: isChecked,
                          onChanged: ((value) => triggerCheckedBox(value))),
                    ],
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(labelText: 'CNIC'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your CNIC';
                      }
                      if (value.length != 13) {
                        return 'Please enter a valid CNIC';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authData['cnic'] = newValue;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone';
                      }
                      if (value.length != 11) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authData['phone'] = newValue;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your residential area';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authData['location'] = newValue;
                    },
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  child: TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                      style: const TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
