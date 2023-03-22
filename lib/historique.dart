import 'package:afrigroup/controllers/entreprise_controller.dart';
import 'package:afrigroup/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Historique extends StatelessWidget {
  const Historique({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var date = DateTime.now();
    var data =[].obs;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              onTap: (){
                Get.to(MyHomePage());
              },
              title: Text("Acceuil"),)
          ],
        ),
      ),
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: Text(
          'Historique de Suivie des Pages',
        
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Obx(() => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CupertinoButton(child: Text('Choisir une date') , onPressed: ()async{

                   var datehist = await  showDatePicker(context: context, initialDate: DateTime.now().subtract(Duration(days: 1)), firstDate: DateTime(2023,3,1), lastDate: DateTime.now());
                   if(datehist!=null){
                  var d =await FirebaseFirestore.instance.collection('pages').doc("${datehist.day}_${datehist.month}_${datehist.year}").get();
                    if(d.exists == false){
                      EasyLoading.showError("Pas de donne pour ce jour");
                    }else{
                      data.value = d.data()!['data'];
                    }
                   }
                  },),
                  
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  data.isNotEmpty? 
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                        ...EntrepriseController.instance.entreprises.map((e) {
                          try{
                            if(data.value.where((element) => element['entreprise_id']==e['id']).isNotEmpty){
 return  Container(
                        width: size.width * .9,
                        // height: 200,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow()
                          ]
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
                                                      enabled: false,
                                                  title: Text('Post'),
                                                  value: data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['post'],
                                                  onChanged: (val) {
                                                    data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['post'] = val;
                                                    EntrepriseController
                                                        .instance.data
                                                        .refresh();
                                                  })),
                                              Obx(() => CheckboxListTile(
                                                      enabled: false,
                                                  title: Text('Partage'),
                                                  value:data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['partage'],
                                                  onChanged: (val) {
                                                    data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['partage'] = val;
                                                    data
                                                        .refresh();
                                                  })),
                                              Obx(() => CheckboxListTile(
                                                      enabled: false,
                                                  title: Text('message'),
                                                  value:data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['message'],
                                                  onChanged: (val) {
                                                   data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['message'] = val;
                                                    data
                                                        .refresh();
                                                  })),
                                              Obx(() => CheckboxListTile(
                                                      enabled: false,
                                                  title: Text('commentaires'),
                                                  value: data.value
                                                      .firstWhere((element) =>
                                                          element[
                                                              'entreprise_id'] ==
                                                          e['id'])['commentaires'],
                                                  onChanged: (val) {
                                                    data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'])[
                                                        'commentaires'] = val;
                                                   data
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
                                                      enabled: false,
                                                        title: Text('Post'),
                                                        value: data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'] &&element['page']==pg )['post'],
                                                        onChanged: (val) {
                                                         data.value
                                                              .firstWhere((element) =>
                                                                  element[
                                                                      'entreprise_id'] ==
                                                                  e['id'] &&element['page']==pg )['post'] = val;
                                                         data
                                                              .refresh();
                                                        })),
                                                    Obx(() => CheckboxListTile(
                                                      enabled: false,
                                                        title: Text('Partage'),
                                                        value:data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'] &&element['page']==pg )['partage'],
                                                        onChanged: (val) {
                                                          data.value
                                                              .firstWhere((element) =>
                                                                  element[
                                                                      'entreprise_id'] ==
                                                                  e['id'] &&element['page']==pg )['partage'] = val;
                                                         data
                                                              .refresh();
                                                        })),
                                                    Obx(() => CheckboxListTile(
                                                      enabled: false,
                                                        title: Text('message'),
                                                        value:data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id'] &&element['page']==pg )['message'],
                                                        onChanged: (val) {
                                                         data.value
                                                              .firstWhere((element) =>
                                                                  element[
                                                                      'entreprise_id'] ==
                                                                  e['id'] &&element['page']==pg )['message'] = val;
                                                          data
                                                              .refresh();
                                                        })),
                                                    Obx(() => CheckboxListTile(
                                                      enabled: false,
                                                        title: Text('commentaires'),
                                                        value:data.value
                                                            .firstWhere((element) =>
                                                                element[
                                                                    'entreprise_id'] ==
                                                                e['id']&&element['page']==pg )['commentaires'],
                                                        onChanged: (val) {
                                                         data.value
                                                                  .firstWhere(
                                                                      (element) =>
                                                                          element[
                                                                              'entreprise_id'] ==
                                                                          e['id'] &&element['page']==pg )[
                                                              'commentaires'] = val;
                                                         data
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
                              enabled: false,
                              controller: TextEditingController(text: data.value
                                                        .firstWhere((element) =>
                                                            element[
                                                                'entreprise_id'] ==
                                                            e['id'])['commentaire']),
                              
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
                      );
                          
                            }else{
                               return SizedBox();
                            }
                         }
                          catch(e){
                            return SizedBox();
                          }
  }
                      )
                    ],
                  ):Center(
                    child: Column(
                      children: [
                        Text("SeLectionner une date"),
                        Icon(Icons.search ,size: Get.width*0.4,)
                      ],
                    ),
                  )
                  
                       
                ],
              ),
            )),
      ),
     
    );
  }
}