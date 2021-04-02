library fluttable;
// TODO: VARIOUS ASSERTIONS NEEDED TO BE BUILT
// TODO: Change "callback" to "onTableChange"

import 'package:flutter/material.dart';

class Fluttable extends StatefulWidget {
  final String firstColumnText;
  final List<List<String>> editableDatasetList;
  final List<String> headerTexts;

  final Function(List<List<String>>) callback;

  final bool showFirstColumn;
  final bool expandableList;
  final bool showHeaderFirstColumnText;

  final GlobalKey<FormState> formKeyIfAny;

  final Color backgroundColor;
  final Color otherBackgroundColor;

  final int minRows;
  final double contentPadding;
  final bool editable;
  final bool showRowCounter;
  final bool alphaCounter;

  final List<String> rowNames;

  final List<int> rowsToDisable;
  final List<List<int>> cellsToDisable;

  final Function validateField;

  Fluttable({
    @required this.firstColumnText,
    @required this.editableDatasetList,
    @required this.headerTexts,
    @required this.callback,
    @required this.showFirstColumn,
    @required this.expandableList,
    this.validateField,
    this.showHeaderFirstColumnText: true,
    this.formKeyIfAny,
    this.backgroundColor: Colors.white,
    this.otherBackgroundColor: Colors.white70,
    this.minRows,
    this.contentPadding,
    this.editable: true,
    this.rowsToDisable,
    this.showRowCounter: true,
    this.alphaCounter: false,
    this.rowNames: const [],
    this.cellsToDisable,
    Key key,
  }) : super(key: key);

  @override
  _FluttableState createState() => _FluttableState();
}

class _FluttableState extends State<Fluttable> {
  final Keypad keypad = Keypad();

  List<List<String>> editableDatasetList = [];
  List<String> headerTexts = [];
  List<List<int>> cellsToDisable = [];
  @override
  void initState() {
    print("FLUTTABLE INIT");
    super.initState();
    editableDatasetList = widget.minRows != null
        ? [...widget.editableDatasetList].sublist(0, widget.minRows)
        : [...widget.editableDatasetList];
    headerTexts = [...widget.headerTexts];
    print("FLUTTABLE DATA: $editableDatasetList");
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.expandableList | widget.showFirstColumn);
    cellsToDisable = getCellsToDisable(editableDatasetList);
    return Column(
      children: [
        // HEAD
        Container(
          margin: EdgeInsets.symmetric(horizontal: widget.contentPadding ?? 0),
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
                            // child: Text(
                            //   "Add",
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     fontSize: 10,
                            //     fontStyle: FontStyle.italic,
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
                            child: Icon(
                              Icons.add,
                              size: 12,
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
                    margin: EdgeInsets.symmetric(
                        horizontal: widget.contentPadding ?? 0),
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
                                      "${widget.rowNames.length == widget.minRows ? widget.rowNames[i] : ''}${widget.firstColumnText}${widget.showRowCounter ? widget.alphaCounter ? String.fromCharCode(65 + editableDatasetList.indexOf(eachDataset)) : editableDatasetList.indexOf(eachDataset) + 1 : ''}",
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
                                        initialValue: editableDatasetList[i][j],
                                        keyboardType: keypad.keypadInputType,
                                        enabled: (cellsToDisable[i][j] == 1) ^
                                                widget.editable ^
                                                (widget.rowsToDisable ?? [])
                                                    .contains(i) ??
                                            true,
                                        textAlign: TextAlign.center,
                                        validator: (value) {
                                          return (cellsToDisable[i][j] == 1) ^
                                                  (widget.formKeyIfAny != null)
                                              ? widget.validateField(value)
                                              : null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            editableDatasetList[i][j] = value;
                                          });

                                          sendCallback();
                                        },
                                        decoration: getInputDecoration(
                                            (cellsToDisable[i][j] == 1) ^
                                                    widget.editable ^
                                                    (widget.rowsToDisable ?? [])
                                                        .contains(i) ??
                                                true),
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
                                        if (editableDatasetList.length >
                                                widget.minRows ??
                                            0) {
                                          setState(() {
                                            editableDatasetList
                                                .remove(eachDataset);
                                          });
                                          sendCallback();
                                        }
                                      },
                                      // child: Text(
                                      //   "Remove",
                                      //   textAlign: TextAlign.center,
                                      //   style: TextStyle(
                                      //     fontSize: 10,
                                      //     fontStyle: FontStyle.italic,
                                      //     fontWeight: FontWeight.w300,
                                      //   ),
                                      // ),
                                      child: Icon(
                                        Icons.clear,
                                        size: 10,
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
    print("FLUTTABLE: sending onchange");
    if (widget.formKeyIfAny?.currentState?.validate() ?? true) {
      print("FLUTTABLE: verified callback");
    }
    widget.callback(editableDatasetList);
  }

  List<List<int>> getCellsToDisable(List listOfList) {
    //  README: List must look like this
    // List<List<String>> listOfList = [
    //   ["z", "a", "t", "o", "r"],
    //   ["a", "r", "e", "p", "o"],
    //   ["t", "e", "n", "e", "t"],
    //   ["o", "p", "e", "r", "a"],
    //   ["r", "o", "t", "a", "z"],
    // ];
    if (widget.cellsToDisable?.isEmpty ?? true) {
      List<List<int>> cellsToDisable = [];

      for (List listValue in listOfList) {
        List<int> listInts = [];
        for (var value in listValue) {
          listInts = [...listInts, 0];
        }
        cellsToDisable = [...cellsToDisable, listInts];
      }

      return cellsToDisable;
    } else {
      if (listOfList.length == widget.cellsToDisable.length) {
        return widget.cellsToDisable;
      } else {
        // TODO: HANDLE SPECIFIC CASES TO WHICH CELLS TO RETAIN AND WHICH TO ADD OR REMOVE
        List<List<int>> cellsToDisable = [];

        for (List listValue in listOfList) {
          List<int> listInts = [];
          for (var value in listValue) {
            listInts = [...listInts, 0];
          }
          cellsToDisable = [...cellsToDisable, listInts];
        }

        return cellsToDisable;
      }
    }
  }

  InputDecoration getInputDecoration(bool isEnabled) {
    return InputDecoration(
      border: InputBorder.none,
      errorStyle: TextStyle(fontSize: 10.0),
      filled: true,
      fillColor: Colors.transparent,
      isDense: true, // Added this
      contentPadding: EdgeInsets.all(0),
      hintText: isEnabled ? 'Value' : '',
      hintStyle: TextStyle(fontSize: 10.0),
    );
  }
}

class Keypad {
  TextInputType keypadInputType;

  Keypad() {
    this.keypadInputType = TextInputType
        .phone; //TextInputType.numberWithOptions(decimal: true, signed: true);
  }
}
