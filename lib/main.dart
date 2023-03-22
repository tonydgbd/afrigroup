import 'package:afrigroup/add_entreprise.dart';
import 'package:afrigroup/controllers/entreprise_controller.dart';
import 'package:afrigroup/historique.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    Get.put(EntrepriseController());
     runApp(const MyApp());
  } catch (e) {
    print(e);
  }

 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suivie AfriGroup',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: Column( 
          children: [
            ListTile(
              onTap: (){
                Get.to(Historique());
              },
              title: Text("Voir l'historique"),)
          ],
        ),
      ),
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: Text(
          'Suivie des Pages',
        
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Obx(() => SingleChildScrollView(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Chip(label: Text('${DateTime.now().toString()}')),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          color: Colors.orange,
                          
                          child: Text('Enregistrer'), onPressed: () async{
                           var today = DateTime.now();
                           EasyLoading.show(status: 'Enregistrement');
                            await FirebaseFirestore.instance.collection('pages').doc("${today.day}_${today.month}_${today.year}").set({
                              'data':EntrepriseController.instance.data.value,
                              'date': "${today.day}_${today.month}_${today.year}"
                          });
                         
                          EasyLoading.dismiss();
                  
                        }),
                        IconButton(onPressed: (){
                          EntrepriseController.
                          instance.getEntreprises();
                        }, icon: Icon(Icons.refresh_outlined))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  EntrepriseController .instance.data.value.isNotEmpty ?
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                       ...EntrepriseController.instance.entreprises.map((e) =>
                      Container(
                        width: size.width * .9,
                        // height: 200,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              // spreadRadius: 5,
                              blurRadius:10
                            )
                          ],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: size.width * 0.15,
                                  child: FancyShimmerImage(imageUrl:e['logo'],  
        ),
                                ),
                                Expanded(
                                    child: (e['page'] as List).length <= 1
                                        ? Column(
                                            children: [
                                              Text((e['page'] as List)
                                                  .first
                                                  .toString()),
                                                 
                                              Obx(() => CheckboxListTile(
                                                  title: Text('Post'),
                                                  value: EntrepriseController
                                                      .instance.data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['post'],
                                                  onChanged: (val) {
                                                    EntrepriseController
                                                        .instance.data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['post'] = val;
                                                    EntrepriseController
                                                        .instance.data
                                                        .refresh();
                                                  })),
                                              Obx(() => CheckboxListTile(
                                                  title: Text('Partage'),
                                                  value: EntrepriseController
                                                      .instance.data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['partage'],
                                                  onChanged: (val) {
                                                    EntrepriseController
                                                        .instance.data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['partage'] = val;
                                                    EntrepriseController
                                                        .instance.data
                                                        .refresh();
                                                  })),
                                              Obx(() => CheckboxListTile(
                                                  title: Text('message'),
                                                  value: EntrepriseController
                                                      .instance.data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['message'],
                                                  onChanged: (val) {
                                                    EntrepriseController
                                                        .instance.data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['message'] = val;
                                                    EntrepriseController
                                                        .instance.data
                                                        .refresh();
                                                  })),
                                              Obx(() => CheckboxListTile(
                                                  title: Text('commentaires'),
                                                  value: EntrepriseController
                                                      .instance.data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['commentaires'],
                                                  onChanged: (val) {
                                                    EntrepriseController
                                                            .instance.data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'])[
                                                        'commentaires'] = val;
                                                    EntrepriseController
                                                        .instance.data
                                                        .refresh();
                                                  })),
                                            ],
                                          )
                                        : Column(children: [
                                            ...(e['page'] as List).map((pg) =>
                                                Column(
                                                  children: [
                                                    Text(pg),
                                                    Obx(() => CheckboxListTile(
                                                        title: Text('Post'),
                                                        value: EntrepriseController
                                                            .instance.data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'] &&element['page']==pg )['post'],
                                                        onChanged: (val) {
                                                          EntrepriseController
                                                              .instance.data.value
                                                              .firstWhere((element) =>
                                                                  element[
                                                                      'entreprise_id'] ==
                                                                  e['id'] &&element['page']==pg )['post'] = val;
                                                          EntrepriseController
                                                              .instance.data
                                                              .refresh();
                                                        })),
                                                    Obx(() => CheckboxListTile(
                                                        title: Text('Partage'),
                                                        value: EntrepriseController
                                                            .instance.data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'] &&element['page']==pg )['partage'],
                                                        onChanged: (val) {
                                                          EntrepriseController
                                                              .instance.data.value
                                                              .firstWhere((element) =>
                                                                  element[
                                                                      'entreprise_id'] ==
                                                                  e['id'] &&element['page']==pg )['partage'] = val;
                                                          EntrepriseController
                                                              .instance.data
                                                              .refresh();
                                                        })),
                                                    Obx(() => CheckboxListTile(
                                                        title: Text('message'),
                                                        value: EntrepriseController
                                                            .instance.data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'] &&element['page']==pg )['message'],
                                                        onChanged: (val) {
                                                          EntrepriseController
                                                              .instance.data.value
                                                              .firstWhere((element) =>
                                                                  element[
                                                                      'entreprise_id'] ==
                                                                  e['id'] &&element['page']==pg )['message'] = val;
                                                          EntrepriseController
                                                              .instance.data
                                                              .refresh();
                                                        })),
                                                    Obx(() => CheckboxListTile(
                                                        title: Text('commentaires'),
                                                        value: EntrepriseController
                                                            .instance.data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id']&&element['page']==pg )['commentaires'],
                                                        onChanged: (val) {
                                                          EntrepriseController
                                                                  .instance.data.value
                                                                  .firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'entreprise_id'] ==
                                                                          e['id'] &&element['page']==pg )[
                                                              'commentaires'] = val;
                                                          EntrepriseController
                                                              .instance.data
                                                              .refresh();
                                                        })),
                                                  ],
                                                ))
                                          ]))
                              ],
                            ),
                          Container(
                            width: Get.width*0.6,
                            child: TextField(
                              controller: TextEditingController(text: EntrepriseController
                                                        .instance.data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['commentaire']),
                              onChanged: (value) {
                                EntrepriseController
                                                        .instance.data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['commentaire'] = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                hintText: 'Rapport'
                              ),
                            ),
                          )
                          ],
                        ),
                      ))
                    ],
                  )
                  :
                  CircularProgressIndicator()
                 
                ],
              ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ADDSCreen());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
