import 'package:pomodoro_app/pomodoro/cubit/pomodoro_cubit.dart';
import 'package:pomodoro_app/pomodoro/model/pomodoro_model.dart';
import 'package:pomodoro_app/pomodoro/view/pomodoro_page.dart';
import 'package:pomodoro_app/pomodoro/widgets/rectangular_button.dart';
import 'package:pomodoro_app/pomodoro/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PomodoroCountdownView extends StatefulWidget {
  const PomodoroCountdownView({super.key, required this.prefs});

  final PomodoroPrefs prefs;

  @override
  State<PomodoroCountdownView> createState() => _PomodoroCountdownViewState();
}

class _PomodoroCountdownViewState extends State<PomodoroCountdownView> {
  PomodoroCubit? pomBloc;

  @override
  Widget build(BuildContext context) {
    pomBloc = context.read<PomodoroCubit>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container()),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: BlocBuilder<PomodoroCubit, PomodoroState>(
                buildWhen: (previous, current) =>
                    previous.pom.cycle != current.pom.cycle,
                builder: (context, state) {
                  return Text(
                    '${widget.prefs.cycles - state.pom.cycle} / ${widget.prefs.cycles}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ],
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Stack(
              children: [
                BlocBuilder<PomodoroCubit, PomodoroState>(
                  builder: (context, state) {
                    var value = pomBloc?.getCurrentValue() ?? [0, 0];

                    var descStyle = Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.grey);

                    return CircularPercentIndicator(
                      radius: 150.0,
                      lineWidth: 15.0,
                      backgroundWidth: 5,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: pomBloc?.getProgression(
                              widget.prefs.working, widget.prefs.resting) ??
                          0,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 20),
                              Text(
                                value[0].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\'${value[1].toString()}',
                                style: descStyle,
                              ),
                            ],
                          ),
                          Text(
                            state.pom.status == PomodoroStatus.working
                                ? 'Work'
                                : 'Rest',
                            style: descStyle,
                          )
                        ],
                      ),
                      progressColor: getColor(context, state),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: BlocBuilder<PomodoroCubit, PomodoroState>(
                    builder: (context, state) {
                      return RoundedButton(
                        icon: (state is PomodoroPaused
                            ? Icons.play_arrow_sharp
                            : Icons.pause_sharp),
                        onTap: () {
                          if (state is PomodoroPaused) {
                            pomBloc?.resume(
                                widget.prefs.working, widget.prefs.resting);
                          } else {
                            pomBloc?.pause();
                          }
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: RoundedButton(
                    icon: Icons.restart_alt_sharp,
                    onTap: () {
                      pomBloc?.start(widget.prefs.working, widget.prefs.resting,
                          widget.prefs.cycles);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RectangularButton(
                icon: Icons.stop,
                text: 'STOP',
                onTap: () {
                  pomBloc?.stop();
                },
                backgroundColor: Colors.redAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color getColor(BuildContext context, PomodoroState state) {
    if (state.pom.status == PomodoroStatus.working) return Colors.redAccent;
    if (state.pom.status == PomodoroStatus.resting) {
      return Theme.of(context).primaryColor;
    }

    return Colors.grey;
  }

  @override
  void dispose() {
    pomBloc?.dispose();
    super.dispose();
  }
}
