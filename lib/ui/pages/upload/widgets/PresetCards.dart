import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/upload/widgets/InitiativeDialog.dart';
import 'package:dtube_go/ui/widgets/Inputs/CustomChoiceCard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PresetCard extends StatelessWidget {
  const PresetCard({
    Key? key,
    required this.currentIndex,
    required this.preset,
    required this.onTapCallback,
  });

  final int currentIndex;
  final Preset preset;

  final VoidCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: 30.w,
          child: Card(
            color: globalBlue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Center(
                          child: FaIcon(preset.icon,
                              size: 10.w, color: globalAlmostWhite)),
                      Text(preset.name,
                          style: Theme.of(context).textTheme.caption)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          onTapCallback();
        });
  }
}

class InitiativePresetCard extends StatelessWidget {
  const InitiativePresetCard(
      {Key? key,
      required this.currentIndex,
      required this.initiative,
      required this.onTapCallback});

  final int currentIndex;
  final Preset initiative;

  final VoidCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30.w,
        height: 15.h,
        child: Stack(
          children: [
            CustomChoiceCard(
              backgroundColor: globalBlue,
              height: 15.h,
              icon: initiative.icon,
              iconColor: globalAlmostWhite,
              iconSize: 10.w,
              label: initiative.name,
              onTapped: () {
                onTapCallback();
              },
              textStyle: Theme.of(context).textTheme.headline6!,
              width: 50.w,
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.question,
                  color: globalAlmostWhite,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return InitiativeDialog(initiative: initiative);
                      });
                },
              ),
            )
          ],
        ));
  }
}

class Preset {
  late String name;
  late String tag;
  late IconData icon;
  late String subject;
  late String description;
  late String details;
  late String moreInfoURL;
  late String imageURL;

  Preset({required this.name, required this.tag, required this.icon});

  Preset.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    tag = json['tag'];
    icon = json['icon'];
    subject = json['subject'];
    description = json['description'];
    details = json['details'];
    moreInfoURL = json['moreInfoURL'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.name;
    data['name'] = this.tag;
    data['icon'] = this.icon;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['details'] = this.details;
    data['moreInfoURL'] = this.moreInfoURL;
    data['imageURL'] = this.imageURL;

    return data;
  }
}
