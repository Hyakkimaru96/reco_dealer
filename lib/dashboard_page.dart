import 'package:flutter/material.dart';
import 'package:junkee_dealer/calendar_page.dart';
import 'package:junkee_dealer/home_page.dart';
import 'package:junkee_dealer/profile_page.dart';

class DealerDashboardPage extends StatefulWidget {
  @override
  _DealerDashboardPageState createState() => _DealerDashboardPageState();
}

class _DealerDashboardPageState extends State<DealerDashboardPage> {
  int _selectedIndex = 0; // Index for the selected tab

  @override
  void _onItemTapped(int index){
    _selectedIndex = index;
    setState(() {
      
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? CalendarPage(dealerId: 1,) : _selectedIndex == 1 ? HomePage() : ProfilePage(),
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
