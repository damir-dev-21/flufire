import 'dart:io';

import 'package:flufire_chat/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitFn, required this.isLoading})
      : super(key: key);

  final void Function(String email, String password, String userName,
      File image, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File userImageFile = File('');

  void _pickedImage(File file) {
    userImageFile = file;
  }

  void _trySubmit() {
    // final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (userImageFile == File('') && _isLogin) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Выберите изображение')));
      return;
    }
    // if (isValid!) {
    // _formKey.currentState!.save();
    widget.submitFn(
        _userEmail, _userPassword, _userName, userImageFile, _isLogin, context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
              TextFormField(
                key: const ValueKey('email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Email не валидный';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Ваш email',
                ),
                onChanged: (value) {
                  _userEmail = value;
                },
              ),
              if (!_isLogin)
                TextFormField(
                  key: const ValueKey('username'),
                  decoration: const InputDecoration(
                    labelText: 'Ваш логин',
                  ),
                  onChanged: (value) {
                    _userName = value;
                  },
                ),
              TextFormField(
                key: const ValueKey('password'),
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return 'Пароль должен быть больше 4 символов';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                ),
                obscureText: true,
                onChanged: (value) {
                  _userPassword = value;
                },
              ),
              SizedBox(
                height: 12,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                RaisedButton(
                  onPressed: _trySubmit,
                  child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                ),
              if (!widget.isLoading)
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Зарегистрироваться'
                        : 'У меня уже есть аккаунт'))
            ],
          ),
        ),
      )),
    ));
  }
}
