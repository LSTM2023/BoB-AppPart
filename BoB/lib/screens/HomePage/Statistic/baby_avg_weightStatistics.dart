import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class BabyAvgWeightStatistics extends StatefulWidget {
  const BabyAvgWeightStatistics({Key? key}) : super(key: key);

  @override
  State<BabyAvgWeightStatistics> createState() => _BabyAvgWeightStatisticsState();
}

class _BabyAvgWeightStatisticsState extends State<BabyAvgWeightStatistics> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        contentPadding: const EdgeInsets.only(top: 15,right: 10),
        backgroundColor: const Color(0xffF9F8F8),
        //default 패딩값을 없앨 수 있다.
        content: SizedBox(
          width: 400,
          height: 650,
          child: Column(
            children: [
              label('Infant 0~72 months weight percentile'.tr, 'bold', 16, 'base100'),
              const SizedBox(height: 20),
              SizedBox(
                height: 550,
                width: 330,
                child: LineChart(
                    Data1
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        label('male'.tr, 'bold', 16, 'blue'),
                        const SizedBox(height: 5),
                        label('female'.tr, 'bold', 16, 'red'),
                      ],
                    ),
                  ],
                ),
              )
            ],
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
  minY: 2,
  maxY: 22,
);

List<LineChartBarData> get lineBarsData =>[
  maleTallData,
  femaleTallData
];

FlTitlesData get titlesData => FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: bottomTitles,
  ),
  rightTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  topTitles: const AxisTitles(
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
    case 0:
      text = '0';
      break;
    case 1:
      text = '1';
      break;
    case 2:
      text = '2';
      break;
    case 3:
      text = '3';
      break;
    case 4:
      text = '4';
      break;
    case 5:
      text = '5';
      break;
    case 6:
      text = '6';
      break;
    case 7:
      text = '7';
      break;
    case 8:
      text = '8';
      break;
    case 9:
      text = '9';
      break;
    case 10:
      text = '10';
      break;
    case 11:
      text = '11';
      break;
    case 12:
      text = '12';
      break;
    case 13:
      text = '13';
      break;
    case 14:
      text = '14';
      break;
    case 15:
      text = '15';
      break;
    case 16:
      text = '16';
      break;
    case 17:
      text = '17';
      break;
    case 18:
      text = '18';
      break;
    case 19:
      text = '19';
      break;
    case 20:
      text = '20';
      break;
    case 21:
      text = '21';
      break;
    case 22:
      text = '22';
      break;
    default:
      return Container();
  }
  return Text(text, style: style, textAlign: TextAlign.center,);
}

SideTitles leftTitles() => const SideTitles(
    getTitlesWidget: leftTitlesWidget,
    showTitles: true,
    interval: 1,
    reservedSize: 40
);

Widget bottomTitlesWidget(double value, TitleMeta meta){
  Widget text;
  switch (value.toInt()){
    case 0:
      text = label('0', 'bold', 12, 'Grey');
      break;
    case 5:
      text = label('5', 'bold', 12, 'Grey');
      break;
    case 10:
      text = label('10', 'bold', 12, 'Grey');
      break;
    case 15:
      text = label('15', 'bold', 12, 'Grey');
      break;
    case 20:
      text = label('20', 'bold', 12, 'Grey');
      break;
    case 25:
      text = label('25', 'bold', 12, 'Grey');
      break;
    case 30:
      text = label('30', 'bold', 12, 'Grey');
      break;
    case 35:
      text = label('35', 'bold', 12, 'Grey');
      break;
    case 40:
      text = label('40', 'bold', 12, 'Grey');
      break;
    case 45:
      text = label('45', 'bold', 12, 'Grey');
      break;
    case 50:
      text = label('50', 'bold', 12, 'Grey');
      break;
    case 55:
      text = label('55', 'bold', 12, 'Grey');
      break;
    case 60:
      text = label('60', 'bold', 12, 'Grey');
      break;
    case 65:
      text = label('65', 'bold', 12, 'Grey');
      break;
    case 70:
      text = label('70', 'bold', 12, 'Grey');
      break;
    default:
      text = label('', 'bold', 12, 'Grey');
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: text,
  );
}

SideTitles get bottomTitles => const SideTitles(
  showTitles: true,
  reservedSize: 40,
  interval: 1,
  getTitlesWidget: bottomTitlesWidget,
);

