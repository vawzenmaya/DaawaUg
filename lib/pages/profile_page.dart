import 'package:flutter/material.dart';
import 'package:toktok/pages/first_tab.dart';
import 'package:toktok/pages/second_tab.dart';
import 'package:toktok/pages/third_tab.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kasule Laurenmaya', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(Icons.person_add, color: Colors.black,),
          actions: const [Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.menu, color: Colors.black,),
          )],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
      
            // Profile pic
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              image: const DecorationImage(
                image: AssetImage('assets/p1.jpg'),
                fit: BoxFit.cover,),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              '@vawzen', 
              style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: const Column(
                  children: [
                  Text(
                    '3',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )
                ],),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Column(
                  children: [
                  Text(
                    '70',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Followers',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )
                ],),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Column(
                  children: [
                  Text(
                    '370',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Likes',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )
                ],),
              ),
            )
          ],),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  // ignore: sort_child_properties_last
                  child:
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  decoration:
                    BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ],
          ),
          Text('Bio here', style: TextStyle(color: Colors.grey[700]),),
      
          // tab controller
          const TabBar(
            tabs: [
              Tab(
                text: 'Videos',
              ),
              Tab(
                text: 'Favorites',
              ),
              Tab(
                text: 'Liked',
              ),
            ],
            labelColor: Colors.black,
          ),

          const Expanded(
            child: TabBarView(
              children: [
                FirstTab(),
                SecondTab(),
                ThirdTab(),
              ],
            ),
          ),
      
        ],),
      ),
    );
  }
}