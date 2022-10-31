import 'package:equatable/equatable.dart';

class PomodoroModel extends Equatable {
  const PomodoroModel({
    required this.working,
    required this.resting,
    required this.cycle,
  });

  factory PomodoroModel.initial() {
    return const PomodoroModel(working: 0, resting: 0, cycle: 0);
  }

  final int working;
  final int resting;
  final int cycle;

  PomodoroStatus get status {
    if (working > 0) {
      return PomodoroStatus.working;
    } else if (resting > 0) {
      return PomodoroStatus.resting;
    }

    if (cycle <= 0) return PomodoroStatus.finished;

    return PomodoroStatus.idle;
  }

  PomodoroModel countdown(int workingMax, int restingMax) {
    if (working > 0) {
      return PomodoroModel(
          working: working - 1, resting: resting, cycle: cycle);
    } else if (resting > 0) {
      return PomodoroModel(working: 0, resting: resting - 1, cycle: cycle);
    } else if (cycle > 0) {
      return PomodoroModel(
          working: workingMax, resting: restingMax, cycle: cycle - 1);
    }

    return const PomodoroModel(working: 0, resting: 0, cycle: 0);
  }

  @override
  List<Object?> get props => [working, resting, cycle];
}

enum PomodoroStatus { idle, working, resting, finished }
