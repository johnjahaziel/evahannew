import 'package:evahan/screens/reportlist/approvedlist.dart';
import 'package:evahan/screens/reportlist/pendinglist.dart';
import 'package:evahan/screens/reportlist/rejectedlist.dart';
import 'package:evahan/size_config.dart';
import 'package:evahan/utility/customappbar.dart';
import 'package:evahan/utility/customdrawer.dart';
import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';

class Reportlist extends StatefulWidget {
  const Reportlist({super.key});

  @override
  State<Reportlist> createState() => _ReportlistState();
}

class _ReportlistState extends State<Reportlist> {
  bool isPendingSelected = true;
  bool isApprovedSelected = false;
  bool isRejectedSelected = false;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      backgroundColor: bg,
      appBar: Customappbar(),
      drawer: Customdrawer(),
      body: Column(
          children: [
            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isPendingSelected = true;
                          isApprovedSelected = false;
                          isRejectedSelected = false;
                        });
                      },
                      constraints: BoxConstraints(),
                      padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                      fillColor: isPendingSelected ? kred : kwhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        side: BorderSide(
                          color: kgrey
                        )
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Pending',
                          style: customtext(
                            fs14,
                            isPendingSelected ? kwhite : kred,
                            FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.w(10),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isPendingSelected = false;
                          isApprovedSelected = true;
                          isRejectedSelected = false;
                        });
                      },
                      constraints: BoxConstraints(),
                      fillColor: isApprovedSelected ? kred : kwhite,
                      padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        side: BorderSide(
                          color: kgrey
                        )
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Approved',
                          style: customtext(
                            fs14,
                            isApprovedSelected ? kwhite : kred,
                            FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.w(10),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isPendingSelected = false;
                          isApprovedSelected = false;
                          isRejectedSelected = true;
                        });
                      },
                      constraints: BoxConstraints(),
                      fillColor: isRejectedSelected ? kred : kwhite,
                      padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConfig.w(15),vertical: SizeConfig.h(8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        side: BorderSide(
                          color: kgrey
                        )
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Rejected',
                          style: customtext(
                            fs14,
                            isRejectedSelected ? kwhite : kred,
                            FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
            
            SizedBox(height: 10),

            Expanded(
              child: isPendingSelected
                ? Pending()
                : isApprovedSelected
                    ? ApprovedDriver()
                    : Rejected(),
            )

          ],
        ),
      ),
    );
  }
}