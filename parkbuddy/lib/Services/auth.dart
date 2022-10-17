import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/myuser.dart';
import 'database.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  MyUser? _userFromFirebaseUser(auth.User? user) {
    return user != null ? MyUser(uid: user.uid, email: user.email) : null;
  }

  Stream<MyUser?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email and pw
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebaseUser(credential.user);
  }

  //register with email and pw
  Future<MyUser?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    //create new doc for the user with this uid
    await DatabaseService(uid: credential.user!.uid)
        .updateUserData(name, '', '', '', '', '');
    return _userFromFirebaseUser(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
