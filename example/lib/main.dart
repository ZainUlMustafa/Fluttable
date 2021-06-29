import 'package:fluttable/fluttable.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttable Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fluttable'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  var tableKey = GlobalKey();
  String stringEntryOne = "";

  String result;

  // HERE IN THIS EXAMPLE WE ARE GENERATING 2 COLUMN TABLE
  Points points = Points();
  List<Points> listOfPoints = [
    Points(xcorr: '1', ycorr: '2'),
    Points(xcorr: '6', ycorr: '5'),
  ];
  // List<Points> listOfEnteredPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SIMPLE TEXT FIELD TO DISPLAY WORKING WITH FORM AND FLUTTABLE
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      stringEntryOne = value;
                    });
                    doSomething();
                  },
                  validator: (value) {
                    return validateNumericField(value);
                  },
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 10.0),
                    suffix: Text(''),
                    filled: true,
                    isDense: true,
                    // hintText: 'Enter value',
                    labelText: 'Enter value',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),

                SizedBox(height: 30),

                // FLUTTABLE IMPLEMENTATION
                Fluttable(
                  tapableColumns: [0],
                  showTapCellAsButton: true,
                  onCellTap: (value) {
                    print("cell value: $value");
                  },
                  onRowTap: (listOfValues) {
                    print("row value: $listOfValues");
                  },
                  editable: false,
                  defaultValidator: FluttableVal.POSINT,
                  key: tableKey,
                  contentPadding: 30,
                  showHeaderFirstColumnText: false,
                  expandableList: true,
                  showFirstColumn: true,
                  firstColumnText: "Point P",
                  editableDatasetList:
                      points.convertPointsToRawList(listOfPoints),
                  headerTexts: ["x", "y"],
                  onTableEdited: (value) {
                    print(value);
                    setState(() {
                      listOfPoints = points.convertRawListToPointsList(value);
                    });
                    doSomething();
                  },
                  onRowAdded: (value) {
                    setState(() {
                      listOfPoints = points.convertRawListToPointsList(value);
                      tableKey = GlobalKey();
                      result = null;
                    });
                  },
                  onRowDeleted: (value) {
                    setState(() {
                      listOfPoints = points.convertRawListToPointsList(value);
                      tableKey = GlobalKey();
                    });
                    doSomething();
                  },
                  formKeyIfAny: _formKey,
                  minRows: 2,
                ),

                SizedBox(height: 30),

                resultWidget(),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  doSomething() {
    if (_formKey.currentState.validate()) {
      print(listOfPoints.map((e) => e.toMap()));
      print("validation cool!");
      setState(() {
        result = "$stringEntryOne and ${listOfPoints.map((e) => e.toMap())}";
      });
    } else {
      print("validation not!");
      setState(() {
        result = null;
      });
    }
  }

  Widget resultWidget() {
    bool canShow = false;

    if (result != null) {
      canShow = true;
    }

    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Text('Result'),
            SizedBox(height: 5),
            canShow ? Text('$result') : Container(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

String validateNumericField(String value) {
  if (value.isEmpty || double.tryParse(value) == null) {
    return 'Number only';
  } else {
    Pattern pattern = r'([.])\1{1}';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value) ? "Number only" : null;
  }
}

// HELPER CLASS TO CONVERT LIST<LIST<STRING>> to LIST<POINTS>
class Points {
  String xcorr;
  String ycorr;
  Points({this.xcorr, this.ycorr});

  List<Points> convertRawListToPointsList(List<List<String>> rawItems) {
    List<Points> listOfPoints = [];
    for (var rawItem in rawItems) {
      if (rawItem.length != 2) throw "List length doesn't match Points class";
      listOfPoints.add(Points(xcorr: rawItem[0], ycorr: rawItem[1]));
    }

    return listOfPoints;
  }

  List<List<String>> convertPointsToRawList(List<Points> pointsItems) {
    List<List<String>> listOfListPoints = [];
    for (var pointsItem in pointsItems) {
      List<String> pointList = [pointsItem.xcorr, pointsItem.ycorr];
      listOfListPoints.add(pointList);
    }
    return listOfListPoints;
  }

  Map<String, dynamic> toMap() {
    return {
      'xcorr': xcorr ?? "",
      'ycorr': ycorr ?? "",
    };
  }
}
