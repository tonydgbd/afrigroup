import 'dart:math';

import 'package:afrigroup/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
class EntrepriseController extends GetxController {

static EntrepriseController instance = Get.find();
var entrepriseCollection = FirebaseFirestore.instance.collection('Entreprises');
RxList<Map> entreprises = <Map>[].obs;
  var data =  [].obs;
    var isDeviceConnected = false;
@override
  void onInit()async{
    // TODO: implement onInit
    super.onInit();
    getEntreprises();
  

var subscription = InternetConnectionCheckerPlus.createInstance().onStatusChange.listen((InternetConnectionStatus result) async {
  
    if(result != InternetConnectionStatus.connected){
      FirebaseFirestore.instance.disableNetwork();
    }else{
      FirebaseFirestore.instance.enableNetwork();
    }
  
});

  }
  addEntreprise(String nom,String url,List<String> page) async {
    try {
      EasyLoading.show(status: 'loading...');
       await entrepriseCollection.add({
      'id':Random().nextInt(9999).toString(),
      'nom':nom,
      'logo':url,
      'page':page
    });
    await getEntreprises();
    EasyLoading.dismiss();
    Get.to(MyHomePage());
    } catch (e) {
    EasyLoading.dismiss();

      Get.showSnackbar(GetSnackBar(message:'Une erreur est survenu veuillez reesayer plus tard',));
    }
   
  }
  getEntreprises()async {
    try {
      var today = DateTime.now();
      entreprises.value.clear();
      EasyLoading.show();
       var  rs = await entrepriseCollection.get();
   for (var element in rs.docs) {
    entreprises.add(element.data());
  
   }
     print(entreprises);
   entreprises.refresh();
    var d =await FirebaseFirestore.instance.collection('pages').doc("${today.day}_${today.month}_${today.year}").get();
    if (d.exists == false){
         for ( var entr in entreprises){
    var nbr_pages = (entr['page'] as List).length;
    if(nbr_pages ==1){
   data.value.add({
    'entreprise_id' : entr['id'],
    'page': (entr['page'] as List).first,
    'message':false,
    'post':false,
    'partage':false,
    'commentaires':false,
    });
    }else{
      for (var element in (entr['page'] as List)) {
        data.value.add({
    'entreprise_id' : entr['id'],
    'page': element,
    'message':false,
    'post':false,
    'partage':false,
    'commentaires':false,
    });
      }
    }
   }
   data.refresh();
    }
    else{
     data.value = d.data()!['data'];
    }

   print(data);
   EasyLoading.dismiss();
    } catch (e) {
      print(e);
      EasyLoading.showError(e.toString());      
    }
  
  }
}