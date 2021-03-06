//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:patientapp/central_screen/health/log_entry.dart';

import '../../../navigation.dart';
import '../date_organizer.dart';
import '../journal_tile.dart';

class Health extends StatefulWidget {
  @override
  _HealthState createState() => _HealthState();
}

class _HealthState extends State<Health> {
  //TODO: this List needs to be relocated

  final List<JournalTile> entries = <JournalTile>[
    JournalTile(LogEntry(
        ailment: 'Headache', physician: 'Dr. Rana', dateStamp: DateTime.now()))
  ];
  List<JournalTile> monthsDisplayed = <JournalTile>[
    JournalTile(LogEntry(
        ailment: 'Headache', physician: 'Dr. Rana', dateStamp: DateTime.now()))
  ];
  DateOrganizer date = new DateOrganizer();
  List<String> dropDownMonths = <String>[
    'All Entries',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  int currentMonthDisplayed = 0;
  String dropDownValue = 'All Entries';

  void addToEntryList() async {
    final result = await Navigator.pushNamed(context, Routes.logEntryAdd);

    if (result != null) {
      setState(() {
        entries.add(result);
        if (entries[entries.indexOf(result)].entry.dateStamp.month ==
                currentMonthDisplayed ||
            currentMonthDisplayed == 0) {
          monthsDisplayed.add(result);
        }
      });
    }
  }

  /*void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: LogEntryAdd(),
          //child: Text("hi"),
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: DropdownButton<String>(
            isExpanded: true,
            value: dropDownValue,
            //iconSize: 24,
            //elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                currentMonthDisplayed = dropDownMonths.indexOf(newValue);
                monthsDisplayed = getTileList(currentMonthDisplayed);
                dropDownValue = newValue;
              });
            },
            items: dropDownMonths.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )),
      body: SafeArea(
        child: Center(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: monthsDisplayed.length,
            itemBuilder: (BuildContext context, int index) {
              //return LogEntryAdd();
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Container(
                  child: Card(
                    //child: entries[index]
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(date.getDateStamp(
                            monthsDisplayed[index].entry.dateStamp)),
                        monthsDisplayed[index]
                      ],
                    ),
                    //color: Colors.amberAccent
                  ),
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(4.0),
                      topRight: const Radius.circular(4.0),
                      bottomLeft: const Radius.circular(4.0),
                      bottomRight: const Radius.circular(4.0),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //_showModalBottomSheet();

          setState(() {
            addToEntryList();
          });
        },
      ),
    );
  }

  List<JournalTile> getTileList(int selectedMonth) {
    if (selectedMonth == 0) {
      return entries;
    } else {
      List<JournalTile> tileList = <JournalTile>[];
      for (var i = 0; i < entries.length; i++) {
        if (entries[i].entry.dateStamp.month == selectedMonth) {
          tileList.add(entries[i]);
        }
      }
      return tileList;
    }
  }
}
