import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

class SalesOverviewCard extends StatefulWidget {
  const SalesOverviewCard({super.key});

  @override
  State<SalesOverviewCard> createState() => _SalesOverviewCardState();
}

class _SalesOverviewCardState extends State<SalesOverviewCard> {
  int selectedPeriod = 0;

  // 7 Days
  final List<FlSpot> sevenDayData =  [
    FlSpot(0, 12000),
    FlSpot(1, 16500),
    FlSpot(2, 19500),
    FlSpot(3, 21100),
    FlSpot(4, 32500),
    FlSpot(5, 27000),
    FlSpot(6, 21000),
    FlSpot(7, 13500),
    FlSpot(8, 11000),
    FlSpot(9, 16000),
    FlSpot(10, 28500),
  ];

  // 30 Days
  final List<FlSpot> thirtyDayData =  [
    FlSpot(0, 15500),
    FlSpot(1, 15000),
    FlSpot(2, 17500),
    FlSpot(3, 20500),
    FlSpot(4, 21000),
    FlSpot(5, 23500),
    FlSpot(6, 18000),
    FlSpot(7, 14500),
    FlSpot(8, 11500),
    FlSpot(9, 8500),
    FlSpot(10, 12000),
    FlSpot(11, 9000),
    FlSpot(12, 10500),
    FlSpot(13, 13500),
    FlSpot(14, 22000),
    FlSpot(15, 21000),
    FlSpot(16, 24000),
    FlSpot(17, 22500),
    FlSpot(18, 26000),
    FlSpot(19, 27000),
    FlSpot(20, 26500),
    FlSpot(21, 28000),
    FlSpot(22, 23500),
    FlSpot(23, 19500),
    FlSpot(24, 15500),
    FlSpot(25, 12000),
    FlSpot(26, 15500),
    FlSpot(27, 10500),
    FlSpot(28, 14000),
    FlSpot(29, 20054),
  ];

  List<FlSpot> get currentData {
    return selectedPeriod == 0 ? sevenDayData : thirtyDayData;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 224,
      width: double.infinity,
      padding:  EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        children: [
          _buildHeader(theme),

           SizedBox(height: 8),

          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sales overview',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),

        _buildPeriodSelector(),
      ],
    );
  }

  // ----------------------------------------------------------
  // 7D / 30D SELECTOR
  // ----------------------------------------------------------

  Widget _buildPeriodSelector() {
    return Container(
      height: 36,
      padding:  EdgeInsets.all(2),
      decoration: BoxDecoration(
        color:  Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          _buildPeriodButton(title: '7D', index: 0),

          _buildPeriodButton(title: '30D', index: 1),
        ],
      ),
    );
  }

  Widget _buildPeriodButton({required String title, required int index}) {
    final bool selected = selectedPeriod == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        if (selectedPeriod == index) return;

        setState(() {
          selectedPeriod = index;
        });
      },

      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,

        height: 32,

        padding:  EdgeInsets.symmetric(horizontal: 13),

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,

          borderRadius: BorderRadius.circular(9),

          border: selected ? Border.all(color:  Color(0xFFE1E5E9)) : null,

          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 3,
                    offset:  Offset(0, 1),
                  ),
                ]
              : null,
        ),

        child: AnimatedDefaultTextStyle(
          duration:  Duration(milliseconds: 200),

          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ?  Color(0xFF087863) :  Color(0xFF8993A3),
          ),

          child: Text(title),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CHART
  // ----------------------------------------------------------

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        minX: 0,

        // Different data lengths are supported.
        maxX: selectedPeriod == 0 ? 10 : 29,

        minY: 0,
        maxY: 40000,

        // ------------------------------------------
        // GRID
        // ------------------------------------------
        gridData:  FlGridData(show: false),

        // ------------------------------------------
        // BORDER
        // ------------------------------------------
        borderData: FlBorderData(show: false),

        // ------------------------------------------
        // AXIS LABELS
        // ------------------------------------------
        titlesData:  FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        // ------------------------------------------
        // TOUCH / MOUSE HOVER
        // ------------------------------------------
        lineTouchData: LineTouchData(
          enabled: true,

          handleBuiltInTouches: true,

          // Vertical line + highlighted dot
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(color:  Color(0xFFD0D4D8), strokeWidth: 1),

                    FlDotData(
                      show: true,

                      getDotPainter:
                          (
                            FlSpot spot,
                            double percent,
                            LineChartBarData barData,
                            int index,
                          ) {
                            return FlDotCirclePainter(
                              radius: 4.5,
                              color:  Color(0xFF087863),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                    ),
                  );
                }).toList();
              },

          // ------------------------------------------
          // TOOLTIP
          // ------------------------------------------
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding:  EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 10,
            ),

            tooltipMargin: 10,

            getTooltipColor: (_) {
              return Colors.white;
            },

            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final int revenue = spot.y.round();

                return LineTooltipItem(
                  'Revenue : ₹${_formatNumber(revenue)}',

                   TextStyle(
                    color: Color(0xFF087863),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),
        ),

        // ------------------------------------------
        // LINE
        // ------------------------------------------
        lineBarsData: [
          LineChartBarData(
            spots: currentData,

            isCurved: true,

            curveSmoothness: 0.35,

            color:  Color(0xFF087863),

            barWidth: 3,

            isStrokeCapRound: true,

            isStrokeJoinRound: true,

            // Hide normal points.
            dotData:  FlDotData(show: false),

            // No fill.
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),

      // ------------------------------------------
      // THIS CREATES THE CHART TRANSITION
      // ------------------------------------------
      duration:  Duration(milliseconds: 700),

      curve: Curves.easeInOutCubic,
    );
  }

  // ----------------------------------------------------------
  // NUMBER FORMAT
  // ----------------------------------------------------------

  String _formatNumber(int number) {
    final String value = number.toString();

    if (value.length <= 3) {
      return value;
    }

    final StringBuffer result = StringBuffer();

    int count = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      result.write(value[i]);

      count++;

      if (count == 3 && i != 0) {
        result.write(',');
        count = 0;
      }
    }

    return result.toString().split('').reversed.join();
  }
}
