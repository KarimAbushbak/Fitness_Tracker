import 'package:fittnes_track/model/workout.dart';
import 'package:fittnes_track/providers/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/workout_type.dart';
import '../widgets/workout_calendar_graph.dart';
import '../widgets/workout_form_dialog.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        final unFilteredWorkouts = ref.watch(workoutNotifierProvider);
        final upperBodyWorkouts = unFilteredWorkouts
            .where((workout) => workout.type == WorkoutType.upperBody)
            .toList();
        final lowerBodyWorkouts = unFilteredWorkouts
            .where((workout) => workout.type == WorkoutType.lowerBody)
            .toList();
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const SizedBox.shrink(),
              toolbarHeight: 170,
              flexibleSpace: const SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 56.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: WorkoutCalendarGraph(),
                  ),
                ),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: TabBar(
                  tabs: [
                    Tab(text: 'Upper Body'),
                    Tab(text: 'Lower Body'),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                _WorkoutList(workouts: upperBodyWorkouts),
                _WorkoutList(workouts: lowerBodyWorkouts),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddWorkoutDialog(context),
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  void _showAddWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const WorkoutFormDialog(),
    );
  }
}

class _WorkoutList extends StatelessWidget {
  final List<Workout> workouts;

  const _WorkoutList({required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return Center(
        child: Text(
          'No workouts found',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
        ),
      );
    }
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return Card(
              child: ListTile(
                enabled: false,
                title: Text(
                  workout.name,
                  style: TextStyle(
                    color: workout.isCompleted ? Colors.grey : Colors.white,
                    decoration: workout.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  '${workout.sets} sets x ${workout.reps} reps @ ${workout.weight} kg',
                  style: TextStyle(
                    color: workout.isCompleted ? Colors.grey  : Colors.white,
                    decoration: workout.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: workout.isCompleted,
                      onChanged: (_) {
                        ref
                            .read(workoutNotifierProvider.notifier)
                            .toggleWorkoutCompletion(workout.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(workoutNotifierProvider.notifier)
                            .removeWorkout(workout.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
