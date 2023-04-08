import 'package:chat_if/providers/authinticat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String? errorMessage = "";

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: buildBody(context, pro));
  }

  Widget buildBody(BuildContext context, pro) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(20),
        elevation: 20,
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
                    height: 40,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .onSubmit();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        pro.isLogin ? "  Sign In  " : "  Sign Up  ",
                        style:
                            GoogleFonts.acme(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  pro.isLoading?const Center(child: CircularProgressIndicator(),):const SizedBox(),
                  SizedBox(height:pro.isError?10:5 ),
                  pro.isError?Text(pro.errorMessage,style: const TextStyle(color: Colors.red),):const SizedBox(),
                  SizedBox(height:pro.isError?10:5 ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logOrSign();
                    },
                    child: Text(pro.isLogin
                        ? " You don't have account? "
                        : " already have account? "),
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
