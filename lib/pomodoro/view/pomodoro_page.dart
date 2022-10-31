import 'package:pomodoro_app/pomodoro/cubit/pomodoro_cubit.dart';
import 'package:pomodoro_app/pomodoro/view/pomodoro_countdown_view.dart';
import 'package:pomodoro_app/pomodoro/view/pomodoro_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PomodoroCubit(),
      child: const PomodoroView(),
    );
  }
}

class PomodoroPrefs {
  static const wKey = 'pom-working';
  static const rKey = 'pom-resting';
  static const cKey = 'pom-cycles';

  int working, resting, cycles;
  final SharedPreferences? prefs;

  PomodoroPrefs({
    this.working = 0,
    this.resting = 0,
    this.cycles = 0,
    this.prefs,
  });

  static PomodoroPrefs load(SharedPreferences? prefs) {
    return PomodoroPrefs(
      working: prefs?.getInt(wKey) ?? 25,
      resting: prefs?.getInt(rKey) ?? 5,
      cycles: prefs?.getInt(cKey) ?? 4,
      prefs: prefs,
    );
  }

  void save({SharedPreferences? prefs}) {
    prefs ??= this.prefs;

    prefs?.setInt(wKey, working);
    prefs?.setInt(rKey, resting);
    prefs?.setInt(cKey, cycles);
  }
}

class PomodoroView extends StatelessWidget {
  const PomodoroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_sharp,
                      size: 50,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'An error occured while loading data!',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            }

            var prefs = PomodoroPrefs.load(snapshot.data!);
            return BlocBuilder(
              bloc: context.read<PomodoroCubit>(),
              builder: (context, state) {
                if ((state is PomodoroRunning) || (state is PomodoroPaused)) {
                  return PomodoroCountdownView(prefs: prefs);
                }

                return PomodoroSettingView(prefs: prefs);
              },
            );
          },
        ),
      ),
    );
  }
}
