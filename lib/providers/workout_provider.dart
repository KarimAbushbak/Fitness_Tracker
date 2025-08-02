import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:fittnes_track/model/workout.dart';

import '../enums/workout_type.dart';

part 'workout_provider.g.dart';
@Riverpod(keepAlive: true)
class WorkoutNotifier extends _$WorkoutNotifier {
  final _uuid = const Uuid();
  @override
  List<Workout> build() {
    return [];
  }

  void addWorkout(Workout workout) {
    state = [...state, workout];
  }

  void removeWorkout(String id) {
    state = state.where((workout) => workout.id != id).toList();
  }

  void updateWorkout(Workout updatedWorkout) {
    state = [
      for (final workout in state)
        if (workout.id == updatedWorkout.id) updatedWorkout else workout,
    ];
  }
  void toggleWorkoutCompletion(String id) {
    state = state.map((workout) {
      if (workout.id == id) {
        return workout.copyWith(
          isCompleted: !workout.isCompleted,
          completedAt: workout.isCompleted ? null : DateTime.now(),
        );
      }
      return workout;
    }).toList();
  }

  Workout createNewWorkout({
    required String name,
    required double weight,
    required int reps,
    required int sets,
    required WorkoutType type,
  }) {
    final newWorkout = Workout(
      id: _uuid.v4(),
      name: name,
      weight: weight,
      reps: reps,
      sets: sets,
      isCompleted: false,
      type: type,
      createdAt: DateTime.now(),
    );
    addWorkout(newWorkout);
    return newWorkout;
  }
}