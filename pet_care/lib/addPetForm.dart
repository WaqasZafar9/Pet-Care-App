import 'dart:io';
import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/SignUpPageForm.dart';
import 'package:pet_care/uihelper.dart';

class addPetForm extends StatefulWidget {
  Map<String,dynamic> userData;
  addPetForm({super.key,required this.userData});

  @override
  State<addPetForm> createState() => _addPetFormState();
}

class _addPetFormState extends State<addPetForm> {

  bool showSpinner =false;


  LatLng? _current;

  PlatformFile? pickedFile;
  DateTime date = DateTime(2024);

  GlobalKey<FormState> petForm = GlobalKey<FormState>();
  TextEditingController petNameController = TextEditingController();
  TextEditingController oneLineController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController fileController = TextEditingController();
  String dateOfBirthController = "";
  String dropdownvalue = 'Cat';
  File? pickedImage;
  String selectedCategory = "Cat", errorMessage = "";
  bool isImageUpload = false,
      isMedicalFileUploaded = false,
      isDateOfBirthSelected = false,
      isErrorVissible = false;

  var catValue = [
    'Cat',
    'Persian',
    'Siamese',
    'Maine Coon',
    'Bengal',
    'Ragdoll',
    'British Shorthair',
    'Sphynx',
    'Abyssinian',
    'Scottish Fold',
    'Siberian'
  ];
  var dogValue = [
    'Dog',
    'Labrador Retriever',
    'German Shepherd',
    'Golden Retriever',
    'Bulldog',
    'Beagle',
    'Poodle',
    'French Bulldog',
    'Rottweiler',
    'Yorkshire Terrier',
    'Boxer'
  ];

  @override
  void initState() {
    dateOfBirthController = "${date.day}/${date.month}/${date.year}";
    getLocationUpdates();
    super.initState();
  }

  allValuesFilled() {
    if (isImageUpload == false) {
      setState(() {
        errorMessage = "Please Upload Pet Pic";
        isErrorVissible = true;
      });

      return false;
    }

    if (isDateOfBirthSelected == false) {
      setState(() {
        errorMessage = "Please Select Pet Date Of Birth";
        isErrorVissible = true;
      });

      return false;
    }

    // if (isMedicalFileUploaded == false) {
    //   setState(() {
    //     errorMessage = "Please Upload Pet Medical File";
    //     isErrorVissible = true;
    //   });
    //
    //   return false;
    // }

    setState(() {
      errorMessage = "";
      isErrorVissible = false;
    });

    return true;
  }

