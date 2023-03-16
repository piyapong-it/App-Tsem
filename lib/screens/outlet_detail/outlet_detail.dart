import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/outletdetail.dart' as outlet;
import 'package:tsem/provider/outlet_provider.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/models/outlettype.dart';
import 'package:tsem/provider/address_provider.dart';
import 'package:tsem/models/province.dart';
import 'package:tsem/models/district.dart';
import 'package:tsem/models/subdistrict.dart';
import 'package:tsem/models/outletall.dart';
import 'package:flutter/scheduler.dart';

class OutletDetail extends StatefulWidget {
  static String routeName = "/outletdetail";

  String outletId;

  OutletDetail({this.outletId});

  @override
  _OutletDetailState createState() => _OutletDetailState();
}

class _OutletDetailState extends State<OutletDetail>
    with WidgetsBindingObserver {
  MessageAlert messageAlert = MessageAlert();
  List<ProvinceResult> _nodeProvince = List<ProvinceResult>();
  List<DistrictResult> _nodeDistrict = List<DistrictResult>();
  List<SubDistrictResult> _nodeSubDistrict = List<SubDistrictResult>();
  List<TypeStatusResult> _nodeOutletType = List<TypeStatusResult>();
  List<TypeStatusResult> _nodeOutletStatus = List<TypeStatusResult>();
  List<OutletAllResult> _nodeOutletAll = List<OutletAllResult>();

  outlet.Result item = outlet.Result();

  final _formKey = GlobalKey<FormState>();

  FocusNode outletTypeFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();

  File _image;
  String _fileName;

  TextEditingController _Address;
  TextEditingController _LatLong;
  TextEditingController _Telphone;
  TextEditingController _Mobile;

  ProvinceResult _selectProvince = ProvinceResult();
  DistrictResult _selectDistrict = DistrictResult();
  SubDistrictResult _selectSubDistrict = SubDistrictResult();
  TypeStatusResult _selectOutlateType = TypeStatusResult();
  TypeStatusResult _selectOutlateStatus = TypeStatusResult();
  OutletAllResult _buyFrom1 = OutletAllResult();
  OutletAllResult _buyFrom2 = OutletAllResult();
  TextEditingController _selectZipcode;
  TextEditingController houseNo;

  @override
  void initState() {
    imageCache.clear();
    // getProvinceData();
    // getOutletType();
    // getOutletStatus();
    // getOutletDetailData();
    // getOutletAll();

    super.initState();
        WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // print('addPostFrameCallback');
      setState(() {});
      await this.getProvinceData();
      await this.getOutletType();
      await this.getOutletStatus();
      await this.getOutletDetailData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.outletName == null ? "" : item.outletName,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            focusNode: saveFocusNode,
            icon: Icon(
              Icons.save,
              size: 35.0,
              color: Colors.blue,
            ),
            tooltip: "Save",
            onPressed: () {
              saveTest();
              // saveOutletDetail();
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
              margin: EdgeInsets.all(15),
              child: SingleChildScrollView(
                  child: Column(children: [
                _buildOutletImage(),
                SizedBox(height: 10),
                // _buildText(
                //     "outletId : ${item.outletId}", 14.0, FontWeight.normal),
                // SizedBox(height: 10),
                _buildText(item.outletName, 16.0, FontWeight.bold),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: Column(children: [
                          TextField(
                            controller: _Address,
                            style: TextStyle(fontSize: 13.0),
                            enabled: false,
                            maxLines: 3, //or null
                            decoration: InputDecoration(
                              labelText: "Address",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.home_work_outlined,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ]),
                      )),
                      IconButton(
                        onPressed: () {
                          DialogExample(context);
                        },
                        icon: Icon(Icons.edit_outlined),
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: Column(children: [
                          TextField(
                            controller: _LatLong,
                            style: TextStyle(fontSize: 13.0),
                            enabled: false,
                            maxLines: null, //or null
                            decoration: InputDecoration(
                              labelText: "Lat. / Long.",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.map,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ]),
                      )),
                      IconButton(
                        onPressed: () {
                          //action coe when button is pressed
                        },
                        icon: Icon(Icons.edit_location_alt),
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _Telphone,
                          style: TextStyle(fontSize: 14.0),
                          enabled: true,
                          keyboardType: TextInputType.number,
                          maxLines: null, //or null
                          decoration: InputDecoration(
                            labelText: "Telphone",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _Mobile,
                          style: TextStyle(fontSize: 14.0),
                          enabled: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Mobile",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField(
                          // Initial Value
                          value: _selectOutlateType,
                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blueAccent,
                          ),
                          iconSize: 30,
                          // dropdownColor: Colors.blue.shade50,

                          decoration: InputDecoration(
                              labelText: "Outlate Type",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 255, 255, 255)),

                          isExpanded: true,

                          // Array list of items
                          items: _nodeOutletType.map((TypeStatusResult value) {
                            return DropdownMenuItem<TypeStatusResult>(
                              value: value,
                              child: Text(value.udc_desc1),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectOutlateType = newValue;
                              print(_selectOutlateType.udc_desc1);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<TypeStatusResult>(
                          // Initial Value
                          value: _selectOutlateStatus,

                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blueAccent,
                          ),
                          iconSize: 30,
                          // dropdownColor: Colors.blue.shade50,

                          decoration: InputDecoration(
                              labelText: "Outlate Status",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white),
                          isExpanded: true,

                          // Array list of items
                          items:
                              _nodeOutletStatus.map((TypeStatusResult value) {
                            return DropdownMenuItem<TypeStatusResult>(
                              value: value,
                              child: Text(value.udc_desc1),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (newValue) {
                            setState(() {
                              _selectOutlateStatus = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<OutletAllResult>(
                          // Initial Value
                          value: _buyFrom1,

                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blueAccent,
                          ),
                          iconSize: 30,
                          // dropdownColor: Colors.blue.shade50,

                          decoration: InputDecoration(
                              labelText: "Buy From 1",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white),
                          isExpanded: true,

                          // Array list of items
                          items: _nodeOutletAll.map((OutletAllResult value) {
                            return DropdownMenuItem<OutletAllResult>(
                              value: value,
                              child: Text(value.outletName),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (newValue) {
                            setState(() {
                              _buyFrom1 = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<OutletAllResult>(
                          // Initial Value
                          value: _buyFrom2,

                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blueAccent,
                          ),
                          iconSize: 30,
                          // dropdownColor: Colors.blue.shade50,
                          decoration: InputDecoration(
                              labelText: "Buy From 2",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white),
                          // isExpanded: true,

                          // Array list of items
                          items: _nodeOutletAll.map((OutletAllResult value) {
                            return DropdownMenuItem<OutletAllResult>(
                              value: value,
                              child: Text(
                                value.outletName,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (newValue) {
                            setState(() {
                              _buyFrom2 = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ])))),
    );
  }

  void getProvinceData() {
    AddressProvider().getProvince().then((value) async {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        setState(() {});
      } else {
        // print('success true');
        setState(() {
          _nodeProvince = value.result;
          _selectProvince = _nodeProvince[0];
        });
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void getDistrictData() {
    AddressProvider()
        .getDistrict(province: _selectProvince.provinceId)
        .then((value) async {
      print("getDistrictData");
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      print(value.result.length);
      if (value.result.length == 0) {
        setState(() {});
      } else {
        setState(() {
          _nodeDistrict = value.result;
          _selectDistrict = _nodeDistrict[0];
        });
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void getSubDistrictData() {
    AddressProvider()
        .getSubDistrict(district: _selectDistrict.districtId)
        .then((value) async {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        setState(() {});
      } else {
        print('success true');
        setState(() {
          _nodeSubDistrict = value.result;
          _selectSubDistrict = _nodeSubDistrict[0];
        });
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void getOutletDetailData() {
    OutletProvider()
        .getOutletByOutletId(outletid: widget.outletId)
        .then((value) async {
      print(value);
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        item = await value.result[0];
        // print('Item $item');

        // _image = await urlToFile(item.outletImage);

        // setState(() {
        //   _image;
        // });
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void getOutletType() {
    OutletProvider()
        .getOutletTypeStatus(Sys_Id: '01', Sys_Md: '05', Sys_Enbled: '1')
        .then((value) async {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        _nodeOutletType = value.result;
        _selectOutlateType = _nodeOutletType[0];
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void getOutletStatus() {
    OutletProvider()
        .getOutletTypeStatus(Sys_Id: '01', Sys_Md: '09', Sys_Enbled: '1')
        .then((value) async {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        _nodeOutletStatus = value.result;
        _selectOutlateStatus = _nodeOutletStatus[0];
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void getOutletAll() {
    OutletProvider().getOutletAll().then((value) async {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        _nodeOutletAll = value.result;
        // _buyFrom1 = _nodeOutletAll[0];
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  Widget _buildText(String ptext, double fs, FontWeight fw) {
    return Text(ptext == null ? "" : ptext,
        style: TextStyle(fontSize: fs, fontWeight: fw));
  }

  Widget _buildOutletImage() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: SizedBox(
                  height: 150,
                  child: _image == null
                      ? Image.asset("assets/images/noimage.jpg")
                      : Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              InkWell(
                onTap: _onAlertPress,
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Color.fromARGB(255, 26, 4, 4)),
                    margin: EdgeInsets.only(left: 200, top: 130),
                    child: Icon(
                      Icons.photo_camera,
                      size: 25,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/gallery.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/take_picture.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }

  Future<void> saveTest() async {
    print('Testing');
    print(_selectOutlateType.udc_desc1);
  }

  Future<void> saveOutletDetail() async {
    String fileName;

    if (_image != null) {
      fileName = widget.outletId;
      _startUploading(fileName);
    } else {
      print('_image null ${_image}');
      Navigator.pop(context);
    }
  }

  Future<void> _startUploading(String fileName) async {
    if (_image == null) {
      messageAlert.okAlert(
          context: context,
          message: "Please Select a profile photo",
          title: "Defect Photo");
    } else {
      _uploadImage(fileName, _image);
    }
  }

  void _uploadImage(String fileName, File image) {
    TsemProvider()
        .uploadImageOutlet(outletid: fileName, imageFile: image)
        .then((value) {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              print('error');
              //Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      } else {
        _fileName = value.message.toString();
        if (_fileName != null) {
          TsemProvider()
              .updateOutletImage(
                  outletid: widget.outletId, imagepath: _fileName)
              .then((value) => Navigator.pop(context));
        }
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  // ================================= Image from camera
  Future getCameraImage() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 25);

    setState(() {
      image = File(pickedFile.path);
      _image = image;
      Navigator.pop(context);
    });
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 25);

    setState(() {
      image = File(pickedFile.path);
      _image = image;
      Navigator.pop(context);
    });
  }

  DialogExample(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        title: new Text('Address'),
        content: Container(
          margin: EdgeInsets.all(25),
          child: SingleChildScrollView(
              child: Column(children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      // add Expanded to have your dropdown button fill remaining space
                      child: DropdownButtonFormField<ProvinceResult>(
                        decoration: InputDecoration(
                            labelText: "Province",
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        // isExpanded:
                        //     true, // this allows your dropdown icon to be visible
                        value: _selectProvince,
                        iconSize: 24,
                        items: _nodeProvince.map((ProvinceResult value) {
                          return DropdownMenuItem<ProvinceResult>(
                            value: value,
                            child: Text(value.provinceName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectProvince = newValue;
                            _selectDistrict = null;
                            _selectSubDistrict = null;
                            refresh() {
                              setState(() {});
                            }

                            // Navigator.pop(context);
                            getDistrictData();
                          });
                        },
                      ),
                    ),
                  ])
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      // add Expanded to have your dropdown button fill remaining space
                      child: DropdownButtonFormField<DistrictResult>(
                        decoration: InputDecoration(
                            labelText: "Amphur",
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        // isExpanded:
                        //     false, // this allows your dropdown icon to be visible
                        value: _selectDistrict,
                        iconSize: 24,
                        items: _nodeDistrict.map((DistrictResult value) {
                          return DropdownMenuItem<DistrictResult>(
                            value: value,
                            child: Text(value.districtName),
                          );
                        }).toList(),

                        onChanged: (newValue) {
                          setState(() {
                            _selectDistrict = newValue;
                            getSubDistrictData();
                          });
                        },
                      ),
                    ),
                  ])
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                      // add Expanded to have your dropdown button fill remaining space
                      child: DropdownButtonFormField<SubDistrictResult>(
                        decoration: InputDecoration(
                            labelText: "Tumbon",
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        // isExpanded:
                        //     false, // this allows your dropdown icon to be visible
                        value: _selectSubDistrict,
                        iconSize: 24,
                        items: _nodeSubDistrict.map((SubDistrictResult value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.subdistrictName),
                          );
                        }).toList(),

                        onChanged: (newValue) {
                          setState(() {
                            _selectSubDistrict = newValue;
                          });
                        },
                      ),
                    ),
                  ])
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
                child: Row(children: [
              Expanded(
                  child: Container(
                child: Column(children: [
                  TextField(
                    controller: _selectZipcode,
                    style: TextStyle(fontSize: 13.0),
                    enabled: false,
                    maxLines: 1, //or null
                    decoration: InputDecoration(
                      labelText: "ZipCode",
                      border: OutlineInputBorder(),
                      // prefixIcon: Icon(
                      //   Icons.home_work_outlined,
                      //   color: Colors.blueAccent,
                      // ),
                    ),
                  ),
                ]),
              )),
            ])),
            SizedBox(height: 8),
            Container(
                child: Row(children: [
              Expanded(
                  child: Container(
                child: Column(children: [
                  TextField(
                    controller: houseNo,
                    style: TextStyle(fontSize: 13.0),
                    enabled: true,
                    maxLines: 2, //or null
                    decoration: InputDecoration(
                      labelText: "houseNo Moo",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.home_work_outlined,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ]),
              )),
            ]))
          ])),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
