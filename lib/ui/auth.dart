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
    AuthProvider pro = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: buildBody(context, pro));
  }

  Widget buildBody(BuildContext context,AuthProvider pro) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoBody(),
            const SizedBox(height: 10,),
            inputBody(context,pro),
          ],
        ),
      ),
    );
  }

  Widget logoBody(){
    return const CircleAvatar(
      radius: 62,
      backgroundImage: AssetImage("assets/images/chatlogo.png"),
    );
  }

  Widget inputBody(BuildContext context, AuthProvider pro){
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pro.isLogin ?40:20),
        ),
        margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
        elevation: 20,
        child: Form(
          key: pro.formKey,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),

            height: pro.isLogin ?350:480,
            padding:  const EdgeInsets.only(left: 20,right: 20,top: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "email",
                      suffixIcon:   Icon(Icons.email,
                          color: Colors.black54
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black54

                      ),
                    ),
                    onSaved: (value) => pro.email = value,
                    validator: (val) {
                      if (val != null)
                      {  if (val.isEmpty) {
                        return "value can not be empty";
                      }}

                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: pro.isSecur,
                    decoration:   InputDecoration(labelText: "password",

                        suffixIcon:   IconButton(onPressed: (){
                          Provider.of<AuthProvider>(context,listen: false).changePasswordSecurty();
                        },icon: Icon(pro.isSecur?Icons.remove_red_eye_outlined:Icons.remove_red_eye_rounded,),
                            color: Colors.black54
                        ),
                    labelStyle: const TextStyle(
                        color: Colors.black54
                    ),
                    ),
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
                      decoration: const InputDecoration(labelText: "userName",
                        suffixIcon:   Icon(Icons.person,
                            color: Colors.black54
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black54

                        ),
                      ),
                      onSaved: (value) => pro.userName = value,
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
                      decoration:  const InputDecoration(labelText: "Phone",
                        suffixIcon:   Icon(Icons.phone,
                            color: Colors.black54
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black54

                        ),
                      ),
                      onSaved: (value) => pro.phone = value,
                      validator: (val) {
                        if (val != null) if (val!.isEmpty) {
                          return "phone value can not be empty";
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
                  pro.isLoading
                      ?  const Padding(
                        padding:   EdgeInsets.all(5.0),
                        child:  Center(
                    child: CircularProgressIndicator(),
                  ),
                      )
                      : const SizedBox(),
                  SizedBox(height: pro.isError ? 10 : 5),
                  pro.isError
                      ? Text(
                    pro.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                      : const SizedBox(),
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

                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
