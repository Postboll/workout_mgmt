import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add/add_page.dart';
import 'main_model.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(

      length: 3,

      child: ChangeNotifierProvider<MainModel>(

        create: (_) => MainModel()..getWorkoutListRealtime(),

        child: Scaffold(
          appBar: AppBar(
            title: Text("Workout at home"),
            actions: [
              Consumer<MainModel>(builder: (context, model, child) {
                final isActive = model.checkShouldActiveCompleteButton();

                return FlatButton(
                  onPressed: isActive
                      ? () async {
                    await model.deleteCheckedItems();
                  }
                      : null,
                  child: Text(
                    '削除',
                    style: TextStyle(
                      color:
                      isActive ? Colors.white : Colors.white.withOpacity(0.5),
                    ),
                  ),
                );
              })
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          body: TabBarView(

            children: [
              Consumer<MainModel>(builder: (context, model, child) {

                final workoutlist = model.workoutlist;

                return GridView.count(
                  primary: false,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: workoutlist
                      .map(
                        (workout) => Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.3, 1],
                              colors: [Colors.teal, Colors.blue]
                          )
                      ),

                      child: CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: Colors.orange,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(workout.title,
                                  style: TextStyle(fontSize: 14)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(workout.item,
                                  style: TextStyle(fontSize: 14)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 70),
                              child: Text(workout.count,
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],

                        ),
                        value: workout.isDone,
                        onChanged: (bool value) {
                          workout.isDone = !workout.isDone;
                          model.reload();
                        },
                      ),
                    ),
                  ).toList(),
                );
              }),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
          floatingActionButton:
          Consumer<MainModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPage(model),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Icon(Icons.touch_app),
            );
          }),
        ),
      ),
    );
  }
}
