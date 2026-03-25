import 'package:flutter/material.dart';
import 'package:remindue/ui/dashboard_page.dart';
import 'package:remindue/ui/calendar_page.dart';
import 'package:remindue/ui/all_tasks_page.dart' as all_tasks;

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    CalendarPage(),
    all_tasks.AllTasksPage(),
  ];

  Color get _pageColor {
    switch (_currentIndex) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      default:
        return Colors.blue;
    }
  }

  Color get _selectedItemColor {
    switch (_currentIndex) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: _pageColor.withOpacity(0.12),
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "All Tasks"),
        ],
      ),
    );
  }
}
