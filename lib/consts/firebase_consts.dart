import 'package:unicorn_app/consts/consts.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
User? currentUser = FirebaseAuth.instance.currentUser;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

const collectionUsers = 'Users';
const collectionChats = 'Chats';
const collectionMessages = 'Messages';
