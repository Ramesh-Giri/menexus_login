import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/app_user.dart';

class UserRepository {
  //register new user to the firebase based on the initial data;
  Future<AppUser> registerUserUsingEmailPassword(
      String name, String emailAddress, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress, password: password);

    //creating new instance of user to store.
    AppUser appUser = AppUser(
      fullName: name,
      emailAddress: emailAddress,
      uId: FirebaseAuth.instance.currentUser!.uid,
      createdDate: DateTime.now().toIso8601String(),
    );

    //save the user data to the database after signup process
    var userRef = FirebaseFirestore.instance.collection('users');
    var uId = FirebaseAuth.instance.currentUser!.uid;
    await userRef.doc(uId).set(appUser.toJson());
    return appUser;
  }

  //login user with email and password
  loginUserByEmailPassword(String emailAddress, String password) async {
    var cred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);

    var data = await fetchUserWithId(cred.user!.uid);

    return data;
  }

  //fetch the user based on the id
  Future<AppUser?> fetchUserWithId(String userId) async {
    AppUser? user;
    var ref =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (ref.exists && ref.exists) {
      user = AppUser.fromJson(ref.data()!);
    }
    return user;
  }

  Future<AppUser?> signInWithGoogle() async {
    var googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      //save the user data to the database after signup process
      var userRef = FirebaseFirestore.instance.collection('users');
      var uId = FirebaseAuth.instance.currentUser!.uid;

      AppUser appUser = AppUser(
          fullName: user!.displayName ?? '',
          emailAddress: user.email ?? '',
          uId: uId,
          createdDate: DateTime.now().toIso8601String());

      await userRef.doc(uId).set(appUser.toJson());

      var data = await fetchUserWithId(uId);

      return data;
    }
    return null;
  }

  Future<List<AppUser>> fetchMembersExcept(String appUserUId) async {
    List<AppUser> membersList = [];
    var firebaseRef = FirebaseFirestore.instance;
    final membersCollection = await firebaseRef.collection('users').get();

    if (membersCollection.docs.isNotEmpty) {
      for (var item in membersCollection.docs) {
        var newUser = AppUser.fromJson(item.data());
        //if (newUser.uId != appUserUId) {
        membersList.add(newUser);
        //}
      }
    }

    return membersList;
  }
}
