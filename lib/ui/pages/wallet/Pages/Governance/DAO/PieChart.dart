import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PiChart extends StatefulWidget {
  const PiChart(
      {Key? key,
      required this.goalValue,
      required this.receivedValue,
      required this.height,
      required this.width,
      required this.centerRadius,
      required this.outerRadius,
      required this.startFromDegree,
      required this.showLabels,
      required this.raisedLabel,
      required this.onTapCallback})
      : super(key: key);
  final int goalValue;
  final int receivedValue;
  final double height;
  final double width;
  final double startFromDegree;
  final double centerRadius;
  final double outerRadius;
  final bool showLabels;
  final String raisedLabel;
  final VoidCallback onTapCallback;
  @override
  State<PiChart> createState() => _DaoStateChartState();
}

class _DaoStateChartState extends State<PiChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
                startDegreeOffset: widget.startFromDegree,
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: generateSections(
                    widget.receivedValue,
                    widget.goalValue,
                    widget.outerRadius,
                    widget.showLabels,
                    widget.raisedLabel)),
          ),
          Center(
            child: InkWell(
              child: Container(
                  width: widget.width * 0.6,
                  height: widget.height * 0.75,
                  color: Colors.transparent),
              onTap: () {
                widget.onTapCallback();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> generateSections(int received, int goal,
      double radius, bool showLabels, String raisedLabel) {
    return List.generate(2, (i) {
      final fontSize = Theme.of(context).textTheme.caption!.fontSize;
      // final radius = isTouched ? 40.0 : 30.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.greenAccent[700],
            value: received.toDouble(),
            title: showLabels ? raisedLabel : '',
            titlePositionPercentageOffset: 0.8,
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
