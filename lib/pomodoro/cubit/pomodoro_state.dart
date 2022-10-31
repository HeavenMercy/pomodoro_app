part of 'pomodoro_cubit.dart';

@immutable
abstract class PomodoroState extends Equatable {
  final PomodoroModel pom;

  const PomodoroState({required this.pom});

  @override
  List<Object?> get props => [pom];
}

class PomodoroInitial extends PomodoroState {
  PomodoroInitial() : super(pom: PomodoroModel.initial());
}

class PomodoroRunning extends PomodoroState {
  const PomodoroRunning({required super.pom});
}

class PomodoroPaused extends PomodoroRunning {
  const PomodoroPaused({required super.pom});
}

class PomodoroEnd extends PomodoroState {
  const PomodoroEnd({required super.pom});
}
