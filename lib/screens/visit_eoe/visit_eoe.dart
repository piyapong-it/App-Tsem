import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/visiteoe.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../size_config.dart';

class VisitEoeScreen extends StatefulWidget {
  static String routeName = "/visiteoe";

  String outletId;
  String outletName;
  DateTime visitDate;
  int agendaId;
  String agendaGroup;

  VisitEoeScreen(
      {this.outletId,
      this.visitDate,
      this.outletName,
      this.agendaId,
      this.agendaGroup});

  @override
  _VisitEoeScreenState createState() => _VisitEoeScreenState();
}

class _VisitEoeScreenState extends State<VisitEoeScreen> {
  List<Result> _nodes = List<Result>();
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    VisitProvider()
        .getVisitEOE(
            outletid: widget.outletId,
            visitdate: widget.visitDate,
            group: widget.agendaGroup)
        .then((value) {
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
      }
      setState(() {
        _nodes.addAll(value.result);
      });
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: DefaultControl.headerText(
              headText: widget.outletName +
                  " " +
                  DateFormat('d MMM').format(widget.visitDate)),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                size: 35.0,
              ),
              tooltip: "Save",
              onPressed: () {
                saveEoeHead();
              },
            ),
          ],
        ),
        body: _nodes.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _showEOE());
  }

  Widget _showEOE() {
    return Container(
      decoration: (BoxDecoration(
        color: Color(0xFFFFECDF),
      )),
      child: Column(
        children: [
          // SizedBox(height: SizeConfig.screenHeight * 0.02),
          // Text(
          //   DateFormat('d/MMM/yy').format(widget.visitDate),
          //   style:
          //   TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          // ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return itemEoe(_nodes[index]);
                },
                itemCount: _nodes.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemEoe(Result item) {
    bool _isChecked = item.eoeFlag == 'Y' ? true : false;
    Color _borderColor = item.eoeFocus == 'Y' ? Colors.red : Colors.white;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
              _isChecked ? item.eoeFlag = 'Y' : item.eoeFlag = 'N';
              detailClick(item);
            });
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: _borderColor, width: 4.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child:
                  // Image.network(
                  //   item.eoeImage,
                  //   fit: BoxFit.cover,
                  //   width: SizeConfig.screenHeight * 0.16,
                  // ),
                  FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                width: SizeConfig.screenHeight * 0.16,
                placeholder: kTransparentImage,
                image: item.eoeImage,
              ),
            ),
          ),
        ),
        Expanded(
            child: Text(
          item.eoeText,
          style: TextStyle(fontSize: 17.0, color: Colors.black),
        )),
        Expanded(
          child: Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value;
                  value ? item.eoeFlag = 'Y' : item.eoeFlag = 'N';
                  detailClick(item);
                });
              }),
        )
      ],
    );
  }

  void saveEoeHead() {
    if (_nodes != null) {
      VisitProvider()
          .updateVisitAgenda(
              visitId: _nodes[0].visitId,
              agendaId: _nodes[0].agendaId,
              visitStatus: "DONE")
          .then((value) => Navigator.pop(context));
    }
  }

  void detailClick(Result item) {
    VisitProvider().updateVisitEoE(
        visitId: item.visitId,
        agendaId: item.agendaId,
        eoeSeq: item.eoeSeq,
        eoeFlag: item.eoeFlag);
  }
}
