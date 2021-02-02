import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_core/firebase_core.dart';
import 'main_model.dart';



class SimpleDatumLegend extends StatelessWidget {

  MainModel model;
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleDatumLegend(this.seriesList,{this.animate});

  factory SimpleDatumLegend.withSampleData(MainModel model) {

    return new SimpleDatumLegend(

      _createSampleData(model),
      animate: true,
    );

  }


  @override
  Widget build(BuildContext context) {

    return new charts.PieChart(
      seriesList,
      animate: animate,

      behaviors: [new charts.DatumLegend()],
    );
  }

  /// Create series list with one series
  static List<charts.Series<LinearSales, int>> _createSampleData(MainModel model) {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
