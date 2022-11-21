import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
                        child: Text('저장하기'),
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
                                  child: Text('수정')),
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
                                  child: Text('확인')),
                            TextButton(
                                onPressed: () {
                                  deldata(todos[i]['idx']).then((value) => getdata());
                                },
                                child: Text('삭제'))
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
