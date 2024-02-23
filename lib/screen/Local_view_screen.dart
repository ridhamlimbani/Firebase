import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/db_helper/dp_helper.dart';
import 'package:untitled/db_helper/employee_model.dart';
import 'package:untitled/screen/home_Screen.dart';

class LocalViewScreen extends StatefulWidget {
  const LocalViewScreen({super.key});

  @override
  State<LocalViewScreen> createState() => _LocalViewScreenState();
}

class _LocalViewScreenState extends State<LocalViewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Employee>?>(
          future: DatabaseHelper.getAllEmployee(),
          builder: (context,AsyncSnapshot<List<Employee>?> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            } else if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()),);
            } else if(snapshot.hasData){
              if(snapshot.data != null){
                return  ListView.separated(
                  separatorBuilder: (context,index){
                    return const SizedBox(height: 10,);
                  },
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
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
                                  imageUrl: snapshot.data![index].eImage,
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Employee Name :-  ${snapshot.data![index].eName}'),
                                  Text('Employee Address :-  ${snapshot.data![index].eAddress}'),
                                  Text('Employee PhNo :-  ${snapshot.data![index].ePhNo}'),
                                  Text('Employee DOB :-  ${snapshot.data![index].eDOB}'),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 InkWell(
                                     onTap: (){
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(employee: snapshot.data![index],)));
                                     },
                                     child: const Icon(Icons.edit)),
                                 const SizedBox(height: 20,),
                                 InkWell(
                                     onTap: () async {
                                       await DatabaseHelper.deleteEmployee(snapshot.data![index],);
                                     },
                                     child: const Icon(Icons.delete)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }


            }

            return const Center(child: Text('No Employee Yet'),);
          },
        ),
      ),
    );
  }
}

