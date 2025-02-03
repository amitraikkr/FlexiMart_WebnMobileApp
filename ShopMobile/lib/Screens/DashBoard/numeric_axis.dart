import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';
import 'chart_data.dart';
import 'package:mobile_pos/model/dashboard_overview_model.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardChart extends StatefulWidget {
  const DashboardChart({Key? key, required this.model}) : super(key: key);

  final DashboardOverviewModel model;

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    getData(widget.model);
  }

  void getData(DashboardOverviewModel model) {
    chartData = [];
    for (int i = 0; i < model.data!.sales!.length; i++) {
      chartData.add(ChartData(
        model.data!.sales![i].date!,
        model.data!.sales![i].amount!.toDouble(),
        model.data!.purchases![i].amount!.toDouble(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: chartData.asMap().entries.map((entry) {
                    int index = entry.key;
                    double y = entry.value.y;
                    return FlSpot(index.toDouble(), y);
                  }).toList(),
                  isCurved: true,
                  color: kMainColor,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: chartData.asMap().entries.map((entry) {
                    int index = entry.key;
                    double y1 = entry.value.y1;
                    return FlSpot(index.toDouble(), y1);
                  }).toList(),
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getBottomTitles,
                    reservedSize: 32,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}k',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Color(0xffD1D5DB),
                    dashArray: [4, 4],
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              minY: 0,
              maxY: _getMaxY(),
            ),
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    double maxY = 0;
    for (var data in chartData) {
      maxY = maxY > data.y ? maxY : data.y;
      maxY = maxY > data.y1 ? maxY : data.y1;
    }
    return maxY + 10;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff4D4D4D),
      fontSize: 12,
    );

    String text = chartData[value.toInt()].x;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(text, style: style),
    );
  }
}
