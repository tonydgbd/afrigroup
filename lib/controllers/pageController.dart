import 'dart:math';

import 'package:afrigroup/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PageController extends GetxController {

static PageController instance = Get.find();
var Collection = FirebaseFirestore.instance.collection('pages');
RxList<Map> entreprises = <Map>[].obs;
@override
  void onInit()async{
    // TODO: implement onInit
    super.onInit();

  }
  
}