import 'package:bob/models/model.dart';
import 'package:bob/screens/HomePage/Statistic/baby_avg_tallStatistics.dart';
import 'package:bob/screens/HomePage/Statistic/baby_avg_weightStatistics.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BabyGrowthStatistics extends StatefulWidget {
  final Baby baby;
  final List<GrowthRecord> growthRecords;
  const BabyGrowthStatistics(this.baby, this.growthRecords, {Key? key}) : super(key: key);

  @override
  State<BabyGrowthStatistics> createState() => _BabyGrowthStatisticsState();
}

class _BabyGrowthStatisticsState extends State<BabyGrowthStatistics> with TickerProviderStateMixin {
  List<Color> gradientColors = [
    Color(0xffffdbd9),
    Color(0xffef759d)
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
    //print(widget.baby.relationInfo.BabyId);
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
      appBar: AppBar(
        backgroundColor: const Color(0xffffc8c7),
        elevation: 0.0,
        iconTheme : const IconThemeData(color: Colors.black),
        title: const Text('graph_growth'.tr, style: TextStyle(color: Colors.black,fontSize: 20, fontFamily: 'NanumSquareRound')),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TabBar(
              tabs: [
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: const Text('height'.tr, style: TextStyle(fontFamily: 'NanumSquareRound'))
                ),
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: const Text('weight'.tr, style: TextStyle(fontFamily: 'NanumSquareRound'))
                )
              ],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'),
              labelColor: const Color(0xffff846d),
              indicatorColor: const Color(0xffff846d),
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
    const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'NanumSquareRound'
    );
    Widget text;
    switch (value.toInt()) {
      case 1 :
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('hi', style: style);
        break;
    }
    for(int i=0; i<heightPoints.length; i++) {
      if (value.toInt() == DateFormat('yyyy-MM-dd').parse(dateList[i]).millisecondsSinceEpoch.toInt()) {
        text = Text(DateFormat('MM-dd').format(DateFormat('yyyy-MM-dd').parse(dateList[i])), style: style);
        break;
      }
      // else if(value.toInt() != DateFormat('yyyy-MM-dd').parse(dateList[i]).millisecondsSinceEpoch.toInt()) {
      //   text = Text(DateFormat('MM-dd').format(DateFormat('yyyy-MM-dd').parse(dateList[i])), style: style);
      //   break;
      // }
      else {
        text = const Text('', style: style,);
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
          Text('${widget.baby.name}${'\s growth record'.tr}', style: TextStyle(fontSize: 30, color: Colors.grey[700], fontFamily: 'NanumSquareRound'),),
          const SizedBox(height: 20),
          FutureBuilder(
            future: getGrowthFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData == false){
                return Container(
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
                  child: Text(
                    'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                    style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound'),
                  ),
                );
              }else{
                return Container(
                  height: 600,
                  child: LineChart(
                      LineChartData(
                        minX: minD,
                        maxX: maxD,
                        minY: heightList.reduce((value, element) => value < element? value: element)-0.2,
                        maxY: heightList.reduce((value, element) => value > element? value: element)+0.1,
                        titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                            return FlLine(
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
                            dotData:  FlDotData(
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
                  label: const Column(
                    children: [
                      Text("standard_growth".tr, style: TextStyle(color: Color(0xff512F22), fontSize: 12, fontFamily: 'NanumSquareRound')),
                      Text("check_diagram".tr, style: TextStyle(color: Color(0xff512F22), fontSize: 12, fontFamily: 'NanumSquareRound'))
                    ],
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (context){
                      return BabyAvgTallStatistics();
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
      child: Container(
        child: Column(
          children: [
            Text('"${widget.baby.name}"${'\'s weight record'.tr}', style: TextStyle(fontSize: 30, color: Colors.grey[700], fontFamily: 'NanumSquareRound')),
            const SizedBox(height: 20),
            FutureBuilder(
              future: getGrowthFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData == false){
                  return Container(
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
                    child: Text(
                      'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                      style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound'),
                    ),
                  );
                }else{
                  return Container(
                    height: 600,
                    child: LineChart(
                        LineChartData(
                          minX: minD,
                          maxX: maxD,
                          minY: weightList.reduce((value, element) => value < element? value: element)-0.2,
                          maxY: weightList.reduce((value, element) => value > element? value: element)+0.1,
                          titlesData: FlTitlesData(
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

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
                              return FlLine(
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
                              dotData:  FlDotData(
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
                    label: const Column(
                      children: [
                        Text("standard_growth".tr, style: TextStyle(color: Color(0xff512F22), fontSize: 12, fontFamily: 'NanumSquareRound')),
                        Text("check_diagram".tr, style: TextStyle(color: Color(0xff512F22), fontSize: 12, fontFamily: 'NanumSquareRound'))
                      ],
                    ),
                    onPressed: () {
                      showDialog(context: context, builder: (context){
                        return BabyAvgWeightStatistics();
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
