import 'package:app/ui/pages/login/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';

import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;
  

  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            if(isLoading){
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter.mainErrorStream.listen((error) {
            if(error != null){
              showErrorMessage(context, error);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(text: 'Login'),
                Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          TextButton.icon(
                            onPressed: () {}, 
                            icon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColorLight
                            ), 
                            label: Text('Criar conta')
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]
            ),
          );
        },
      ),
    );
  }
}