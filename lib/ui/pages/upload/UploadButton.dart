import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UploaderButton extends StatefulWidget {
  const UploaderButton({
    Key? key,
  }) : super(key: key);

  @override
  State<UploaderButton> createState() => _UploaderButtonState();
}

class _UploaderButtonState extends State<UploaderButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionPreprocessingState) {
          if (state.txType == 13 || state.txType == 4) {
            return DTubeLogoPulse(size: 40.0);
          }
        } else if (state is TransactionSent && state.isParentContent) {
          return CircleAvatar(
            backgroundColor: Colors.green,
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<TransactionBloc>(context).add(SetInitState());
                if (state.authorPerm != null) {
                  navigateToPostDetailPage(
                      context,
                      state.authorPerm!
                          .substring(0, state.authorPerm!.indexOf('/')),
                      state.authorPerm!
                          .substring(state.authorPerm!.indexOf('/') + 1),
                      "none");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UploaderMainPage();
                      },
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: new FaIcon(
                  FontAwesomeIcons.play,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
        return CircleAvatar(
          backgroundColor: globalRed,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UploaderMainPage();
                  },
                ),
              );
            },
            child: new FaIcon(
              FontAwesomeIcons.cloudUploadAlt,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
