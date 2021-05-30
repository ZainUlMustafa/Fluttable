library fluttable;
// TODO: VARIOUS ASSERTIONS NEEDED TO BE BUILT
// TODO: Change "callback" to "onTableChange"

import 'package:flutter/material.dart';

class Fluttable extends StatefulWidget {
  final String firstColumnText;
  final List<List<String>> editableDatasetList;
  final List<String> headerTexts;

  // final Function(List<List<String>>) callback;

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

  final double iconSize;

  final Function(List<List<String>>) onTableEdited;
  final Function(List<List<String>>) onRowDeleted;
  final Function(List<List<String>>) onRowAdded;

  final Function validator;
  final List<List<FluttableVal>> customizeValidations;
  final FluttableValCheck customFluttableValCheck;
  final FluttableVal defaultValidator;

  Fluttable({
    @required this.firstColumnText,
    @required this.editableDatasetList,
    @required this.headerTexts,
    @required this.showFirstColumn,
    @required this.expandableList,
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
    this.iconSize: 15,
    // @Deprecated('Use [onTableEdited] instead') this.callback,
    this.onTableEdited,
    this.onRowAdded,
    this.onRowDeleted,
    this.validator,
    this.customizeValidations,
    this.customFluttableValCheck,
    this.defaultValidator,
    Key key,
  }) : super(key: key);

  @override
  _FluttableState createState() => _FluttableState();
}

class _FluttableState extends State<Fluttable> {
  final Keypad keypad = Keypad();
  FluttableValCheck fvc;

  List<List<String>> editableDatasetList = [];
  List<String> headerTexts = [];
  List<List<int>> cellsToDisable = [];
  bool isCustomizeValidationsProvided = false;

  @override
  void initState() {
    super.initState();
    initTheFluttable();
  }

  initTheFluttable() {
    // print("FLUTTABLE INIT");
    fvc = widget.customFluttableValCheck ?? FluttableValCheck();
    // print(fvc.specifyRange);
    fvc.fallbackValidator = widget.validator ??
        fvc.getValidatorFunction(
            widget.defaultValidator ?? FluttableVal.DEFAULT);
    editableDatasetList = [...widget.editableDatasetList];
    headerTexts = [...widget.headerTexts];
    isCustomizeValidationsProvided =
        (widget.customizeValidations ?? []).isNotEmpty;
    // print("FLUTTABLE DATA: $editableDatasetList");
  }

