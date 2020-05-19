import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AttendanceGraph extends StatefulWidget {
  AttendanceGraph(
      {@required this.size,
      @required this.total,
      @required this.taken,
      @required this.type});
  Size size;
  String type;
  int total;
  int taken;
  AttendanceGraphState createState() => AttendanceGraphState();
}

class AttendanceGraphState extends State<AttendanceGraph> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  Color getColorForValue(double value) {
    value = 100 - value;
    print(value);
    Color dialColor;
    if (value > 90) {
      dialColor = Colors.red[900];
    } else if (value > 75) {
      dialColor = Colors.red[700];
    } else if (value > 50) {
      dialColor = Colors.red[400];
    } else if (value > 40) {
      dialColor = Colors.red[200];
    } else if (value > 30) {
      dialColor = Colors.deepOrange;
    } else if (value > 20) {
      dialColor = Colors.deepOrange[200];
    } else if (value > 10) {
      dialColor = Colors.yellow;
    } else {
      dialColor = Colors.greenAccent[700];
    }
    return dialColor;
  }

  List<CircularStackEntry> _generateChartData(double value) {
    Color dialColor = getColorForValue(value);
    List<CircularStackEntry> data = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            value,
            dialColor,
            rankKey: 'percentage',
          )
        ],
        rankKey: 'percentage',
      ),
    ];
    return data;
  }

  Widget _buildResults(double percent) {
    return Center(
      child: Stack(
        children: <Widget>[
          AnimatedCircularChart(
            key: _chartKey,
            initialChartData: _generateChartData(percent),
            chartType: CircularChartType.Radial,
            edgeStyle: SegmentEdgeStyle.round,
            percentageValues: true,
            labelStyle: TextStyle(
                color: getColorForValue(percent),
                fontSize: widget.size.width / 10),
            size: widget.size,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: widget.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildResults(100 - 100 * (widget.taken / widget.total)),
              ],
            ),
          ),
          Container(
            width: widget.size.width,
            height: widget.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.type == "All")
                  Icon(FontAwesomeIcons.globeEurope, size: widget.size.width-45)
                else if (widget.type == "Elderly")
                  Icon(FontAwesomeIcons.crutch, size: widget.size.width-45)
                else if (widget.type == "Frontline")
                  Icon(FontAwesomeIcons.fireExtinguisher, size: widget.size.width-45)
                else
                  Icon(FontAwesomeIcons.globeEurope, size: widget.size.width-45)
              ],
            ),
          )
        ],
      ),
    );
  }
}
