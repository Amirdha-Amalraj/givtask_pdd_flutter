import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'data/volunteer_providers.dart';

class VolunteerCalendarScreen extends ConsumerStatefulWidget {
  const VolunteerCalendarScreen({super.key});

  @override
  ConsumerState<VolunteerCalendarScreen> createState() => _VolunteerCalendarScreenState();
}

class _VolunteerCalendarScreenState extends ConsumerState<VolunteerCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final activeTasksAsync = ref.watch(myActiveTasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: activeTasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (applications) {
                // Filter applications based on selected date (mock logic)
                // Assuming task.eventDate exists
                final tasksForSelectedDay = applications.where((app) {
                  if (app.task?.eventDate == null) return false;
                  return isSameDay(app.task!.eventDate, _selectedDay);
                }).toList();

                if (tasksForSelectedDay.isEmpty) {
                  return const Center(child: Text('No events on this day.'));
                }

                return ListView.builder(
                  itemCount: tasksForSelectedDay.length,
                  itemBuilder: (context, index) {
                    final task = tasksForSelectedDay[index].task;
                    return ListTile(
                      leading: const Icon(Icons.event, color: Colors.blue),
                      title: Text(task?.title ?? 'Event'),
                      subtitle: Text(task?.ngoName ?? 'Unknown NGO'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
