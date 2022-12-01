import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

void main() async {
  
}
class NoticeState extends GetxController {
  RxList todos = [].obs;
  Future<void> getdata() async {
    todos.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    ref
        .child('todo')
        .orderByChild('/deleted')
        .equalTo(false)
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value.runtimeType == List<Object?>) {
        Map val = event.snapshot.value as Map;
        if (val['deleted'] != true) todos.add(event.snapshot.value);
      } else {
        Map val = event.snapshot.value as Map;
        if (val['deleted'] != true) todos.add(event.snapshot.value);
      }
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
}