  selectFile() async{


    try {
      var extension = ['pdf', 'jpg'];
      var result = await FilePicker.platform.pickFiles( dialogTitle: 'Please select an output file:',allowedExtensions: extension);
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          isMedicalFileUploaded = true;
          pickedFile = result.files.first;
        });
      } else {
        // User canceled the file picking
        print('No file selected');
      }
    } catch (e) {
      // Handle errors
      print('Error picking file: $e');
    }


  }

  uploadFile(){
    var file= File(pickedFile!.path!);

    var fileUrl=DataBase.uploadImage(pickedFile!.name,"Medical Files", file);
    return fileUrl;

  }

  Future<void> getLocationUpdates() async {

    Location _locationController = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGuranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGuranted = await _locationController.hasPermission();

    if (_permissionGuranted == PermissionStatus.denied ) {

      _permissionGuranted = await _locationController.requestPermission();
      if (_permissionGuranted != PermissionStatus.granted) {

        uiHelper.customAlertBox(() { }, context, "Location Not Accessible1");

        return;
      }
      else {
        _locationController.onLocationChanged
            .listen((LocationData currentLocation) {
          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            setState(() {
              _current = LatLng(currentLocation.latitude!, currentLocation.longitude!);
              uiHelper.customAlertBox(() { }, context, _current.toString());
              print("Location : $_current");
            });
          }
        });
      }
    }
    else if(_permissionGuranted == PermissionStatus.granted){

      _locationController.onLocationChanged
          .listen((LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _current = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            uiHelper.customAlertBox(() { }, context, _current.toString());
            print("Location : $_current");
          });
        }
      });
      return ;
    }
    uiHelper.customAlertBox(() {}, context, "Location Not Accessible2");
  }


  String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  submitForm() async{

    setState(() {
      showSpinner=true;
    });



    try {
      if (allValuesFilled()) {
        if (petForm.currentState!.validate()) {
          // Todo Fix Database Logic how to Store and Retrieve Data
          // Todo Rename Email to ID



          Map<String, dynamic> petData = {

            "Email": randomString(12),
            "Name": petNameController.value.text,
            "oneLine": oneLineController.value.text,
            "Category": selectedCategory,
            "Breed": dropdownvalue,
            "DateOfBirth": dateOfBirthController,
            "Photo": "",
            "MedicalFile": "",
            "LAT": _current?.latitude,
            "LONG": _current?.longitude
          };

          var url = await DataBase.uploadImage(
              petData["Email"], "PetPics", pickedImage);

          // var fileUrl=uploadFile();

          // Todo Fix Upload File

          petData["Photo"] = url;
          petData["MedicalFile"] = "fileUrl";

          if (await DataBase.saveUserData(widget.userData["Email"], petData)) {
            setState(() {
              showSpinner = false;
            });
            uiHelper.customAlertBox(() {}, context, "Saved");
          }


          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Pet Added!',
              message: 'Pet Added SuccessFully',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          setState(() {
            showSpinner = false;
          });
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Information Required!',
              message: 'Please Fill Out all the Information',
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      setState(() {
        showSpinner = false;
      });
    }
    catch (ex){
      setState(() {
        showSpinner=false;
      });
      print(ex.toString());
    }
  }

  isNameFilled(value) {
    if (value == "") {
      return "Please Enter Pet Name";
    }
    return null;
  }

  isOneLineFilled(value) {
    if (value == "") {
      return "Please Enter One Line";
    }
    return null;
  }

  showAlertBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pic Image From"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.image),
                title: Text("Gallery"),
              )
            ],
          ),
        );
      },
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) {
        return;
      }
      final tempImage = File(photo.path);
      setState(() {
        isImageUpload = true;
        pickedImage = tempImage;
      });
    } catch (ex) {
      print("Error ${ex.toString()}");
    }
  }

  uploadImage(email, collection, pickedImage) async {
    try {
      print("Upload 1");
      UploadTask uploadTask = FirebaseStorage.instance
          .ref(collection)
          .child(email)
          .putFile(pickedImage!);
      print("Upload 2 :- ${uploadTask.toString()}");
      TaskSnapshot taskSnapshot = await uploadTask;
      print("Upload 3");
      String url = await taskSnapshot.ref.getDownloadURL();
      print("Upload 4");
      return url;
    } on FirebaseException catch (ex) {
      print("Error ${ex.toString()}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _current == null
        ? Center(
      child: CircularProgressIndicator(),
    )
        :  ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
                color: Colors.tealAccent,
                child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.blueGrey.shade50,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Opacity(
                          opacity: 0.6,
                          child: InkWell(
                              onTap: () => showAlertBox(),
                              child: pickedImage != null
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundImage: FileImage(pickedImage!),
                                    )
                                  : CircleAvatar(
                                      radius: 41,
                                      child: Stack(children: [
                                        Positioned(
                                          top: 15,
                                          left: 20,
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                          ),
                                        ),
                                        Positioned(
                                          top: 53,
                                          left: 30,
                                          child: Icon(
                                            Icons.add,
                                            size: 20,
                                          ),
                                        ),
                                        Positioned(
                                          top: 52,
                                          child: Opacity(
                                            opacity: 0.3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(40),
                                                      bottomRight:
                                                          Radius.circular(40))),
                                              width: 80,
                                              height: 30,
                                            ),
                                          ),
                                        )
                                      ]),
                                    ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Form(
                    key: petForm,
                    child: Container(
                      color: Colors.tealAccent,
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(12),
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            maxLength: 12,
                            controller: petNameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                hintText: ("Pet Name"),
                                prefixIcon: Icon(Icons.pets),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            validator: (value) => isNameFilled(value),
                          ),
                          Text("One Line",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          TextFormField(
                            maxLength: 16,
                            controller: oneLineController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                hintText: ("One Line"),
                                prefixIcon: Icon(Icons.pets),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            validator: (value) => isOneLineFilled(value),
                          ),
                          Text("Category",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          RadioListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            title: Text('Dog',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            value: 'Dog',
                            groupValue: selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                                dropdownvalue = "Dog";
                              });
                            },
                          ),
                          RadioListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            title: Text('Cat',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            value: 'Cat',
                            groupValue: selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                                dropdownvalue = "Cat";
                              });
                            },
                          ),
                          Text("Breed",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          DropdownButton(
                            dropdownColor: Colors.grey,

                            borderRadius: BorderRadius.circular(10),

                            isExpanded: true,

                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),

                            // Array list of items
                            items: selectedCategory == "Cat"
                                ? catValue.map((String items) {
                                    return DropdownMenuItem(
                                        value: items, child: Text(items));
                                  }).toList()
                                : dogValue.map((String items) {
                                    return DropdownMenuItem(
                                        value: items, child: Text(items));
                                  }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                          Text("Date of  Birth",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? datePicked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now(),
                              );
                              if (datePicked != null) {
                                setState(() {
                                  date = datePicked;
                                  dateOfBirthController =
                                      "${date.day}/${date.month}/${date.year}";
                                  print("Time : $datePicked");
                                  isDateOfBirthSelected = true;
                                });
                              }
                            },
                            child: Text(dateOfBirthController),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)))),
                            ),
                          ),
                          Text("Medical File",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {

                                  selectFile();

                                },
                                child: Text("Upload File"),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(6)))),
                                ),
                              ),

                                pickedFile !=null ? Text(pickedFile!.name.toString()):SizedBox(width: 0,)

                            ],
                          ),
                          Visibility(
                            visible: isErrorVissible,
                            child: Center(
                              child: Text(errorMessage,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.redAccent.shade700)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.purple,
                    child: ElevatedButton(
                      onPressed: () {
                        submitForm();
                      },
                      child: Text(
                        "Add Pet",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromRGBO(208, 187, 187, 1),
                        ),
                        minimumSize: MaterialStateProperty.all(Size.infinite),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(7.0),
                          bottomRight: Radius.circular(7.0),
                        ))),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
                ),
              ),
        );
  }
}
