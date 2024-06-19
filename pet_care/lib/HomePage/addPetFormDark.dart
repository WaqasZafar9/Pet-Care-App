import 'dart:io';
import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/uihelper.dart';

class addPetFormDark extends StatefulWidget {
  Map<String, dynamic> userData;
  addPetFormDark({super.key, required this.userData});

  @override
  State<addPetFormDark> createState() => _addPetFormDarkState();
}

class _addPetFormDarkState extends State<addPetFormDark> {
  bool showSpinner = false;
  LatLng? _current;

  PlatformFile? pickedFile;
  DateTime date = DateTime.now();

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

    setState(() {
      errorMessage = "";
      isErrorVissible = false;
    });

    return true;
  }

  selectFile() async {
    try {
      var extension = ['pdf', 'jpg'];
      var result = await FilePicker.platform.pickFiles(
          dialogTitle: 'Please select an output file:',
          allowedExtensions: extension);
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

  showAlertBoxs() {
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

    if (_permissionGuranted == PermissionStatus.denied) {
      _permissionGuranted = await _locationController.requestPermission();
      if (_permissionGuranted != PermissionStatus.granted) {
        uiHelper.customAlertBox(() {}, context, "Location Not Accessible1");

        return;
      } else {
        _locationController.onLocationChanged
            .listen((LocationData currentLocation) {
          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            setState(() {
              _current =
                  LatLng(currentLocation.latitude!, currentLocation.longitude!);
              // uiHelper.customAlertBox(() {}, context, _current.toString());
              print("Location : $_current");
            });
          }
        });
      }
    } else if (_permissionGuranted == PermissionStatus.granted) {
      _locationController.onLocationChanged
          .listen((LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _current =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            // uiHelper.customAlertBox(() {}, context, _current.toString());
            print("Location : $_current");
          });
        }
      });
      return;
    }
    uiHelper.customAlertBox(() {}, context, "Location Not Accessible2");
  }

  String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  submitForm() async {
    setState(() {
      showSpinner = true;
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
          // todo Fix pop as when pet added automatically pop back to home screen
          Navigator.pop(context);
        } else {
          setState(() {
            // todo Fix Spinner Issue on Upload Failed
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
    } catch (ex) {
      setState(() {
        showSpinner = false;
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
    // uiHelper.customAlertBox(() { }, context, "errorMessage");
    return AlertDialog(
      title: Text("Error"),
      content: Text(errorMessage),
      actions: <Widget>[
        TextButton(
          child: Text("OK"),
          onPressed: () {
            setState(() {
              isErrorVissible = false;
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Pet",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: listTileColorSecond,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            gradient: backgroundColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: petForm,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // var imagePicker = ImagePicker();
                        // var image = await imagePicker.pickImage(
                        //     source: ImageSource.gallery);
                        // if (image != null) {
                        //   setState(() {
                        //     pickedImage = File(image.path);
                        //     isImageUpload = true;
                        //   });
                        // }
                        showAlertBoxs();
                      },
                      child: CircleAvatar(
                        backgroundColor: buttonColor,
                        radius: 60,
                        backgroundImage:
                        pickedImage != null ? FileImage(pickedImage!) : null,
                        child: pickedImage == null
                            ? Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Colors.grey,
                        )
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: petNameController,
                      validator: (value) => isNameFilled(value),
                      decoration: InputDecoration(
                        labelText: "Pet Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: oneLineController,
                      validator: (value) => isOneLineFilled(value),
                      decoration: InputDecoration(
                        labelText: "One Line",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text(
                                  "Cat",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                value: "Cat",
                                groupValue: selectedCategory,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedCategory = value!;
                                    dropdownvalue = catValue.first;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text("Dog",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                value: "Dog",
                                groupValue: selectedCategory,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedCategory = value!;
                                    dropdownvalue = dogValue.first;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                      value: dropdownvalue,
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalue = newValue as String;
                        });
                      },
                      items: (selectedCategory == "Cat" ? catValue : dogValue)
                          .map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: "Breed",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Date of Birth :",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    date = pickedDate;
                                    isDateOfBirthSelected = true;
                                    dateOfBirthController =
                                    "${date.day}/${date.month}/${date.year}";
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                disabledBackgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                dateOfBirthController.isEmpty
                                    ? "Select Date of Birth"
                                    : dateOfBirthController,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: subTextColor
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: false,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Medical File:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              ElevatedButton(
                                onPressed: selectFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Upload ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: subTextColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appBarColor,
                        minimumSize: Size(220, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Add Pet",
                        style: TextStyle(
                          fontSize: 18,
                          color: subTextColor
                        ),
                      ),
                    ),
                    if (isErrorVissible)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: showAlertBox(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
