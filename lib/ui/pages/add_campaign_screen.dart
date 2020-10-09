import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shofar/constants.dart';
import 'package:shofar/main.dart';
import 'package:shofar/providers/campaign_provider.dart';
import 'package:shofar/ui/widgets/dialogs/custom_dialog.dart';
import 'package:shofar/ui/widgets/text_form.dart';
import 'package:shofar/utils/date_cal.dart';

String defaultImageUrl =
    "https://raw.githubusercontent.com/berberin/Olifant/master/images/3081629.jpg";
//String defaultImageUrl = "https://raw.githubusercontent.com/berberin/Olifant/master/images/Screenshot.png";

class AddCampaignScreen extends StatefulWidget {
  @override
  _AddCampaignScreenState createState() => _AddCampaignScreenState();
}

class _AddCampaignScreenState extends State<AddCampaignScreen> {
  TextEditingController titleCtrl;
  TextEditingController descriptionCtrl;
  TextEditingController imageUrlCtrl;
  TextEditingController targetCtrl;
  CampaignProvider campaignProvider;
  String dateString;
  DateTime due;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController();
    imageUrlCtrl = TextEditingController();
    descriptionCtrl = TextEditingController();
    targetCtrl = TextEditingController();
    campaignProvider = CampaignProvider();
  }

  @override
  void dispose() {
    descriptionCtrl.dispose();
    titleCtrl.dispose();
    imageUrlCtrl.dispose();
    targetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Color(0xfffefefe),
        child: Scaffold(
          //resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xfffefefe),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add your campaign",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "Title",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextForm(
                    labelText: "Enter a Title",
                    hintText: "Campaign\'s title",
                    controller: titleCtrl,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Cover Image URL",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextForm(
                    labelText: "Enter an image's URL",
                    controller: imageUrlCtrl,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextForm(
                    labelText: "About your project & plan",
                    controller: descriptionCtrl,
                    maxline: 8,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Target",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextForm(
                    labelText: "Your target (in ONE)",
                    controller: targetCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Due date",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text("Pick a date (UTC)"),
                        onPressed: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime.now().toUtc(),
                            onConfirm: (date) {
                              due = date;
                              setState(() {
                                dateString = dateToDisplay(date);
                              });
                            },
                            currentTime: DateTime.now().toUtc(),
                          );
                        },
                      ),
                      Text(dateString ?? "-- -- --"),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ButtonTheme(
                      minWidth: 150,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          "START CAMPAIGN",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        color: secText,
                        onPressed: () async {
                          bool res;
                          showLoadingDialog(context);
                          try {
                            res = await tryCreateCampaign(
                              title: titleCtrl.text,
                              imageUrl: (imageUrlCtrl.text == null ||
                                      imageUrlCtrl.text == '')
                                  ? defaultImageUrl
                                  : imageUrlCtrl.text,
                              description: descriptionCtrl.text,
                              targetFund: double.parse(targetCtrl.text),
                              due: due,
                            );
                          } catch (e) {
                            print(e);
                          }
                          Navigator.pop(context);

                          showNormalDialog(
                            usePreDialog: false,
                            context: context,
                            widget: AlertDialog(
                              title: Text((res == true) ? "Success" : "Error"),
                              content: Text((res == true)
                                  ? "Create successfully."
                                  : "Some errors occur. Please try again later."),
                              actions: [
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomeScreenScaffold();
                                    }));
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> tryCreateCampaign(
      {String title,
      String imageUrl,
      String description,
      double targetFund,
      DateTime due}) async {
    if (title == null ||
        title == '' ||
        description == null ||
        description == '' ||
        due == null) {
      return false;
    }

    try {
      bool ok = await campaignProvider.createCampaign(
        title: title,
        imageUrl: imageUrl,
        description: description,
        targetFund: targetFund,
        due: due,
      );
      return ok;
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
