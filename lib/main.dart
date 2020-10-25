import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http  ;

import 'Note.dart';
void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map data;
  List userData;

  Future getData() async {
    http.Response response = await http.get("https://gorest.co.in/public-api/users");
    data = json.decode(response.body);
    setState(() {
      userData = data["data"];
    });
  }

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void sendInfo({String email,String name,String callbackurl})
  async{
    var res;
    var token ="f106f5805b2ad31d6ba0d4ef5b8f13c773a389cf46e5853656c690a72f75a8e6";
    http.post(
        callbackurl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
            {
              "email" : email,
              "name": name,
              "gender":"Male",
              "status":"Active",
            }
        )
    ).then((response){
      res = response.statusCode;
      print("Response body : ");
      print( response.body);
      // ignore: unrelated_type_equality_checks
      if(response.statusCode == '201')
      print("data is sucessfullt addded ");
// Perform the required operation(s)
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GlocalMind Task by- Padmanabh Wattamwar"),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          height: 1000,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                padding: EdgeInsets.only(top: 4,bottom: 4),
                child: Text("Post your  data to server",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),),
              ),
              Container(
                height: 30,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width:150,
                      height: 40,
                      child: TextField(
                        controller: name,
                        decoration: new InputDecoration(
                            border:  new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            hintText: 'Enter Name'
                        ),
                      ),
                    ),

                    Container(
                      width:150,
                      height: 40,
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller:email,
                        decoration: new InputDecoration(
                            border:  new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            hintText: 'Enter Email id'
                        ),
                      ),
                    ),
                     FloatingActionButton(
                      onPressed: () async{
                        final String nam1 = name.text;
                        final String email1 = email.text;
                        setState(() {

                           sendInfo(name: nam1,email: email1, callbackurl: "https://gorest.co.in/public-api/users");


                        });

                      },
                      tooltip: 'Increment',
                      child: Icon(Icons.add),
                    ),

                  ],
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.only(top: 4,bottom: 4),
                child: Text("getting data from api",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                ),),
              ),
              Container(
                height: 500,//MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: userData == null ? 0 : userData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("${userData[index]["id"]} ${userData[index]["name"]}",),
                            ),
                            Text("${userData[index]["email"]} "),
                            Text("${userData[index]["gender"]}"),
                            Text("${userData[index]["status"]}"),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}