  reinitTheFluttable() {
    // print("FLUTTABLE REINIT");
    editableDatasetList = [...widget.editableDatasetList];
    // print("FLUTTABLE REDATA: $editableDatasetList");
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
                          padding: EdgeInsets.all(0),
                          child: IconButton(
                            iconSize: widget.iconSize,
                            splashRadius: widget.iconSize * 2,
                            onPressed: () {
                              setState(() {
                                List<String> listOfDataPoint = [];
                                for (var i = 0; i < headerTexts.length; i++) {
                                  listOfDataPoint.add('');
                                }
                                editableDatasetList.add(listOfDataPoint);
                              });
                              sendOnRowAdd();
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
                            icon: Icon(
                              Icons.add,
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
                                              ? isCustomizeValidationsProvided
                                                  ? fvc.doValidation(
                                                      widget.customizeValidations[
                                                          i][j],
                                                      value)
                                                  : fvc.fallbackValidator(value)
                                              : null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            editableDatasetList[i][j] = value;
                                          });

                                          sendOnTableEdited();
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
                                    child: IconButton(
                                      iconSize: widget.iconSize - 3,
                                      splashRadius: (widget.iconSize - 3) * 2,
                                      onPressed: () {
                                        if (editableDatasetList.length >
                                            (widget.minRows ?? 0)) {
                                          setState(() {
                                            editableDatasetList
                                                .remove(eachDataset);
                                          });
                                          sendOnRowDelete();
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
                                      icon: Icon(
                                        Icons.clear,
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

  sendOnTableEdited() {
    // print("FLUTTABLE: sending onchange");
    if (widget.formKeyIfAny?.currentState?.validate() ?? true) {
      // print("FLUTTABLE: verified callback");
    }
    if (widget.onTableEdited != null) widget.onTableEdited(editableDatasetList);
  }

  sendOnRowAdd() {
    // print("FLUTTABLE ADDED ROW");
    widget.onRowAdded(editableDatasetList);
  }

  sendOnRowDelete() {
    // print("FLUTTABLE DELETED ROW");
    widget.onRowDeleted(editableDatasetList);
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
        for (int i = 0; i < listValue.length; ++i) {
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
          for (int i = 0; i < listValue.length; ++i) {
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
      errorMaxLines: 10,
    );
  }
}

// Fluttable validation checker
class FluttableValCheck {
  Function(String) fallbackValidator;
  int specifyRange;
  bool shortErrors;
  FluttableValCheck(
      {this.fallbackValidator, this.specifyRange: 9, this.shortErrors: false});

  Function getValidatorFunction(FluttableVal fluttableVal) {
    switch (fluttableVal) {
      // dms
      case FluttableVal.DEGREE:
        {
          return _degreeCheck;
        }
      case FluttableVal.MINSEC:
        {
          return _minsecCheck;
        }
      case FluttableVal.HOUR:
        {
          return _hourCheck;
        }

      // simple numeric continuous -infinity to +infinity
      case FluttableVal.NUM:
        {
          return _numCheck;
        }
      // simple numeric discrete -infinity to +infinity
      case FluttableVal.INTNUM:
        {
          return _intNumCheck;
        }

      // double numerics
      case FluttableVal.POSDOUBLE:
        {
          return _posDoubleNumCheck;
        }
      case FluttableVal.NEGDOUBLE:
        {
          return _negDoubleNumCheck;
        }
      case FluttableVal.ABOVEZERODOUBLE:
        {
          return _aboveZeroDoubleNumCheck;
        }
      case FluttableVal.BELOWZERODOUBLE:
        {
          return _belowZeroDoubleNumCheck;
        }

      // int numerics
      case FluttableVal.POSINT:
        {
          return _posIntNumCheck;
        }
      case FluttableVal.NEGINT:
        {
          return _negIntNumCheck;
        }
      case FluttableVal.ABOVEZEROINT:
        {
          return _aboveZeroIntNumCheck;
        }
      case FluttableVal.BELOWZEROINT:
        {
          return _belowZeroIntNumCheck;
        }

      // string options
      case FluttableVal.ALPHA:
        {
          return _alphaCheck;
        }
      case FluttableVal.ALPHANUM:
        {
          return _alphanumCheck;
        }

      // range check
      case FluttableVal.RANGECHECK:
        {
          return _numericWithRange;
        }

      // set to table validator
      default:
        {
          return fieldCheck;
        }
    }
  }

  String doValidation(FluttableVal fluttableVal, String value) {
    switch (fluttableVal) {
      // dms
      case FluttableVal.DEGREE:
        {
          return _degreeCheck(value);
        }
      case FluttableVal.MINSEC:
        {
          return _minsecCheck(value);
        }
      case FluttableVal.HOUR:
        {
          return _hourCheck(value);
        }

      // simple numeric continuous -infinity to +infinity
      case FluttableVal.NUM:
        {
          return _numCheck(value);
        }
      // simple numeric discrete -infinity to +infinity
      case FluttableVal.INTNUM:
        {
          return _intNumCheck(value);
        }

      // double numerics
      case FluttableVal.POSDOUBLE:
        {
          return _posDoubleNumCheck(value);
        }
      case FluttableVal.NEGDOUBLE:
        {
          return _negDoubleNumCheck(value);
        }
      case FluttableVal.ABOVEZERODOUBLE:
        {
          return _aboveZeroDoubleNumCheck(value);
        }
      case FluttableVal.BELOWZERODOUBLE:
        {
          return _belowZeroDoubleNumCheck(value);
        }

      // int numerics
      case FluttableVal.POSINT:
        {
          return _posIntNumCheck(value);
        }
      case FluttableVal.NEGINT:
        {
          return _negIntNumCheck(value);
        }
      case FluttableVal.ABOVEZEROINT:
        {
          return _aboveZeroIntNumCheck(value);
        }
      case FluttableVal.BELOWZEROINT:
        {
          return _belowZeroIntNumCheck(value);
        }

      // string options
      case FluttableVal.ALPHA:
        {
          return _alphaCheck(value);
        }
      case FluttableVal.ALPHANUM:
        {
          return _alphanumCheck(value);
        }

      // range check
      case FluttableVal.RANGECHECK:
        {
          return _numericWithRange(value, range: specifyRange);
        }

      // set to table validator
      default:
        {
          return fallbackValidator(value);
        }
    }
  }

  // boolean to compute
  bool _validatePositiveDouble(String value) {
    Pattern pattern = r'^(\d*\.?\d*)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateNegativeDouble(String value) {
    Pattern pattern = r'^(-\d*\.?\d+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateAboveZeroDouble(String val) {
    Pattern pattern = r'^((\d*\.?0*[1-9]\d*)|(0*[1-9]\d*\.?\d+))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(val);
  }

  bool _validateBelowZeroDouble(String val) {
    Pattern pattern = r'^-((\d*\.?0*[1-9]\d*)|(0*[1-9]\d*\.?\d+))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(val);
  }

  bool _validatePositiveInteger(String val) {
    Pattern pattern = r'^(\d+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(val);
  }

  bool _validateNegativeInteger(String val) {
    Pattern pattern = r'^(-\d*?\d+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(val);
  }

  bool _validateAboveZeroInteger(String val) {
    Pattern pattern = r'^[0]*[1-9]\d*$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(val);
  }

  bool _validateBelowZeroInteger(String val) {
    Pattern pattern = r'^-[0]*[1-9]\d*$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(val);
  }

  // actual output generators
  String _degreeCheck(String value) {
    double parsedValue = double.tryParse(value);
    if (value.isEmpty || parsedValue == null) {
      return "Error";
    } else {
      return _validatePositiveDouble(value)
          ? (parsedValue <= 360 && parsedValue >= 0)
              ? null
              : "Not in range: 0 - 360"
          : "Cannot be negative or have spaces";
    }
  }

  String _minsecCheck(String value) {
    double parsedValue = double.tryParse(value);
    if (value.isEmpty || parsedValue == null) {
      return "Error";
    } else {
      return _validatePositiveDouble(value)
          ? (parsedValue <= 60 && parsedValue >= 0)
              ? null
              : "Not in range: 0 - 60"
          : "Cannot be negative or have spaces";
    }
  }

  String _hourCheck(String value) {
    double parsedValue = double.tryParse(value);
    if (value.isEmpty || parsedValue == null) {
      return "Error";
    } else {
      return _validatePositiveDouble(value)
          ? (parsedValue <= 24 && parsedValue >= 0)
              ? null
              : "Not in range: 0 - 24"
          : "Cannot be negative or have spaces";
    }
  }

  String _numCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      Pattern pattern = r'([.])\1{1}';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value) ? "Error" : null;
    }
  }

  String _intNumCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      Pattern pattern = r'^(-?\d+)$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value) ? "Error" : null;
    }
  }

  String _alphaCheck(String value) {
    if (value.isEmpty) {
      return "Error";
    } else {
      Pattern pattern = r'^([a-z,A-Z])*$';
      RegExp regExp = new RegExp(pattern);
      return !regExp.hasMatch(value) ? "Must be: a-z, A-Z" : null;
    }
  }

  String _alphanumCheck(String value) {
    if (value.isEmpty) {
      return "Error";
    } else {
      Pattern pattern = r'^([a-z,A-Z,0-9])*$';
      RegExp regExp = new RegExp(pattern);
      return !regExp.hasMatch(value) ? "Must be: a-z, A-Z" : null;
    }
  }

  String _posIntNumCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      return _validatePositiveInteger(value)
          ? null
          : "Cannot be negative, have decimal or spaces";
    }
  }

