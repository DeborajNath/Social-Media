import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shop_spectrum/presentation/screens/tabs/home_tab.dart';
import 'package:shop_spectrum/presentation/screens/tabs/notifications_tab.dart';
import 'package:shop_spectrum/presentation/screens/tabs/profile_tab.dart';
import 'package:shop_spectrum/presentation/screens/tabs/settings_tab.dart';

import 'package:shop_spectrum/presentation/widgets/index.dart';
import 'package:shop_spectrum/utils/constant/index.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> with SingleTickerProviderStateMixin {
  late String userName = ''; // Variable to store the user's name

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Load user's name when the widget is initialized
  }

  // Method to fetch user details from Firestore based on email
  Future<void> _loadUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('userDetails')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            userName = snapshot.docs.first['name'];
          });
        }
      } catch (e) {
        print('Error loading user details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   leading: AppBarLeading(
        //     onTap: () {},
        //   ),
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        //   title:
        // ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppBarLeading(),
                  Row(
                    children: [
                      Container(
                        width: (36 / Dimensions.designWidth).w,
                        height: (36 / Dimensions.designHeight).h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.black, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        // child: SvgPicture.asset(       //we can put image here inside of the container
                        //   ImageConstants.theme,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      const SizeBox(
                        width: 10,
                      ),
                      Text(
                        'Hi $userName',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    icon: const Icon(Icons.logout_rounded, size: 32),
                    color: Colors.black,
                  ),
                ],
              ),
              const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    HomeTab(userName: userName),
                    const NotificationsTab(),
                    const ProfileTab(),
                    const SettingsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
