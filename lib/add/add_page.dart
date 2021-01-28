import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../main_model.dart';


class AddPage extends StatefulWidget {

  MainModel model;
  AddPage(this.model);
  Function(List<String>) onSelectionChanged;


  @override
  _AddPage createState() => _AddPage(model);

}


class _AddPage extends State<AddPage>{

  MainModel model;
  _MultiSelectChipState item;

  _AddPage(this.model);
  String newWorkoutText = "";
  String newWorkoutDigit = "";
  bool isSelected = false;
  List<String> reportList = [
    "自重",
    "ジム"
  ];
  List<String> selectedReportList = List();

 // _MultiSelectChipState selectedChoices;


  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider<MainModel>.value(

      value: model,

      child: Scaffold(
        appBar: AppBar(
          title: Text('新規追加'),
        ),

        body: Consumer<MainModel>(builder: (context, model, child) {


          return Padding(

            padding: const EdgeInsets.all(16),

            child: Column(

              children: [

                TextField(
                  decoration: InputDecoration(
                    labelText: "追加する筋トレ",
                    hintText: "Input",
                  ),
                  onChanged: (text) {
                    model.newWorkoutText = text;
                  },
                ),

                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    model.newWorkoutDigit = text;
                  },
                ),

                Container(
                  padding: const EdgeInsets.all(8.0),
                      child:
                      MultiSelectChip(
                        reportList,
                        onSelectionChanged: (selectedList) {
                          setState(() {
                            selectedReportList = selectedList;
                            print(selectedList);
                            model.newWorkoutCategory = selectedList.first;
                          });
                        },
                      ),
                  ),



                RaisedButton(
                        child:Text('追加する'),
                        onPressed: () async {
                        // firestoreに値を追加する
                        await model.add();
                        Navigator.pop(context);
                      },
                ),
              ],

            ),
          );
        }),
      ),
    );

  }
}

class MultiSelectChip extends StatefulWidget{

   MainModel model;
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}


class _MultiSelectChipState extends State<MultiSelectChip> {

  List<String> selectedChoices = List();
  MainModel model;

  _buildChoiceList(MainModel model) {

    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          selectedColor: Colors.teal,
          onSelected: (selected) {
            setState(() {
              Text(selectedChoices.join(" , "));
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(model),
    );
  }


}
