import 'package:flutter/material.dart';
import 'package:glud/glud_pages/finishpage.dart';
import '../widgets.dart';

class ReportPageD extends StatefulWidget {
  const ReportPageD({Key? key}) : super(key: key);

  @override
  _ReportPageDState createState() => _ReportPageDState();
}

class _ReportPageDState extends State<ReportPageD> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: const [
              SizedBox(height: 20),
              Text(
                '보도자료'
              ),
          ],
          ),
        ),
      ),
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: whitestyle,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        iconSize: 20,
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '보도자료',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      titleSpacing: -10,
      toolbarHeight: 100,
    );
  }
}
