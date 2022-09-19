import 'package:dtube_go/res/Config/InitiativePresets.dart';
import 'package:dtube_go/ui/pages/upload/UploaderMainPage.dart';
import 'package:dtube_go/ui/widgets/AppBar/DTubeSubAppBarDesktop.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Widgets/PresetCards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UploadPresetSelectionDesktop extends StatefulWidget {
  UploadPresetSelectionDesktop({Key? key, required this.uploaderCallback})
      : super(key: key);
  final VoidCallback uploaderCallback;

  @override
  _UploadPresetSelectionDesktopState createState() =>
      _UploadPresetSelectionDesktopState();
}

class _UploadPresetSelectionDesktopState
    extends State<UploadPresetSelectionDesktop> {
  List<int> _ativeCustomPresets = [0];
  List<Preset> _initiativePresets = [];
  List<Preset> _customPresets = [];
  bool _presetSelected = false;
  late Preset _selectedPreset;

  late Future<bool> _customPresetsLoaded;

  Future<bool> getCustomPresets() async {
    String _customPresetSubject = await sec.getTemplateTitle();
    String _customPresetBody = await sec.getTemplateBody();
    String _customPresetTag = await sec.getTemplateTag();
    var customPreset = {
      "name": "Default",
      "icon": FontAwesomeIcons.penToSquare,
      "tag": _customPresetTag,
      "subject": _customPresetSubject,
      "description": _customPresetBody,
      "details": "",
      "moreInfoURL": "",
      "imageURL": ""
    };
    setState(() {
      _customPresets.add(new Preset.fromJson(customPreset));
    });

    return true;
  }

  @override
  void initState() {
    // load initiative preset
    initiativePresets.forEach((g) {
      _initiativePresets.add(new Preset.fromJson(g));
    });
    // load custom preset
    _customPresetsLoaded = getCustomPresets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: dtubeSubAppBarDesktop(true, "Upload", context, []),
      resizeToAvoidBottomInset: true,
      body: !_presetSelected
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Pick an Initiative reset",
                      style: Theme.of(context).textTheme.headline3),
                  Container(
                    height: 150,
                    width: 80.w,
                    color: globalBGColor,
                    child: MasonryGridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      // scrollDirection: Axis.vertical,
                      itemCount: _initiativePresets.length,
                      crossAxisCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return InitiativePresetCard(
                            currentIndex: index,
                            iconSize: 50,
                            initiative: _initiativePresets[index],
                            // activated: _activatedGenres.contains(index),
                            onTapCallback: () {
                              setState(() {
                                _selectedPreset = _initiativePresets[index];
                                _presetSelected = true;
                              });
                            });
                      },
                      // staggeredTileBuilder: (int index) =>
                      //     new StaggeredTile.fit(2),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ),
                  ),
                  Center(
                    child: Text("or continue with your preset",
                        style: Theme.of(context).textTheme.headline3),
                  ),
                  FutureBuilder(
                      future: _customPresetsLoaded,
                      builder: (context, exploreTagsSnapshot) {
                        if (exploreTagsSnapshot.connectionState ==
                                ConnectionState.none ||
                            exploreTagsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                          return Container();
                        }
                        return Container(
                          height: 30.h,
                          width: 50.w,
                          color: globalBGColor,
                          child: MasonryGridView.count(
                            padding: EdgeInsets.zero,
                            itemCount: _ativeCustomPresets.length,
                            crossAxisCount:
                                _ativeCustomPresets.length > 1 ? 3 : 1,
                            //shrinkWrap: true,
                            // scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return PresetCard(
                                  currentIndex: _ativeCustomPresets[index],
                                  preset: _customPresets[
                                      _ativeCustomPresets[index]],
                                  iconSize: 50,
                                  // activated: _activatedGenres.contains(index),
                                  onTapCallback: () {
                                    setState(() {
                                      _selectedPreset = _customPresets[
                                          _ativeCustomPresets[index]];
                                      _presetSelected = true;
                                    });
                                  });
                            },
                            // staggeredTileBuilder: (int index) =>
                            //     new StaggeredTile.fit(2),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
                        );
                      })
                ],
              ),
            )
          : UploaderMainPage(
              callback: widget.uploaderCallback,
              key: UniqueKey(),
              preset: _presetSelected ? _selectedPreset : _customPresets[0]),
    );
  }
}
