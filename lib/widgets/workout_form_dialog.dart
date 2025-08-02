import 'package:fittnes_track/providers/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../enums/workout_type.dart';

class WorkoutFormDialog extends HookConsumerWidget {
  const WorkoutFormDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final selectedType = useState(WorkoutType.upperBody);
    final nameController = useTextEditingController();
    final weightController = useTextEditingController();
    final repsController = useTextEditingController();
    final setsController = useTextEditingController();
    void submitForm() {
      if (formKey.currentState?.validate() ?? false) {
        final workout = ref
            .read(workoutNotifierProvider.notifier)
            .createNewWorkout(
              name: nameController.text,
              weight: double.tryParse(weightController.text) ?? 0.0,
              reps: int.tryParse(repsController.text) ?? 0,
              sets: int.tryParse(setsController.text) ?? 0,
              type: selectedType.value,
            );
        Navigator.of(context).pop(workout);
      }
    }

    return AlertDialog(
      title: const Text('Add Workout'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
            ),
            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter weight' : null,
            ),
            TextFormField(
              controller: repsController,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter reps' : null,
            ),
            TextFormField(
              controller: setsController,
              decoration: const InputDecoration(labelText: 'Sets'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter sets' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<WorkoutType>(
              value: selectedType.value,
              onChanged: (value) {
                if (value != null) {
                  selectedType.value = value;
                }
              },
              items: const [
                DropdownMenuItem(
                  value: WorkoutType.upperBody,
                  child: Text('Upper Body'),
                ),
                DropdownMenuItem(
                  value: WorkoutType.lowerBody,
                  child: Text('Lower Body'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: submitForm, child: const Text('Add')),
      ],
    );
  }
}
