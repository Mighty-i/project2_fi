import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class history extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Text(
              '1 ม.ค. 2567',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
          child: Text(
            'รายการที่ดำเนินการซ่อม',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children:
                List.generate(10, (index) => buildListItem(index)).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'ทะเบียนรถ\n1กด6444',
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Text(
                      'ขั้นตอนรอตรวจสอบ: 2.โป๊ว',
                    ),
                  ),
                  Text(
                    'ขั้นตอนล่าสุด: 3.พ่นสี',
                  ),
                ],
              ),
              SizedBox(height: 10),
              GFIconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_right_outlined),
                shape: GFIconButtonShape.circle,
              ),
            ],
          ),
          SizedBox(height: 10),
          GFProgressBar(
            // padding: EdgeInsets.fromLTRB(16, 20, 16, 16),\
            percentage: 0.4,
            lineHeight: 30,
            backgroundColor: Colors.grey,
            progressBarColor: Colors.teal,
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
                '20%',
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
