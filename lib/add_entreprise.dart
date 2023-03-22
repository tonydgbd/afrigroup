import 'dart:io';

import 'package:afrigroup/controllers/entreprise_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ADDSCreen extends StatelessWidget {
  RxString url = ''.obs;
  TextEditingController name = TextEditingController();
  RxList<String> pages = ['Facebook'].obs;
  ADDSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un partenaire'),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Nom du partenaire'),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  var file = (await ImagePicker()
                      .pickImage(source: ImageSource.gallery))!;
                  if (file != null) {
                    Reference firebaseStorageRef =
                        FirebaseStorage.instance.ref().child(file.path);

                    if (kIsWeb) {
                      Uint8List bytes = await file.readAsBytes();

                      UploadTask uploadTask = firebaseStorageRef.putData(
                          bytes, SettableMetadata(contentType: 'image/png'));
                      TaskSnapshot taskSnapshot = await uploadTask
                          .whenComplete(() => print('done'))
                          .catchError((error) => print('something went wrong'));
                      url.value = await taskSnapshot.ref.getDownloadURL();
                    } else {
                      UploadTask uploadTask =
                          firebaseStorageRef.putFile(File(file.path));
                      TaskSnapshot taskSnapshot = await uploadTask
                          .whenComplete(() => print('done'))
                          .catchError((error) => print('something went wrong'));
                      url.value = await firebaseStorageRef.getDownloadURL();
                    }
                    //  uploadTask.
                  }
                },
                child: Obx(() => CircleAvatar(
                      radius: Get.width * 0.3,
                      // ignore: unnecessary_null_comparison
                      child: url.value == ''
                          ? Icon(
                              Icons.photo_camera,
                              size: Get.width * 0.25,
                            )
                          : Image.network(url.value),
                    )),
              ),
            ),
            Obx(() => CheckboxListTile(
                  value: pages.value.contains('Facebook'),
                  onChanged: (val) {
                    val == false
                        ? pages.value.remove('Facebook')
                        : pages.value.add('Facebook');
                        pages.refresh();
                  },
                  title: Text('Page Facebook'),
                )),
                 Obx(() => CheckboxListTile(
                  value: pages.value.contains('Instagram'),
                  onChanged: (val) {
                    val == false
                        ? pages.value.remove('Instagram')
                        : pages.value.add('Instagram');
                        pages.refresh();
                  },
                  title: Text('Page Instagram'),
                )),
                   Obx(() => CheckboxListTile(
                  value: pages.value.contains('LinkedIn'),
                  onChanged: (val) {
                    val == false
                        ? pages.value.remove('LinkedIn')
                        : pages.value.add('LinkedIn');
                        pages.refresh();
                  },
                  title: Text('Page LinkedIn'),
                )),
            CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text('Ajouter'),
                onPressed: () {
                  if (name.text.isEmpty) {
                    Get.showSnackbar(GetSnackBar(
                      message: 'Entrez le nom du partenaire',
                      duration: Duration(seconds: 5),
                    ));
                  } else {
                    EntrepriseController.instance
                        .addEntreprise(name.text, url.value, pages);
                  }
                })
          ],
        ),
      )),
    );
  }
}
