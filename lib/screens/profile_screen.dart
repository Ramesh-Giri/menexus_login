import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Detail',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () async {
                                FirebaseAuth.instance.signOut();
                                GoogleSignIn().signOut();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/login', ModalRoute.withName('/'));
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildTitleText(
                        'Name: ',
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(child: Text('${snapshot.data!['fullName']}')),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      _buildTitleText('Email address: '),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Text('${snapshot.data!['emailAddress']}')),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      _buildTitleText('Account Created on: '),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(child: Text('${snapshot.data!['createdDate']}')),
                    ],
                  ),
                ],
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  _buildTitleText(String title) {
    return Text(title,
        style: const TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold));
  }
}
