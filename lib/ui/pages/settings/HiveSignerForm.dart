import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HiveSignerForm extends StatefulWidget {
  HiveSignerForm({Key? key, required this.username, this.validCallback})
      : super(key: key);

  String username;
  VoidCallback? validCallback;

  @override
  _HiveSignerFormState createState() => _HiveSignerFormState();
}

class _HiveSignerFormState extends State<HiveSignerForm> {
  String _status = 'notset'; // notset, invalid, valid
  late TextEditingController _usernameController;
  bool _usernameFilled = false;

  @override
  void initState() {
    _usernameController = new TextEditingController(text: widget.username);
    if (widget.username != null && widget.username.length > 3) {
      _usernameFilled = true;
    }
    super.initState();
  }

  void getHiveSignerUsername() async {
    _usernameController.text = await sec.getHiveSignerUsername();
    if (_usernameController.text.length > 3) {
      _usernameFilled = true;
    }
  }

  void checkIfFormIsFilled() {
    if (_usernameController.text.length > 3) {
      setState(() {
        _usernameFilled = true;
      });
    } else {
      setState(() {
        _usernameFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          maxLines: 1,
          decoration: new InputDecoration(labelText: "hive username:"),
          controller: _usernameController,
          style: Theme.of(context).textTheme.bodyText1,
          onChanged: (val) {
            checkIfFormIsFilled();
          },
          validator: (value) {
            if (value!.isNotEmpty && value.length > 3) {
              return null;
            } else {
              return 'please fill in a valid username';
            }
          },
        ),
        InputChip(
          isEnabled: _usernameController.text.length > 3,
          elevation: 2,
          backgroundColor: _status == "valid" ? Colors.green : globalRed,
          avatar: FaIcon(
            _status == "valid"
                ? FontAwesomeIcons.hive
                : _status == "invalid"
                    ? FontAwesomeIcons.undo
                    : FontAwesomeIcons.hive,
            size: 15,
          ),
          label: Text(
            "hivesigner",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {
            BlocProvider.of<HivesignerBloc>(context).add(CheckAccessToken(
                hiveSignerUsername: _usernameController.value.text));
          },
        ),
        BlocBuilder<HivesignerBloc, HivesignerState>(builder: (context, state) {
          if (state is HiveSignerAccessTokenValidState) {
            if (widget.validCallback != null) {
              widget.validCallback!();
            }
            return _usernameFilled
                ? Column(
                    children: [
                      Text("hivesigner authorization is valid"),
                      InputChip(
                        label: Text("remove"),
                        avatar: FaIcon(
                          FontAwesomeIcons.removeFormat,
                          size: 15,
                        ),
                        elevation: 2,
                        backgroundColor: globalRed,
                        onPressed: () async {
                          await sec.deleteHiveSignerSettings();
                          setState(() {
                            _usernameController.text = "";
                            _usernameFilled = false;
                          });
                        },
                      )
                    ],
                  )
                : SizedBox(height: 0);
          } else {
            return Text("click to renew hivesigner authorization");
          }
        }),
      ],
    );
  }
}
