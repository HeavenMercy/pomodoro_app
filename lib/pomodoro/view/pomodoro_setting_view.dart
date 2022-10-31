import 'package:pomodoro_app/pomodoro/cubit/pomodoro_cubit.dart';
import 'package:pomodoro_app/pomodoro/view/pomodoro_page.dart';
import 'package:pomodoro_app/pomodoro/widgets/rectangular_button.dart';
import 'package:pomodoro_app/pomodoro/widgets/number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PomodoroSettingView extends StatefulWidget {
  const PomodoroSettingView({super.key, required this.prefs});

  final PomodoroPrefs prefs;

  @override
  State<PomodoroSettingView> createState() => _PomodoroSettingViewState();
}

class _PomodoroSettingViewState extends State<PomodoroSettingView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NumberInputField(
                onChanged: (value) => widget.prefs.working = value,
                label: 'working',
                value: widget.prefs.working,
              ),
              NumberInputField(
                onChanged: (value) => widget.prefs.resting = value,
                label: 'resting',
                value: widget.prefs.resting,
              ),
              NumberInputField(
                onChanged: (value) => widget.prefs.cycles = value,
                label: 'cycles',
                value: widget.prefs.cycles,
              ),
            ],
          ),
          const SizedBox(height: 30),
          RectangularButton(
            onTap: () {
              widget.prefs.save();
              var pomData = context.read<PomodoroCubit>();
              pomData.start(widget.prefs.working, widget.prefs.resting,
                  widget.prefs.cycles);
            },
            icon: Icons.play_arrow,
            text: 'START',
          )
        ],
      ),
    );
  }
}
