import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
class TestNumericAxisChart extends StatefulWidget {
  const TestNumericAxisChart({Key? key}) : super(key: key);

  @override
  State<TestNumericAxisChart> createState() => _TestNumericAxisChartState();
}

class _TestNumericAxisChartState extends State<TestNumericAxisChart> {
   List<ChartData> get chartData => [
    ChartData(lang.S.current.sat, 20000, 15000),
    ChartData(lang.S.current.Sun, 10000, 25000),
    ChartData(lang.S.current.mon, 5000, 5000),
    ChartData(lang.S.current.tues, 45000, 35000),
    ChartData(lang.S.current.wed, 25000, 30000),
    ChartData(lang.S.current.thurs, 20000, 10000),
    ChartData(lang.S.current.fri, 25000, 20000),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   setState(() {
      //     chartData.insert(0, "hello world")
      //   });
      // }),
      body: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 50000,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getBottomTitles,
                    reservedSize: 42,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getLeftTitles,
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Color(0xffD1D5DB),
                    dashArray: [5, 5],
                    strokeWidth: 1,
                  );
                },
              ),
              barGroups: _buildBarGroups(),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return chartData.asMap().entries.map((entry) {
      int index = entry.key;
      ChartData data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.y,
            color: Colors.green,
            width: 10,
            borderRadius: BorderRadius.circular(0),
          ),
          BarChartRodData(
            toY: data.y1,
            color: Colors.red,
            width: 10,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: 10,
      );
    }).toList();
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final style = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );

    String text = chartData[value.toInt()].x;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(text, style: style),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);

  final String x;
  final double y;
  final double y1;
}

