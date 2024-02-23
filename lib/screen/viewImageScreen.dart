import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled/db_helper/employee_model.dart';
import 'package:untitled/screen/Local_view_screen.dart';

import 'home_Screen.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {

  List<dynamic> _uploadUserList =[];
  final databaseRef = FirebaseDatabase.instance.reference();
  late DatabaseReference databaseReference;

  readData() async {
    _uploadUserList.clear();
    final ref = FirebaseDatabase.instance.ref();
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    final snapshot = await ref.child('Employee Data').get();
    if (snapshot.exists) {
      var data=json.encode(snapshot.value);

      Map<String, dynamic> map = Map.castFrom(json.decode(data));

      map.forEach((key, value) {
        _uploadUserList.add(value);
      });

      setState(() {

      });

      print('Data a a ;-  ${_uploadUserList}');
      await EasyLoading.dismiss();
    } else {
      await EasyLoading.dismiss();

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('View Screen'),
        actions: [
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LocalViewScreen()));
              },
              child: const Text('Local Data')),
          SizedBox(width: 10,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _uploadUserList.isEmpty? const Center(child: Text('No Data Found...'),):ListView.builder(
          shrinkWrap: true,
            itemCount: _uploadUserList.length,
            itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.deepPurple.withOpacity(0.3),border: Border.all(color: Colors.deepPurple)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      memCacheHeight: 100,
                      memCacheWidth: 100,
                      placeholder: (context, url) => const Icon(Icons.error),
                      imageUrl: _uploadUserList[index]['eImage'],
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employee Name :-  ${_uploadUserList[index]['eName']}'),
                      Text('Employee Address :-  ${_uploadUserList[index]['eAddress']}'),
                      Text('Employee PhNo :-  ${_uploadUserList[index]['ePhoNo']}'),
                      Text('Employee DOB :-  ${_uploadUserList[index]['eDOB']}'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){

                          final Employee empolyee = Employee( eName:_uploadUserList[index]['eName'], eAddress:_uploadUserList[index]['eAddress'],ePhNo: _uploadUserList[index]['ePhoNo'], eDOB:_uploadUserList[index]['eDOB'], eImage:_uploadUserList[index]['eImage']);

                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(employee: empolyee,id: _uploadUserList[index]['id'],)));
                        },
                          child: const Icon(Icons.edit)),
                      const SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          removeEmployeeData(_uploadUserList[index]['id']);
                        },
                          child: const Icon(Icons.delete)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      )
    );
  }

  updateEmployeeData(String id,String eName,String eAddress,String ePhNo,String eDOB,String eUrl) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    databaseRef
        .child("Employee Data")
        .child(id)
        .update({
      'id':id,
      'eName': eName,
      'eAddress': eAddress,
      'ePhoNo': ePhNo,
      'eDOB': eDOB,
      'eImage':eUrl,
    }).whenComplete(() async {
      await EasyLoading.dismiss();
    });
  }

  removeEmployeeData(String id) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    databaseRef
        .child("Employee Data")
        .child(id)
        .remove().whenComplete(() async {
      readData();
      await EasyLoading.dismiss();
    });
  }
}
