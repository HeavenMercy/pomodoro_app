import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pomodoro_app/pomodoro/model/pomodoro_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'pomodoro_state.dart';

class PomodoroCubit extends Cubit<PomodoroState> {
  PomodoroCubit() : super(PomodoroInitial());

  void start(int workingMax, int restingMax, int cycles) {
    pause(mustEmit: false);

    emit(PomodoroRunning(
        pom: PomodoroModel(working: 0, resting: 0, cycle: cycles)));

    resume(workingMax, restingMax);
  }

  void resume(int workingMax, int restingMax) {
    if (timer != null) return;

    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (state.pom.status == PomodoroStatus.finished) {
        timer?.cancel();
        timer = null;

        emit(PomodoroEnd(pom: state.pom));
        return;
      }

      emit(PomodoroRunning(
          pom: state.pom.countdown(
              workingMax * conversionRate, restingMax * conversionRate)));
    });
  }

  void pause({bool mustEmit = true}) {
    timer?.cancel();
    timer = null;

    if (mustEmit) emit(PomodoroPaused(pom: state.pom));
  }

  void stop() {
    pause(mustEmit: false);
    emit(PomodoroEnd(pom: state.pom));
  }

  double getProgression(int workingMax, int restingMax) {
    if (state.pom.status == PomodoroStatus.working) {
      return 1 - ((state.pom.working / conversionRate) / workingMax);
    }

    if (state.pom.status == PomodoroStatus.resting) {
      return 1 - ((state.pom.resting / conversionRate) / restingMax);
    }

    return 0;
  }

  List<int> getCurrentValue() {
    double value = 0;

    if (state.pom.status == PomodoroStatus.working) {
      value = state.pom.working / conversionRate;
    }
    if (state.pom.status == PomodoroStatus.resting) {
      value = state.pom.resting / conversionRate;
    }

    return [
      value.toInt(), // minutes
      (value.remainder(1) * conversionRate ~/ 10).toInt(), //seconds
    ];
  }

  // --------------------------------------------------------------------

  Timer? timer;

  static const conversionRate = 600;

  void dispose() {
    stop();
  }
}
