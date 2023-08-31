import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class BabyAvgGrowthStatistics extends StatefulWidget {
  const BabyAvgGrowthStatistics({Key? key}) : super(key: key);

  @override
  State<BabyAvgGrowthStatistics> createState() => _BabyAvgGrowthStatisticsState();
}

class _BabyAvgGrowthStatisticsState extends State<BabyAvgGrowthStatistics> {






  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        contentPadding: EdgeInsets.only(top: 15,right: 5),
        backgroundColor: const Color(0xffF9F8F8),
        //default 패딩값을 없앨 수 있다.
        content: Container(
          child: SizedBox(
            width: 400,
            height: 650,
            child: Column(
              children: [
                Text('유아 0~72개월 신장 백분위 수', style: TextStyle(fontSize: 17, color: Color(0xff512F22), fontFamily: 'NanumSquareRound')),
                const SizedBox(height: 20),
                Container(
                  height: 550,
                  width: 330,
                  child: LineChart(
                    Data1
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

LineChartData get Data1 => LineChartData(
  gridData: gridData,
  titlesData: titlesData,
  borderData: borderData,
  lineBarsData: lineBarsData,
  minX: 0,
  maxX: 72,
  minY: 45,
  maxY: 120,
);

List<LineChartBarData> get lineBarsData =>[
  maleTallData,
  femaleTallData
];

FlTitlesData get titlesData => FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: bottomTitles,
  ),
  rightTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  topTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  leftTitles: AxisTitles(
    sideTitles: leftTitles(),
  ),
);

Widget leftTitlesWidget(double value, TitleMeta meta){
  const style = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'NanumSquareRound'
  );
  String text;
  switch (value.toInt()) {
    case 40:
      text = '40';
      break;
    case 50:
      text = '50';
      break;
    case 60:
      text = '60';
      break;
    case 70:
      text = '70';
      break;
    case 80:
      text = '80';
      break;
    case 90:
      text = '90';
      break;
    case 100:
      text = '100';
      break;
    case 110:
      text = '110';
      break;
    case 120:
      text = '120';
      break;
    default:
      return Container();
  }
  return Text(text, style: style, textAlign: TextAlign.center,);
}

SideTitles leftTitles() => SideTitles(
  getTitlesWidget: leftTitlesWidget,
  showTitles: true,
  interval: 1,
  reservedSize: 40
);

Widget bottomTitlesWidget(double value, TitleMeta meta){
  const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
      fontFamily: 'NanumSquareRound'
  );
  Widget text;
  switch (value.toInt()){
    case 0:
      text = const Text('0', style: style);
      break;
    case 5:
      text = const Text('5', style: style);
      break;
    case 10:
      text = const Text('10', style: style);
      break;
    case 15:
      text = const Text('15', style: style);
      break;
    case 20:
      text = const Text('20', style: style);
      break;
    case 25:
      text = const Text('25', style: style);
      break;
    case 30:
      text = const Text('30', style: style);
      break;
    case 35:
      text = const Text('35', style: style);
      break;
    case 40:
      text = const Text('40', style: style);
      break;
    case 45:
      text = const Text('45', style: style);
      break;
    case 50:
      text = const Text('50', style: style);
      break;
    case 55:
      text = const Text('55', style: style);
      break;
    case 60:
      text = const Text('60', style: style);
      break;
    case 65:
      text = const Text('65', style: style);
      break;
    case 70:
      text = const Text('70', style: style);
      break;
    default:
      text = const Text('');
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: text,
  );
}

SideTitles get bottomTitles => SideTitles(
  showTitles: true,
  reservedSize: 40,
  interval: 1,
  getTitlesWidget: bottomTitlesWidget,
);

FlGridData get gridData => FlGridData(show: true);

FlBorderData get borderData => FlBorderData(
  show: true,
  border: const Border(
    bottom: BorderSide(color: Colors.grey, width: 2),
    left: BorderSide(color: Colors.grey),
    right: BorderSide(color: Colors.grey),
    top: BorderSide(color: Colors.grey),
  )
);

LineChartBarData get maleTallData => LineChartBarData(
  isCurved: true,
  color: Colors.blue,
  barWidth: 2,
  isStrokeCapRound: true,
  dotData: FlDotData(show: false),
  belowBarData: BarAreaData(show: false),
  spots: const [
    FlSpot(0, 49.8842), FlSpot(1, 54.7244), FlSpot(2, 58.4249), FlSpot(3, 61.4292), FlSpot(4, 63.886), FlSpot(5, 65.9026), FlSpot(6, 67.6236), FlSpot(7, 69.1645), FlSpot(8, 70.5994), FlSpot(9, 71.9687),
    FlSpot(10, 73.2812), FlSpot(11, 74.5388), FlSpot(12, 75.7488), FlSpot(13, 76.9186), FlSpot(14, 78.0497), FlSpot(15, 79.1458), FlSpot(16, 80.2113), FlSpot(17, 81.2487), FlSpot(18, 82.2587), FlSpot(19, 83.2418),
    FlSpot(20, 84.1996), FlSpot(21, 85.1348), FlSpot(22, 86.0477), FlSpot(23, 86.941), FlSpot(24, 87.1161), FlSpot(25, 87.972), FlSpot(26, 88.8065), FlSpot(27, 89.6197), FlSpot(28, 90.412), FlSpot(29, 91.1828),
    FlSpot(30, 91.9327), FlSpot(31, 92.6631), FlSpot(32, 93.3753), FlSpot(33, 94.0711), FlSpot(34, 94.7532), FlSpot(35, 95.4236), FlSpot(36, 96.4961), FlSpot(37, 97.0464), FlSpot(38, 97.5965), FlSpot(39, 98.1463),
    FlSpot(40, 98.6959), FlSpot(41, 99.2452), FlSpot(42, 99.793), FlSpot(43, 100.3406), FlSpot(44, 100.8881), FlSpot(45, 101.4353), FlSpot(46, 101.9824), FlSpot(47, 102.5294), FlSpot(48, 103.0749), FlSpot(49, 103.6204),
    FlSpot(50, 104.1657), FlSpot(51, 104.7109), FlSpot(52, 105.256), FlSpot(53, 105.8009), FlSpot(54, 106.344), FlSpot(55, 106.8869), FlSpot(56, 107.4298), FlSpot(57, 107.9726), FlSpot(58, 108.5153), FlSpot(59, 109.0579),
    FlSpot(60, 109.5896), FlSpot(61, 110.1212), FlSpot(62, 110.6529), FlSpot(63, 111.1846), FlSpot(64, 111.7162), FlSpot(65, 112.2479), FlSpot(66, 112.7735), FlSpot(67, 113.299), FlSpot(68, 113.8245), FlSpot(69, 114.3501),
    FlSpot(70, 114.8756), FlSpot(71, 115.401),

  ]
);

LineChartBarData get femaleTallData => LineChartBarData(
    isCurved: true,
    color: Colors.red,
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(0, 49.1477), FlSpot(1, 53.6872), FlSpot(2, 57.0673), FlSpot(3, 59.8029), FlSpot(4, 62.0899), FlSpot(5, 64.0301), FlSpot(6, 65.7311), FlSpot(7, 67.2873), FlSpot(8, 68.7498), FlSpot(9, 70.1435),
      FlSpot(10, 71.4818), FlSpot(11, 72.771), FlSpot(12, 74.015), FlSpot(13, 75.2176), FlSpot(14, 76.3817), FlSpot(15, 77.5099), FlSpot(16, 78.6055), FlSpot(17, 79.671), FlSpot(18, 80.7079), FlSpot(19, 81.7182),
      FlSpot(20, 82.7036), FlSpot(21, 83.6654), FlSpot(22, 84.604), FlSpot(23, 85.5202), FlSpot(24, 85.7153), FlSpot(25, 86.5904), FlSpot(26, 87.4462), FlSpot(27, 88.283), FlSpot(28, 89.1004), FlSpot(29, 89.8991),
      FlSpot(30, 90.6797), FlSpot(31, 91.443), FlSpot(32, 92.1906), FlSpot(33, 92.9239), FlSpot(34, 93.6444), FlSpot(35, 94.3533), FlSpot(36, 95.4078), FlSpot(37, 95.9472), FlSpot(38, 96.4867), FlSpot(39, 97.0262),
      FlSpot(40, 97.5658), FlSpot(41, 98.1054), FlSpot(42, 98.6465), FlSpot(43, 99.1877), FlSpot(44, 99.7288), FlSpot(45, 100.27), FlSpot(46, 100.8113), FlSpot(47, 101.3525), FlSpot(48, 101.8943), FlSpot(49, 102.4361),
      FlSpot(50, 102.9779), FlSpot(51, 103.5197), FlSpot(52, 104.0616), FlSpot(53, 104.6034), FlSpot(54, 105.1425), FlSpot(55, 105.6816), FlSpot(56, 106.2208), FlSpot(57, 106.76), FlSpot(58, 107.2992), FlSpot(59, 107.8384),
      FlSpot(60, 108.3714), FlSpot(61, 108.9045), FlSpot(62, 109.4375), FlSpot(63, 109.9706), FlSpot(64, 110.5036), FlSpot(65, 111.0366), FlSpot(66, 111.5656), FlSpot(67, 112.0946), FlSpot(68, 112.6235), FlSpot(69, 113.1523),
      FlSpot(70, 113.6811), FlSpot(71, 114.2098),

    ]
);





