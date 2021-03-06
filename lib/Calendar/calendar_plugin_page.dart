import 'package:calender_flutter/Calendar/calendarPlugin.dart';
import 'package:calender_flutter/Calendar/date_utils.dart';
import 'package:calender_flutter/Calendar/default_weekday_labels_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalendarPluginPage extends StatelessWidget {
  static final MAX_ROWS_COUNT = 6;

  DateTime pageStartDate;
  DateTime pageEndDate;
  List<String> weekdayLabelsRow;

  int startDayOffset;

  CalendarPluginPage(
      {this.pageStartDate, this.pageEndDate, this.weekdayLabelsRow}) {
    startDayOffset = pageStartDate.weekday - DateTime.monday;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildRows(context),
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  List<Widget> buildRows(BuildContext context) {
    List<Widget> rows = [];
    List<Widget> weekDays = [];
    String today = weekdayLabelsRow[DateTime.now().weekday - 1];

    weekdayLabelsRow.forEach((day) {
      if (day == today) {
        weekDays.add(
          Expanded(
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.rectangle),
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
          ),
        );
      } else {
        weekDays.add(
          Expanded(
            child: Text(day, textAlign: TextAlign.center),
          ),
        );
      }
    });
    Widget row = Row(
      children: weekDays,
    );

    rows.add(row);

    DateTime rowLastDayDate =
        DateUtils.addDaysToDate(pageStartDate, 6 - startDayOffset);
    //  DateTime rowLastDayDate = pageStartDate.add(Duration(days: 6 - startDayOffset));

    if (pageEndDate.isAfter(rowLastDayDate)) {
      rows.add(Row(
          children: buildCalendarRow(context, pageStartDate, rowLastDayDate)));

      for (var i = 1; i < MAX_ROWS_COUNT; i++) {
        DateTime nextRowFirstDayDate =
            DateUtils.addDaysToDate(pageStartDate, 7 * i - startDayOffset);

        if (nextRowFirstDayDate.isAfter(pageEndDate)) {
          break;
        }

        DateTime nextRowLastDayDate =
            DateUtils.addDaysToDate(pageStartDate, 7 * i - startDayOffset + 6);

        if (nextRowLastDayDate.isAfter(pageEndDate)) {
          nextRowLastDayDate = pageEndDate;
        }

        rows.add(Row(
            children: buildCalendarRow(
                context, nextRowFirstDayDate, nextRowLastDayDate)));
      }
    } else {
      rows.add(
          Row(children: buildCalendarRow(context, pageStartDate, pageEndDate)));
    }

    return rows;
  }

  List<Widget> buildCalendarRow(
      BuildContext context, DateTime rowStartDate, DateTime rowEndDate) {
    List<Widget> items = [];

    DateTime currentDate = rowStartDate;
    for (int i = 0; i < 7; i++) {
      if (i + 1 >= rowStartDate.weekday && i + 1 <= rowEndDate.weekday) {
        CalendarPluginState calendarroState = CalendarPlugin.of(context);

        Widget dayTile = calendarroState.widget.dayTileBuilder
            .build(context, currentDate, calendarroState.widget.onTap);

        items.add(dayTile);

        currentDate = currentDate.add(
          Duration(days: 1),
        );
      } else {
        items.add(
          Expanded(
            child: Text(""),
          ),
        );
      }
    }

    return items;
  }
}
