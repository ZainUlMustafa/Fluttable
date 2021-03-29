library fluttable;

import 'package:flutter/material.dart';

class Fluttable extends StatefulWidget {
  final String firstColumnText;
  final List<List> editableDatasetList;
  final List<String> headerTexts;

  final Function callback;

  final bool showFirstColumn;
  final bool expandableList;
  final bool showHeaderFirstColumnText;

  final GlobalKey<FormState> formKeyIfAny;

  final Color backgroundColor;
  final Color otherBackgroundColor;

  Fluttable({
    @required this.firstColumnText,
    @required this.editableDatasetList,
    @required this.headerTexts,
    @required this.callback,
    @required this.showFirstColumn,
    @required this.expandableList,
    this.showHeaderFirstColumnText: true,
    this.formKeyIfAny,
    this.backgroundColor: Colors.white,
    this.otherBackgroundColor: Colors.white70,
  });

  @override
  _FluttableState createState() => _FluttableState();
}

class _FluttableState extends State<Fluttable> {
  final Keypad keypad = Keypad();

  List<List<String>> editableDatasetList = [];
  List<String> headerTexts = [];
  @override
  void initState() {
    super.initState();
    editableDatasetList = [...widget.editableDatasetList];
    headerTexts = [...widget.headerTexts];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.expandableList | widget.showFirstColumn);
    return Column(
      children: [
        // HEAD
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border(
              top: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              bottom: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              right: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              left: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
          ),
          child: Row(
            children: [
              widget.showFirstColumn
                  ? Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.backgroundColor,
                        ),
                        // color: Colors.red,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            widget.showHeaderFirstColumnText
                                ? "${widget.firstColumnText}"
                                : "",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              ...headerTexts
                  .map((e) => Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.backgroundColor,
                          ),
                          // color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              e,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              widget.expandableList
                  ? Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.backgroundColor,
                        ),
                        // color: Colors.red,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                List<String> listOfDataPoint = [];
                                for (var i = 0; i < headerTexts.length; i++) {
                                  listOfDataPoint.add('');
                                }
                                editableDatasetList.add(listOfDataPoint);
                              });
                              sendCallback();
                            },
                            child: Text(
                              "+",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),

        // DATA
        ...editableDatasetList
            .asMap()
            .map((i, eachDataset) => MapEntry(
                  i,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: editableDatasetList.indexOf(eachDataset) % 2 == 0
                          ? widget.otherBackgroundColor
                          : widget.backgroundColor,
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        right: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        left: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        widget.showFirstColumn
                            ? Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  // color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${widget.firstColumnText} ${editableDatasetList.indexOf(eachDataset) + 1}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        ...eachDataset
                            .asMap()
                            .map((j, eachPoint) {
                              return MapEntry(
                                j,
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    // color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        validator: (value) {
                                          return validateNumericField(value,
                                              isInTable: true);
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            editableDatasetList[i][j] = value;
                                          });

                                          sendCallback();
                                        },
                                        decoration: keypad.tableInputDecoration,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                            .values
                            .toList(),
                        widget.expandableList
                            ? Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: editableDatasetList
                                                    .indexOf(eachDataset) %
                                                2 ==
                                            0
                                        ? widget.otherBackgroundColor
                                        : widget.backgroundColor,
                                  ),
                                  // color: Colors.red,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          editableDatasetList
                                              .remove(eachDataset);
                                        });
                                        sendCallback();
                                      },
                                      child: Text(
                                        "-",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ))
            .values,
      ],
    );
  }

  sendCallback() {
    if (widget.formKeyIfAny?.currentState?.validate() ?? true) {
      widget.callback(editableDatasetList);
    }
  }

  String validateNumericField(String value, {bool isInTable: false}) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return isInTable ? "Error" : 'Enter a valid amount';
    } else {
      // Docs: https://stackoverflow.com/questions/2622776/regex-to-match-four-repeated-letters-in-a-string-using-a-java-pattern
      Pattern pattern = r'([.])\1{1}';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value)
          ? isInTable
              ? "Error"
              : "Enter a valid amount"
          : null;
    }
  }
}

class Keypad {
  TextInputType keypadInputType;
  InputDecoration inputDecoration;
  InputDecoration tableInputDecoration;

  Keypad() {
    this.keypadInputType =
        TextInputType.numberWithOptions(decimal: true, signed: true);

    this.tableInputDecoration = InputDecoration(
      border: InputBorder.none,
      errorStyle: TextStyle(fontSize: 10.0),
      filled: true,
      fillColor: Colors.transparent,
      isDense: true, // Added this
      contentPadding: EdgeInsets.all(0),
      hintText: 'Value',
      hintStyle: TextStyle(fontSize: 10.0),
    );
  }
}
