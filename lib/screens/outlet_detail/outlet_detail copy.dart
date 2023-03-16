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

class OutletDetail extends StatefulWidget {
  static String routeName = "/outletdetail";

  String outletId;

  OutletDetail({this.outletId});

  @override
  _OutletDetailState createState() => _OutletDetailState();
}

class _OutletDetailState extends State<OutletDetail> {
  MessageAlert messageAlert = MessageAlert();

  outlet.Result item = outlet.Result();

  final _formKey = GlobalKey<FormState>();

  FocusNode outletTypeFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();

  File _image;
  String _fileName;

  @override
  void initState() {
    imageCache.clear();
    getOutletDetailData();
    super.initState();
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
            ),
            tooltip: "Save",
            onPressed: () {
              saveOutletDetail();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOutletImage(),
                      SizedBox(height: 10),
                      _buildText(
                          "Id : ${item.outletId}", 14.0, FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText(item.outletName, 20.0, FontWeight.bold),
                      SizedBox(height: 10),
                      _buildText(item.outletType, 16.0, FontWeight.bold),
                      SizedBox(height: 10),
                      _buildText(item.address, 16.0, FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText("${item.city}", 16.0, FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText("${item.province} ${item.zipCode}", 16.0,
                          FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText(
                          "Lat:${item.gpsLatitude} Long:${item.gpsLongtitude}",
                          16.0,
                          FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText("Telephone : ${item.telephone}", 16.0,
                          FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText(
                          "Mobile : ${item.mobile}", 16.0, FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText("Key outlet : ${item.keyOutlet}", 16.0,
                          FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText(
                          "Channel : ${item.channel}", 16.0, FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText(
                          "Grade : ${item.grade}", 16.0, FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText(
                          "GAME : ${item.game}", 16.0, FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText("Buy from 1 : ${item.buyFrom1}", 16.0,
                          FontWeight.normal),
                      SizedBox(height: 10),
                      _buildText("Buy from 2 : ${item.buyFrom2}", 16.0,
                          FontWeight.normal),
                      SizedBox(height: 50),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void getOutletDetailData() {
    OutletProvider()
        .getOutletByOutletId(outletid: widget.outletId)
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
        item = await value.result[0];
        print('Item$item');

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

  Future<File> urlToFile(String imageUrl) async {
    Dio dio = Dio();
    // generate random number.
    var rng = new Random();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(10)).toString() + '.jpg');
    Response response = await dio.get(
      imageUrl,
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
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
                  //width: 150,
                  height: 200,
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
                        color: Colors.black),
                    margin: EdgeInsets.only(left: 250, top: 180),
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

  Widget _buildText(String ptext, double fs, FontWeight fw) {
    return Text(ptext == null ? "" : ptext,
        style: TextStyle(fontSize: fs, fontWeight: fw));
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
}
