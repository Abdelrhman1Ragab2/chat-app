import 'package:chat_if/providers/authinticat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String?errorMessage="";
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: buildBody(context,pro)
    );
  }
  Widget buildBody(BuildContext context,pro)
  {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 50,
        child: Form(

          key: pro.formKey,
          child: Container(

            height: 400,
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "email"),
                    onSaved: (value) => pro.email = value,
                    validator: (val) {
                      if (val != null) if (val!.isEmpty) {
                        return "value can not be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "password"),
                    onSaved: (value) => pro.pass = value,
                    validator: (val) {
                      if (val != null) if (val!.isEmpty) {
                        return "value can not be empty";
                      }
                    },
                  ),
                  if (!pro.isLogin)
                    const SizedBox(
                      height: 10,
                    ),
                  if (!pro.isLogin)
                    TextFormField(
                      decoration: InputDecoration(labelText: "userName"),
                      onSaved: (value) => pro.userName = value,
                      validator: (val) {
                        if (val != null) if (val!.isEmpty) {
                          return "value can not be empty";
                        }
                      },
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () {
                       Provider.of<AuthProvider>(context, listen: false)
                          .onSubmit();
                    },
                    child: Text(pro.isLogin?"Sign In":"Sign Up"),
                  ),
                  Text(pro.errorMessage),
                  MaterialButton(
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logOrSign();
                    },
                    child: Text(pro.isLogin?"You don't have account?":"already have account"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
