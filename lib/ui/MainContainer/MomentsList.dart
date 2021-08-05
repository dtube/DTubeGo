// TODO: Moments (aka Shorts) not ready yet
import 'package:flutter/material.dart';

class MomentsList extends StatelessWidget {
  const MomentsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 90.0),
      child: Container(
        height: 75,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                    child: Icon(
                  Icons.ac_unit_rounded,
                  size: 50,
                )),
              );
            }),
        // child: Text("test"),
      ),
    );
  }
}