FlGridData get gridData => const FlGridData(show: true);

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
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(0, 3.3464), FlSpot(1, 4.4709), FlSpot(2, 5.5675), FlSpot(3, 6.3762), FlSpot(4, 7.0023), FlSpot(5, 7.5105), FlSpot(6, 7.934), FlSpot(7, 8.297), FlSpot(8, 8.6151), FlSpot(9, 8.9014),
      FlSpot(10, 9.1649), FlSpot(11, 9.4122), FlSpot(12, 9.6479), FlSpot(13, 9.8749), FlSpot(14, 10.0953), FlSpot(15, 10.3108), FlSpot(16,10.5228), FlSpot(17, 10.7319), FlSpot(18, 10.9385), FlSpot(19, 11.143),
      FlSpot(20, 11.3462), FlSpot(21, 11.5486), FlSpot(22, 11.7504), FlSpot(23, 11.9514), FlSpot(24, 12.1515), FlSpot(25, 12.3502), FlSpot(26, 12.5466), FlSpot(27, 12.7401), FlSpot(28, 12.9303), FlSpot(29, 13.1169),
      FlSpot(30, 13.3), FlSpot(31, 13.4798), FlSpot(32, 13.6567), FlSpot(33, 13.8309), FlSpot(34, 14.0031), FlSpot(35, 14.1736), FlSpot(36, 14.7381), FlSpot(37, 14.911), FlSpot(38, 15.0839), FlSpot(39, 15.2569),
      FlSpot(40, 15.4299), FlSpot(41, 15.603), FlSpot(42, 15.7775), FlSpot(43, 15.9521), FlSpot(44, 16.1268), FlSpot(45, 16.3015), FlSpot(46, 16.4763), FlSpot(47, 16.6512), FlSpot(48, 16.8276), FlSpot(49, 17.0041),
      FlSpot(50, 17.1807), FlSpot(51, 17.3573), FlSpot(52, 17.534), FlSpot(53, 17.7108), FlSpot(54, 17.8888), FlSpot(55, 18.067), FlSpot(56, 18.2452), FlSpot(57, 18.4235), FlSpot(58, 18.6018), FlSpot(59, 18.7802),
      FlSpot(60, 18.9625), FlSpot(61, 19.1449), FlSpot(62, 19.3274), FlSpot(63, 19.51), FlSpot(64, 19.6926), FlSpot(65, 19.8753), FlSpot(66, 20.0814), FlSpot(67, 20.2877), FlSpot(68, 20.4941), FlSpot(69, 20.7007),
      FlSpot(70, 20.9073), FlSpot(71, 21.1141),

    ]
);

LineChartBarData get femaleTallData => LineChartBarData(
    isCurved: true,
    color: Colors.red,
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(0, 3.2322), FlSpot(1, 4.1873), FlSpot(2, 5.1282), FlSpot(3, 5.8458), FlSpot(4, 6.4237), FlSpot(5, 6.8985), FlSpot(6, 7.297), FlSpot(7, 7.6422), FlSpot(8, 7.9487), FlSpot(9, 8.2254),
      FlSpot(10, 8.48), FlSpot(11, 8.7192), FlSpot(12, 8.9481), FlSpot(13, 9.1699), FlSpot(14, 9.387), FlSpot(15, 9.6008), FlSpot(16, 9.8124), FlSpot(17, 10.0226), FlSpot(18, 10.2315), FlSpot(19, 10.4393),
      FlSpot(20, 10.6464), FlSpot(21, 10.8534), FlSpot(22, 11.0608), FlSpot(23, 11.2688), FlSpot(24, 11.4775), FlSpot(25, 11.6864), FlSpot(26, 11.8947), FlSpot(27, 12.1015), FlSpot(28, 12.3059), FlSpot(29, 12.5073),
      FlSpot(30, 12.7055), FlSpot(31, 12.9006), FlSpot(32, 13.093), FlSpot(33, 13.2837), FlSpot(34, 13.4731), FlSpot(35, 13.6618), FlSpot(36, 14.1998), FlSpot(37, 14.3701), FlSpot(38, 14.5405), FlSpot(39, 14.7108),
      FlSpot(40, 14.8813), FlSpot(41, 15.0518), FlSpot(42, 15.2236), FlSpot(43, 15.3956), FlSpot(44, 15.5676), FlSpot(45, 15.7399), FlSpot(46, 15.9123), FlSpot(47, 16.0848), FlSpot(48, 16.2585), FlSpot(49, 16.4324),
      FlSpot(50, 16.6064), FlSpot(51, 16.7806), FlSpot(52, 16.9549), FlSpot(53, 17.1294), FlSpot(54, 17.3046), FlSpot(55, 17.48), FlSpot(56, 17.6555), FlSpot(57, 17.8311), FlSpot(58, 18.0069), FlSpot(59, 18.1827),
      FlSpot(60, 18.3616), FlSpot(61, 18.5405), FlSpot(62, 18.7196), FlSpot(63, 18.8988), FlSpot(64, 19.078), FlSpot(65, 19.2574), FlSpot(66, 19.4555), FlSpot(67, 19.6537), FlSpot(68, 19.8519), FlSpot(69, 20.0502),
      FlSpot(70, 20.2485), FlSpot(71, 20.4468),

    ]
);