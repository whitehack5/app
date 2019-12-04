import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:memorare/models/http_clients.dart';
import 'package:memorare/models/user_data.dart';
import 'package:memorare/types/boolean_message.dart';
import 'package:memorare/types/colors.dart';
import 'package:memorare/types/credentials.dart';
import 'package:memorare/types/user_data.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();

  bool _serverValidator = true;
  String _serverValidatorMessage = '';

  final String _defaultErrorMessage = """
    Please enter an alphanumerical name containing at least 3 characters.
    Name can only contain alphanumerical characters, dots, spaces, hyphens and underscores.
  """;

  String confirmPassword = '';
  String email = '';
  String name = '';
  String password = '';

  final String signupMutation = """
    mutation Signup(\$email: String!, \$name: String!, \$password: String!) {
      signup(email: \$email, name: \$name password: \$password) {
        id
        imgUrl
        email
        lang
        name
        rights
        token
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Sign up to a new account.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        key: _nameFieldKey,
                        decoration: InputDecoration(
                          icon: Icon(Icons.perm_identity),
                          labelText: 'Name',
                        ),
                        onChanged: (value) async {
                          name = value;

                          var booleanMessage = await isNameValid(value);

                          if (booleanMessage.boolean) {
                            _serverValidator = true;
                            _serverValidatorMessage = booleanMessage.message;
                            _nameFieldKey.currentState.validate();
                            return;
                          }

                          _serverValidator = false;
                          _serverValidatorMessage = booleanMessage.message;

                          _nameFieldKey.currentState.validate();
                        },
                        validator: (value) {
                          if (name.isEmpty) {
                            return 'Name cannot be empty';
                          }

                          if (name.length < 3) {
                            return 'Name must contain at least 3 characters';
                          }

                          if (!_serverValidator) {
                            return _serverValidatorMessage.isNotEmpty ?
                              _serverValidatorMessage :
                              _defaultErrorMessage;
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email login cannot be empty';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password cannot be empty';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline),
                          labelText: 'Confirm Password',
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password confirmation cannot be empty';
                          }

                          if (confirmPassword != password) {
                            return 'Password and confirm password must match.';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Mutation(
                  builder: (RunMutation runMutation, QueryResult result) {
                    return Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: RaisedButton(
                        color: Color(0xFF2ECC71),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          runMutation({
                            'email': email,
                            'password': password,
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Icon(Icons.arrow_forward, color: Colors.white,),
                              )
                            ],
                          )
                        ),
                      ),
                    );
                  },
                  options: MutationOptions(
                    document: signupMutation,
                  ),
                  onCompleted: (dynamic resultData) {
                    if (resultData == null) { return; }

                    Map<String, dynamic> signinJson = resultData['signin'];

                    var userData = UserData.fromJSON(signinJson);
                    var userDataModel = Provider.of<UserDataModel>(context);

                    userDataModel
                      ..update(userData)
                      ..setAuthenticated(true)
                      ..saveToFile(signinJson);

                    Credentials(email: email, password: password).saveToFile();

                    Provider.of<HttpClientsModel>(context).setToken(userData.token);

                    Navigator.of(context).pop();
                  },
                  update: (Cache cache, QueryResult result) {
                    if (result.hasErrors) {
                      for (var error in result.errors) {
                        Scaffold.of(context)
                          .showSnackBar(
                            SnackBar(
                              backgroundColor: ThemeColor.validation,
                              content: Text(
                                '${error.message}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                      }
                    }
                  },
                ),
              ],
            ),
          )
        ),
      ],
    );
  }

  Future<BooleanMessage> isNameValid(String nameValue) {
    if (nameValue == null || nameValue.isEmpty) {
      return Future.value(
        BooleanMessage(
          boolean: false,
          message: 'Name cannot be null or empty.'
        )
      );
    }

    if (nameValue.length < 3) {
      return Future.value(
        BooleanMessage(
          boolean: false,
          message: 'Name must contain at least 3 characters.'
        )
      );
    }

    final String isNameValid = """
      query IsNameValid(\$name: String!) {
        isNameValid(name: \$name) {
          bool
          message
        }
      }
    """;

    var client = Provider.of<HttpClientsModel>(context).defaultClient;

    return client.value.mutate(
      MutationOptions(
        document: isNameValid,
        variables: {'name': nameValue},
      ))
      .then((queryResult) {
        if (queryResult.hasErrors) {
          return BooleanMessage(
            boolean: false,
            message: queryResult.errors.first.toString(),
          );
        }

        Map<String, dynamic> json = queryResult.data['isNameValid'];
        var booleanMessage = BooleanMessage.fromJSON(json);

        return booleanMessage;
      })
      .catchError((onError) {
        return BooleanMessage(
          boolean: false,
          message: 'There was an issue while communicating with the server.'
        );
      }
    );
  }
}
