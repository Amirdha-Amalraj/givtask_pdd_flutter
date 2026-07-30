import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'data/ngo_providers.dart';

class NgoCalendarScreen extends ConsumerStatefulWidget {
  const NgoCalendarScreen({super.key});

  @override
  ConsumerState<NgoCalendarScreen> createState() => _NgoCalendarScreenState();
}

class _NgoCalendarScreenState extends ConsumerState<NgoCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(ngoTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (tasks) {
          // A real app would parse task start/end dates. 
          // For now, we simulate markers.
          
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (_selectedDay != null)
                      Text(
                        'Events for ${_selectedDay!.month}/${_selectedDay!.day}/${_selectedDay!.year}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 16),
                    if (tasks.isNotEmpty)
                      ...tasks.take(2).map((task) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(task.title ?? 'Untitled'),
                          subtitle: Text(task.location ?? 'Remote'),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ))
                    else
                      const Center(child: Text('No events scheduled.'))
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
