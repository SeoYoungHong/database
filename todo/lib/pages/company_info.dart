import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/state/notice_state.dart';

import 'find_user.dart';
import 'notice_list.dart';

class CompanyInfo extends StatefulWidget {
  final int idx;
  const CompanyInfo({Key? key, required this.idx}) : super(key: key);

  @override
  _CompanyInfo createState() => _CompanyInfo();
}

class _CompanyInfo extends State<CompanyInfo> {
  int idx=0;
  int _selectedIndex=0;
  @override
  void initState() {
    idx = widget.idx;
    final acontroller = Get.put(NoticeState());
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Company_notic_info',
          style: TextStyle(
            fontFamily: 'Noto Sans CJK KR',
            fontSize: 20,
            color: const Color(0xff111111),
            letterSpacing: -1,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
        leading: IconButton(
          onPressed: () {Get.back();},
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.zero,
          child: GetBuilder<NoticeState>(
            builder: ((controller) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent
                      ),
                      child: Text('로고'),
                    ),
                    Container(
                      width: 360,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: 
                        Text(
                          'Company title $idx',
                          style: TextStyle(fontSize: 30),
                        ),
                    ),
                    Container(
                      width: 400,
                      height: 250,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.amber,
                      ),
                      child: Text('Company 내용'),
                    ),
                   
                  ],
                )),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: _selectedIndex, //현재 선택된 Index
        onTap: (int index) {
         setState(() {
           setState(() {
           _selectedIndex = index;
           if(index==0){
            Get.to(NoticeList());
           }
           else if(index==1){
            Get.to(FindUser());
           }

         });
         });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Notic',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'find Freind',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
