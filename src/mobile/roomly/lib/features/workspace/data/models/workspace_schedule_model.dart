import 'package:equatable/equatable.dart';

class WorkspaceScheduleModel extends Equatable {
  final String day;
  final String startTime;
  final String endTime;
  final String workspaceId;

  const WorkspaceScheduleModel({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.workspaceId,
  });

  factory WorkspaceScheduleModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceScheduleModel(
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      workspaceId: json['workspaceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'workspaceId': workspaceId,
    };
  }

  @override
  List<Object?> get props => [day, startTime, endTime, workspaceId];
}

