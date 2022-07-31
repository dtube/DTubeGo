import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PiChart extends StatefulWidget {
  const PiChart(
      {Key? key, required this.goalValue, required this.receivedValue})
      : super(key: key);
  final int goalValue;
  final int receivedValue;

  @override
  State<PiChart> createState() => _DaoStateChartState();
}

class _DaoStateChartState extends State<PiChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      width: 20.w,
      child: PieChart(
        PieChartData(
            startDegreeOffset: 270,
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: generateSections(widget.receivedValue, widget.goalValue)),
      ),
    );
  }

  List<PieChartSectionData> generateSections(int received, int goal) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      // final radius = isTouched ? 40.0 : 30.0;
      final radius = 30.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.greenAccent[700],
            value: received.toDouble(),
            title: '',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.grey[800],
            value: (goal - received).toDouble(),
            title: '',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }
}
