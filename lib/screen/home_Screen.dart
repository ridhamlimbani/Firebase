import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/db_helper/dp_helper.dart';
import 'package:untitled/db_helper/employee_model.dart';
import 'package:untitled/screen/viewImageScreen.dart';
import 'package:untitled/utils/custom_textFiled.dart';

class HomeScreen extends StatefulWidget {
  Employee? employee;
  String? id;
  HomeScreen({super.key,this.employee,this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlatformFile? pickedFile;
  final databaseRef = FirebaseDatabase.instance.reference();
  late DatabaseReference databaseReference;
  UploadTask? uploadTask;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String url ='';
  final TextEditingController _eNameController = TextEditingController();
  final TextEditingController _ePhNoController = TextEditingController();
  final TextEditingController _eAddressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  Future selectFile()async{
    setState(() {
      url ="";
    });
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    final result = await FilePicker.platform.pickFiles();
    if(result == null) {
      await EasyLoading.dismiss();
      return ;
    };

    setState(() {
      pickedFile = result.files.first;
    });
    Future.delayed(Duration(seconds: 2),(){
      uploadFireStorage();
    });
  }


  uploadFireStorage()async{
    final path = 'employee/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapShort = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapShort.ref.getDownloadURL();
    await EasyLoading.dismiss();
    setState(() {
      url = urlDownload;
    });
    print('Download Link  : $url');
  }

  uploadUserData(String eName,String eAddress,String ePhNo,String eDOB,String eUrl) async {
    DatabaseReference newRef = databaseRef.push();
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    databaseRef
        .child("Employee Data")
        .child(newRef.key.toString())
        .set({
      'id':newRef.key.toString(),
      'eName': eName,
      'eAddress': eAddress,
      'ePhoNo': ePhNo,
      'eDOB': eDOB,
      'eImage':eUrl,
    }).whenComplete(() async {
      await EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.employee !=null){
      print('Employee Data :_  ${widget.employee!.ePhNo}');
      _eNameController.text = widget.employee!.eName;
      _eAddressController.text = widget.employee!.eAddress;
      _ePhNoController.text = widget.employee!.ePhNo;
      _dobController.text = widget.employee!.eDOB;
      url = widget.employee!.eImage;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.employee != null?'Edit Screen':'Home Screen'),
        actions: [
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewScreen()));
              },
              child: const Text('View Image')),
          const SizedBox(width: 10,),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Employee Name :'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomTextFormFiled(
                    keyBoardType: TextInputType.multiline,
                    validator: (value){
                      if (value!.isEmpty) {
                        return "Employee Name isEmpty...";
                      }
                      return null;
                    },
                    labelText: '',
                    controller: _eNameController,
                    textInputType: TextInputType.text,),
                ),
                const Text('Employee Address :'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomTextFormFiled(
                    keyBoardType: TextInputType.multiline,
                    validator: (value){
                      if (value!.isEmpty) {
                        return "Employee Address isEmpty...";
                      }
                      return null;
                    },
                    labelText: '',
                    controller: _eAddressController,
                    textInputType: TextInputType.text,),
                ),
                const Text('Mobile Number :'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomTextFormFiled(
                    keyBoardType: TextInputType.number,
                    validator: (value){
                      if (value!.isEmpty) {
                        return "Mobile Number isEmpty...";
                      } else  if (value.length != 10) {
                        return "Mobile Not Valid...";
                      }
                      return null;
                    },
                    labelText: '',
                    controller: _ePhNoController,
                    textInputType: TextInputType.text,),
                ),
                const Text('DOB :'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomTextFormFiled(
                    keyBoardType: TextInputType.multiline,

                    validator: (value){
                      if (value!.isEmpty) {
                        return "DOB isEmpty...";
                      }
                      return null;
                    },
                    labelText: '',
                    controller: _dobController,
                    textInputType: TextInputType.text,),
                ),
                const Text('Employee Image :'),
                url.isNotEmpty
                    ? InkWell(
                  onTap: (){
                    selectFile();
                  },
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.blueGrey),image: DecorationImage(image: NetworkImage(url))),
                    ),
                  ),
                )
                    : InkWell(
                  onTap: (){
                    selectFile();
                  },
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.blueGrey),),
                      child: Icon(Icons.person,size: 50,),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () async {
                    if(formKey.currentState!.validate()){
                      if(url.isEmpty){
                        Fluttertoast.showToast(
                            msg: "Upload Image",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        final Employee employee = Employee(eName: _eNameController.text.toString().trim(), eAddress: _eAddressController.text.toString().trim(), ePhNo: _ePhNoController.text.toString().trim(), eDOB: _dobController.text.toString().trim(), eImage: url);


                         if(widget.employee != null){
                           updateEmployeeData(widget.id ?? '', widget.employee?.eName ?? '', widget.employee?.eAddress ?? '', widget.employee?.ePhNo ?? '', widget.employee?.eDOB ?? '', widget.employee?.eImage ?? '');
                           await DatabaseHelper.updateEmployee(employee);
                         }else{
                           await DatabaseHelper.addEmployee(employee);
                         }
                       }
                        uploadUserData(_eNameController.text.toString(), _eAddressController.text.toString(), _ePhNoController.text.toString(), _dobController.text.toString(), url);

                    }
                  },
                  child: Container(
                    height:40 ,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.3),borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.deepPurple)),
                    child:  Center(child: Text(widget.employee != null?'Edit Data':'Upload Data'),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateEmployeeData(String id,String eName,String eAddress,String ePhNo,String eDOB,String eUrl) async {
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref("Employee Data/$id");

    await ref
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
}