  String _negIntNumCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      return _validateNegativeInteger(value)
          ? null
          : "Cannot be positive, have decimal or spaces";
    }
  }

  String _aboveZeroIntNumCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      return _validateAboveZeroInteger(value)
          ? null
          : "Must be > 0 and without decimal or spaces";
    }
  }

  String _belowZeroIntNumCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      return _validateBelowZeroInteger(value)
          ? null
          : "Must be < 0 and without decimal or spaces";
    }
  }

  String _posDoubleNumCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      return _validatePositiveDouble(value)
          ? null
          : "Cannot be negative or have spaces";
    }
  }

  String _negDoubleNumCheck(String value) {
    if (value.isEmpty || double.tryParse(value) == null) {
      return 'Error';
    } else {
      return _validateNegativeDouble(value)
          ? null
          : "Cannot be positive or have spaces";
    }
  }

  String _aboveZeroDoubleNumCheck(String value) {
    double parsedValue = double.tryParse(value);
    if (value.isEmpty || parsedValue == null) {
      return 'Error';
    } else {
      return _validateAboveZeroDouble(value) && parsedValue > 0
          ? null
          : "Must be > 0 and without spaces";
    }
  }

  String _belowZeroDoubleNumCheck(String value) {
    double parsedValue = double.tryParse(value);
    if (value.isEmpty || parsedValue == null) {
      return 'Error';
    } else {
      return _validateBelowZeroDouble(value) && parsedValue < 0
          ? null
          : "Must be < 0 and without spaces";
    }
  }

  String _numericWithRange(String value, {int range: 9}) {
    range = specifyRange ?? range;
    if (value.isEmpty || double.tryParse(value) == null) {
      return "Error";
    } else {
      int range1 = range + 1;
      RegExp rangeDecimalRegExp = new RegExp(
          "((?=^-?(\\d*\\.\\d+)\$)(?=^-?[0-9.]{$range1}\$)|^-?[0-9]{$range}\$)");

      return !rangeDecimalRegExp.hasMatch(value) ? "Error" : null;
    }
  }

  String fieldCheck(String value) {
    // TODO: field check is number check, adjust!
    if (value.isEmpty || double.tryParse(value) == null) {
      return "Error";
    } else {
      Pattern pattern = r'([.])\1{1}';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value) ? "Error" : null;
    }
  }

  //

  List<List<FluttableVal>> getValidationAppliedData(
      List<List<String>> listOfLists, FluttableVal fv) {
    List<List<FluttableVal>> listOfFvList = [];
    for (List<String> eachList in listOfLists) {
      List<FluttableVal> eachFvList =
          List<FluttableVal>.filled(eachList.length, fv);
      listOfFvList = [...listOfFvList, eachFvList];
    }
    return listOfFvList;
  }

  List<List<FluttableVal>> replaceValidationOnColumn(
      List<List<String>> listOfLists, int columnNumber, FluttableVal fv,
      {FluttableVal defaultFv: FluttableVal.DEFAULT}) {
    List<List<FluttableVal>> listOfFvList =
        getValidationAppliedData(listOfLists, defaultFv);

    for (List<FluttableVal> eachFvList in listOfFvList) {
      eachFvList[columnNumber] = fv;
    }

    return listOfFvList;
  }
}

// Fluttable enums
enum FluttableVal {
  // dms
  DEGREE,
  MINSEC,
  HOUR,

  // simple numeric continuous -infinity to +infinity
  NUM,
  // simple numeric discrete -infinity to +infinity
  INTNUM,

  // double numerics
  POSDOUBLE,
  NEGDOUBLE,
  ABOVEZERODOUBLE,
  BELOWZERODOUBLE,

  // int numerics
  POSINT,
  NEGINT,
  ABOVEZEROINT,
  BELOWZEROINT,

  // string options
  ALPHA,
  ALPHANUM,

  // range check
  RANGECHECK,

  // set to table validator
  DEFAULT,
}

class Keypad {
  TextInputType keypadInputType;

  Keypad() {
    this.keypadInputType = TextInputType.text;
  }
}
