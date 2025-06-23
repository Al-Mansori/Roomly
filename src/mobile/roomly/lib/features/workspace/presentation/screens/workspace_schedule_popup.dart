import 'package:flutter/material.dart';
import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';

class WorkspaceSchedulePopup extends StatelessWidget {
  final List<WorkspaceScheduleModel> schedules;

  const WorkspaceSchedulePopup({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 16, top: 16 + 16, right: 16, bottom: 16),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Reception hours',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          schedule.day,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: schedule.day == _getCurrentDay() ? Colors.blue : Colors.black,
                          ),
                        ),
                        Text(
                          '${schedule.startTime} - ${schedule.endTime}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: schedule.day == _getCurrentDay() ? Colors.blue : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getCurrentDay() {
    final now = DateTime.now();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[now.weekday - 1];
  }
}

