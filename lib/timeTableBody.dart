import 'package:flutter/material.dart';

class TimeTableBody extends StatefulWidget {
  @override
  _TimeTableBodyState createState() => _TimeTableBodyState();
}

class _TimeTableBodyState extends State<TimeTableBody> {
  var startTime = DateTime.now();
  late var endTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.endTime =
          DateTime.utc(startTime.year, startTime.month, startTime.day, 23, 59);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xffECEAFF),
        child: GestureDetector(
            onVerticalDragUpdate: handleVDragUpdate,
            child: CustomPaint(
              child: Container(),
              painter: TimeTablePainter(startTime, endTime),
            )));
  }

  void handleVDragUpdate(DragUpdateDetails d) {
    var delta = d.primaryDelta;
    print("Drag update pd=${d.primaryDelta}");
    setState(() {
      startTime = startTime.add(Duration(minutes: -delta!.toInt()));
      endTime = endTime.add(Duration(minutes: -delta.toInt()));
    });
  }
}

class TimeTablePainter extends CustomPainter {
  final DateTime startTime;
  final DateTime endTime;

  final hourTextStyle = TextStyle(color: Colors.black, fontSize: 13);

  TimeTablePainter(this.startTime, this.endTime);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var startHour = startTime.hour;

    var slotWidth = size.width * 0.75;
    var slotHeight = size.height / 12.0;

    final fraction = startTime.minute.toDouble() / 60;
    var slotHeightFraction = -fraction * slotHeight;

    var tableLineBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    var hLineIndex = 0;
    var hLineOffset = 13;
    double startX = 46; // should be modified to a relative value
    var textPositionOffset = Offset(12, 5);

    while (startHour < 24 || startHour >= 0) {
      drawText(
          canvas,
          textPositionOffset +
              Offset(0, hLineIndex * slotHeight + slotHeightFraction),
          startHour.toString(),
          hourTextStyle);
      final point1 = Offset(
          startX, hLineIndex * slotHeight + slotHeightFraction + hLineOffset);
      final point2 = Offset(startX + slotWidth,
          hLineIndex * slotHeight + slotHeightFraction + hLineOffset);
      canvas.drawLine(point1, point2, tableLineBrush);
      hLineIndex++;
      startHour++;
      if (startHour >= 24) {
        startHour = 0;
        break;
      }
    }
  }
}

void drawText(Canvas canvas, Offset pos, String str, TextStyle style) {
  final tp = measureText(str, style);
  paintText(canvas, pos, tp);
}

TextPainter measureText(String str, TextStyle style) {
  final ts = TextSpan(text: '$str:00', style: style);
  final tp = TextPainter(
      text: ts, textAlign: TextAlign.right, textDirection: TextDirection.rtl);
  tp.layout(minWidth: 0, maxWidth: double.maxFinite);
  return tp;
}

void paintText(Canvas canvas, Offset pos, TextPainter tp) {
  tp.paint(canvas, pos);
}
