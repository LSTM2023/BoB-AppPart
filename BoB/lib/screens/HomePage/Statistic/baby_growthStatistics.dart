import 'package:bob/models/model.dart';
import 'package:bob/screens/HomePage/Statistic/baby_avg_tallStatistics.dart';
import 'package:bob/screens/HomePage/Statistic/baby_avg_weightStatistics.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:get/get.dart';

class BabyGrowthStatistics extends StatefulWidget {
  final Baby baby;
  final List<GrowthRecord> growthRecords;
  const BabyGrowthStatistics(this.baby, this.growthRecords, {Key? key}) : super(key: key);

  @override
  State<BabyGrowthStatistics> createState() => _BabyGrowthStatisticsState();
}

class _BabyGrowthStatisticsState extends State<BabyGrowthStatistics> with TickerProviderStateMixin {
  List<Color> gradientColors = [
    const Color(0xffffdbd9),
    const Color(0xffef759d)
  ];
  List<Color> gradientColors2 = [
    Colors.grey,
    Colors.lightBlueAccent
  ];
  late TabController _tabController;
  late Future getGrowthFuture;
  bool showAvg = false;

  List<FlSpot> heightPoints = [];
  List<FlSpot> weightPoints = [];
  List heightList = [];
  List weightList = [];
  List dateList = [];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(
        length: 2,
        vsync: this,
    );
    super.initState();
    getGrowthFuture = getMyGrowthInfo();
  }
  double maxD = DateTime.now().millisecondsSinceEpoch.toDouble();
  double minD = DateTime.now().millisecondsSinceEpoch.toDouble();

  Future getMyGrowthInfo() async{
    List<dynamic> growthRecordList = await growthGetService(widget.baby.relationInfo.BabyId);
    print(growthRecordList);
    for(int i=0; i<growthRecordList.length; i++) {
      double timestamp = (DateTime.parse(growthRecordList[i]['date'])).millisecondsSinceEpoch.toDouble();
      if (timestamp < minD){
        minD = timestamp;
      }
      if (timestamp > minD){
        maxD = timestamp;
      }
      if(timestamp > maxD){
        maxD = timestamp;
      }
      heightPoints.add(FlSpot(timestamp, growthRecordList[i]['height'].toDouble()));
      weightPoints.add(FlSpot(timestamp, growthRecordList[i]['weight'].toDouble()));
      heightList.add(growthRecordList[i]['height']);
      weightList.add(growthRecordList[i]['weight']);
      dateList.add(growthRecordList[i]['date']);
    }
    print(heightPoints.toString());
    print(weightPoints.toString());
    print(dateList);
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: homeAppbar('성장 통계'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TabBar(
              tabs: [
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: label('height'.tr, 'bold', 15, 'base80')
                ),
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: label('weight'.tr, 'bold', 15, 'base80')
                )
              ],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'),
              labelColor: const Color(0xffFB8665),
              indicatorColor: const Color(0xffFB8665),
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                tallChart(),
                weightChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        fontFamily: 'NanumSquareRound'
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 1 :
        text = label('MAR', 'bold', 15, 'black');
        break;
      case 5:
        text = label('JUN', 'bold', 15, 'black');
        break;
      case 8:
        text = label('SEP', 'bold', 15, 'black');
        break;
      default:
        text = label('hi', 'bold', 15, 'black');
        break;
    }
    for(int i=0; i<heightPoints.length; i++) {
      if (value.toInt() == DateFormat('yyyy-MM-dd').parse(dateList[i]).millisecondsSinceEpoch.toInt()) {
        text = label(DateFormat('MM-dd').format(DateFormat('yyyy-MM-dd').parse(dateList[i])), 'bold', 15, 'black');
        break;
      }
      // else if(value.toInt() != DateFormat('yyyy-MM-dd').parse(dateList[i]).millisecondsSinceEpoch.toInt()) {
      //   text = label(DateFormat('MM-dd').format(DateFormat('yyyy-MM-dd').parse(dateList[i])), 'bold', 15, 'black');
      //   break;
      // }
      else {
        text = label('', 'bold', 15, 'black');
      }
    }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );

  }

  Widget tallChart(){
    return SingleChildScrollView(
      child: Column(
        children: [
          label('"${widget.baby.name}"${'\'s growth record'.tr}', 'bold', 25, 'base100'),
          const SizedBox(height: 20),
          FutureBuilder(
            future: getGrowthFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData == false){
                return SizedBox(
                    width: double.infinity,
                    child : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/baby0.png', width: 150),
                        const SizedBox(height: 50),
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.black,
                          ),
                        ),
                      ],
                    )
                );
              }
              else if(snapshot.hasError){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: label('Error: ${snapshot.error}', 'bold', 15, 'black'),
                );
              }else{
                return SizedBox(
                  height: 555,
                  child: LineChart(
                      LineChartData(
                        minX: minD,
                        maxX: maxD,
                        minY: heightList.reduce((value, element) => value < element? value: element)-0.2,
                        maxY: heightList.reduce((value, element) => value > element? value: element)+0.1,
                        titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitleWidgets,
                                  reservedSize: 35,
                                )
                            )
                        ),
                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                                color: Colors.grey,
                                strokeWidth: 1
                            );
                          },
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: heightPoints,
                            isCurved: false,
                            gradient: const LinearGradient(
                              colors: [Colors.red, Colors.redAccent],
                            ),
                            barWidth: 5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(
                              show: true,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: gradientColors
                                    .map((color) => color.withOpacity(0.3))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }
              },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xfff9f8f8),
                  label: Column(
                    children: [
                      label("standard_growth".tr, 'normal', 13, 'base100'),
                      label("check_diagram".tr, 'normal', 13, 'base100')
                    ],
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (context){
                      return const BabyAvgTallStatistics();
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget weightChart(){
    return SingleChildScrollView(
      child: Column(
        children: [
          label('"${widget.baby.name}"${'\'s weight record'.tr}', 'bold', 25, 'base100'),
          const SizedBox(height: 20),
          FutureBuilder(
            future: getGrowthFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData == false){
                return SizedBox(
                    width: double.infinity,
                    child : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/baby0.png', width: 150),
                        const SizedBox(height: 50),
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      ],
                    )
                );
              }
              else if(snapshot.hasError){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: label('Error: ${snapshot.error}', 'bold', 15, 'black'),
                );
              }else{
                return SizedBox(
                  height: 555,
                  child: LineChart(
                      LineChartData(
                        minX: minD,
                        maxX: maxD,
                        minY: weightList.reduce((value, element) => value < element? value: element)-0.2,
                        maxY: weightList.reduce((value, element) => value > element? value: element)+0.1,
                        titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitleWidgets,
                                  reservedSize: 35,
                                )
                            )
                        ),
                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                                color: Colors.grey,
                                strokeWidth: 1
                            );
                          },
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: weightPoints,
                            isCurved: false,
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.blueAccent],
                            ),
                            barWidth: 5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(
                              show: true,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: gradientColors2
                                    .map((color) => color.withOpacity(0.3))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xfff9f8f8),
                  label: Column(
                    children: [
                      label("standard_growth".tr, 'normal', 13, 'base100'),
                      label("check_diagram".tr, 'normal', 13, 'base100')
                    ],
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (context){
                      return const BabyAvgWeightStatistics();
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
