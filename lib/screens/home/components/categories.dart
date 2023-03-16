import 'package:flutter/material.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/performance/performance.dart';
import 'package:tsem/screens/sales_folder/sales_folder.dart';
import 'package:tsem/screens/visit_mjp/visit_mjp.dart';

import '../../../size_config.dart';

class Items {
  String title;
  String subtitle;
  String event;
  String img;

  Items({this.title, this.subtitle, this.event, this.img});
}

class Categories extends StatelessWidget {
  Items item1 = new Items(
      title: "My Oultet",
      subtitle: "ร้านค้าที่เราดูแล",
      event: OutletScreen.routeName,
      img: "assets/images/shop.png");

  Items item2 = new Items(
    title: "Visit",
    subtitle: "Visit by MJP",
    event: VisitMjpScreen.routeName,
    img: "assets/images/calendar.png",
  );

  Items item4 = new Items(
    title: "Sales Folder",
    subtitle: "คู่มือขาย",
    event: SalesFolderScreen.routeName,
    img: "assets/images/tap_icon.png",
  );
  Items item5 = new Items(
    title: "Performance",
    subtitle: "รายงาน",
    //event: AnimateCharts.routeName,
    event: PerformanceScreen.routeName,
    img: "assets/images/graph.png",
  );
  Items item6 = new Items(
    title: "Outlet Nearby",
    subtitle: "ร้านค้ารัศมี 1กม",
    event: "/outletnearby",
    img: "assets/images/shop.png",
  );
  Items item7 = new Items(
    title: "My Task",
    subtitle: "งานของฉัน",
    event: "/mytaskscreen",
    img: "assets/images/task.jpg",
  );
  Items item8 = new Items(
    title: "Outlet Map",
    subtitle: "แผนที่ร้านค้า",
    event: "/outletcensus",
    img: "assets/images/map.png",
  );
  Items item9 = new Items(
    title: "Tracking order",
    subtitle: "ติดตามorder",
    event: "/outletcensus",
    img: "assets/images/map.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
      item6,
      item7,
      item4,
      item5,
      item8,
      item9
    ];
    Color color = Color(0xFFFFECDF);

    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1.0,
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(10),
          right: getProportionateScreenWidth(10),
          bottom: getProportionateScreenWidth(10)),
      /*crossAxisCount: 4,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,*/
      crossAxisCount: 3,
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      children: myList.map((data) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, data.event);
          },
          child: Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  data.img,
                  width: getProportionateScreenWidth(40),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    data.subtitle,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
