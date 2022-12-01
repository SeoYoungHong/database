import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/pages/company_detail.dart';
import 'package:todo/pages/notice_detail.dart';
import 'package:todo/state/notice_state.dart';

import 'find_user.dart';
import 'notice_list.dart';

class CompanyList extends StatefulWidget {
  const CompanyList({Key? key}) : super(key: key);

  @override
  _CompanyList createState() => _CompanyList();
}

class _CompanyList extends State<CompanyList> {
  int _selectedIndex=0;
  @override
  void initState() {
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
          'Compant_notice_list',
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
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          TextButton(onPressed: (){Get.to(NoticeList());}, child: Text('type')),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.zero,
          child: GetBuilder<NoticeState>(
            builder: ((controller) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Notice title',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text('company_name', style: TextStyle(fontSize: 18),),
                        Text('작성일자',
                          style: TextStyle(fontSize: 18),)
                      ],
                    ),
                    for(int i =0; i<10;i++)
                    TextButton(onPressed: (){Get.to(()=>CompanyDetail(idx : i));}, child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Title${i}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Name${i}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text('date${i}',
                          style: TextStyle(fontSize: 18),)
                      ],
                    ))
                    
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
