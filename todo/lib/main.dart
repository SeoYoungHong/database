import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:todo/pages/notice_list.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
  var dio = Dio();
  final response = await dio.get('database-1.c2xhvej09m67.ap-northeast-2.rds.amazonaws.com');
  print(response.data);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoticeList(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  int update = -1;
  int page = 0;
  List todos = [];
  String updatedis = '';
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    getdata();
  }

  Future<void> getdata() async {
    todos.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    ref
        .child('todo')
        .orderByChild('/deleted')
        .equalTo(false)
        .onChildAdded
        .listen((event) {
      setState(() {
        if (event.snapshot.value.runtimeType == List<Object?>) {
          Map val = event.snapshot.value as Map;
          if (val['deleted'] != true) todos.add(event.snapshot.value);
        } else {
          Map val = event.snapshot.value as Map;
          if (val['deleted'] != true) todos.add(event.snapshot.value);
        }
      });
    });
  }

  Future<void> putdata(inputdata) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    var num;
    try {
      num = await ref.child('todonum').get();
      num = num.value;
      num = num + 1;
      await ref.update({'todonum': num});
    } catch (e) {
      num = 0;
      await ref.update({'todonum': num});
    }
    final data = await ref.child('todo/$num').update({
      'descript': "$inputdata",
      'ceatedAt':
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      'idx': "$num",
      'deleted': false,
    });
  }

  Future<void> deldata(idx) async {
    print('deleted');
    final ref = FirebaseDatabase.instance.ref('todo');
    final data = await ref.child(idx).update({'deleted': true});
  }

  Future<void> updatedata(idx, dis) async {
    final ref = FirebaseDatabase.instance.ref('todo');
    final data = await ref.child(idx).update({'descript': dis});
  }

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    TextEditingController input = TextEditingController();
    TextEditingController updatetc = TextEditingController();
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, bottom: 20),
                        width: 300,
                        child: TextField(
                          controller: input,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          putdata(input.text);
                          //getdata();
                        },
                        child: Text('????????????'),
                      ),
                    ],
                  ),
                  for (int i = 0; i < todos.length; i++)
                    if (page * 10 <= i && i < (page + 1) * 10)
                      if (todos[i] != null)
                        Row(
                          children: [
                            Container(
                              width: 30,
                            ),
                            Text('${todos[i]['idx']}'),
                            Container(
                              width: 10,
                            ),
                            if (update != i)
                              if (update != i) Text('${todos[i]['descript']}'),
                            if (update != i)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      update = i;
                                    });
                                  },
                                  child: Text('??????')),
                            if (update == i)
                              Container(
                                width: 200,
                                child: TextFormField(
                                  initialValue: '${todos[i]['descript']}',
                                  onChanged: (value) {
                                    updatedis = value.toString();
                                  },
                                ),
                              ),
                            if (update == i)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      updatedata(todos[i]['idx'], updatedis).then((value) => getdata());
                                      update = -1;
                                    });
                                  },
                                  child: Text('??????')),
                            TextButton(
                                onPressed: () {
                                  deldata(todos[i]['idx']).then((value) => getdata());
                                },
                                child: Text('??????'))
                          ],
                        ),
                  Row(
                    children: [
                      for (int i = 0; i < todos.length / 10; i++)
                        TextButton(
                            onPressed: () {
                              setState(() {
                                page = i;
                              });
                            },
                            child: Text('${i + 1}'))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
