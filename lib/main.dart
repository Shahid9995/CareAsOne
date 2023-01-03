import 'dart:convert';

import 'package:careAsOne/binding/allApplicant.dart';
import 'package:careAsOne/binding/all_employee_binding.dart';
import 'package:careAsOne/binding/emp_home.dart';
import 'package:careAsOne/binding/emp_message_binding.dart';
import 'package:careAsOne/binding/home_master.dart';
import 'package:careAsOne/binding/seeker_home.dart';
import 'package:careAsOne/services/auth.dart';
import 'package:careAsOne/services/get_employee.dart';
import 'package:careAsOne/services/profile.dart';
import 'package:careAsOne/services/subscription.dart';
import 'package:careAsOne/services/user_job.dart';
import 'package:careAsOne/view/Employeer/all_applicants.dart';
import 'package:careAsOne/view/Employeer/company_setting.dart';
import 'package:careAsOne/view/Employeer/documents/documents.dart';
import 'package:careAsOne/view/Employeer/edit_employee.dart';
import 'package:careAsOne/view/Employeer/emp_manage.dart';
import 'package:careAsOne/view/Employeer/employer_message.dart';
import 'package:careAsOne/view/Employeer/homemaster.dart';
import 'package:careAsOne/view/Employeer/homepage.dart';
import 'package:careAsOne/view/Employeer/job_applicant.dart';
import 'package:careAsOne/view/Employeer/play_video.dart';
import 'package:careAsOne/view/Employeer/post_job_form.dart';
import 'package:careAsOne/view/Employeer/profile_setting.dart';
import 'package:careAsOne/view/Employeer/subscription_details.dart';
import 'package:careAsOne/view/Employeer/training_videos.dart';
import 'package:careAsOne/view/Employeer/video_interview.dart';
import 'package:careAsOne/view/Employeer/view_applicant_detail.dart';
import 'package:careAsOne/view/auth_screens/forgot_password.dart';
import 'package:careAsOne/view/auth_screens/login.dart';
import 'package:careAsOne/view/auth_screens/register/register.dart';
import 'package:careAsOne/view/documents/share.dart';
import 'package:careAsOne/view/home.dart';
import 'package:careAsOne/view/job_seeker/playvideo_jobkeeper.dart';
import 'package:careAsOne/view/job_seeker/pre_question.dart';
import 'package:careAsOne/view/job_seeker/verify_email.dart';

import 'package:careAsOne/view/routes/routes.dart';
import 'package:careAsOne/view/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:form_builder_validators/localization/l10n.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'constants/app_colors.dart';
// latest code
//testing
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  await GetStorage.init();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen(myForegroundMessageHandler);
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
   FirebaseMessaging _firebaseMessaging=FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    initializeDefault();
    iOS_Permission();
  }
   Future<void> initializeDefault() async {
     FirebaseApp app = await Firebase.initializeApp(
     );
     print('Initialized default app $app');
   }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        FormBuilderLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Care As One',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        accentColor: AppColors.green,
        primaryColor: AppColors.green,
        fontFamily: 'GT',
      ),
      // home: WebHomePage(),
      // home: LoginPage(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: AppRoute.splashRoute,
      getPages: [
        GetPage(
          name: AppRoute.splashRoute,
          page: () => SplashScreen(),
        ),
        GetPage(
          name: AppRoute.homeMasterRoute,
          page: () => Homepage(),
          binding: HomeMasterBinding(),
        ),
        GetPage(
          name: AppRoute.loginRoute,
          page: () => LoginPage(),
          // binding: LoginBinding(),
        ),
        GetPage(
          name: AppRoute.signUpRoute,
          page: () => RegisterPage(),
        ),
        GetPage(
          name: AppRoute.forgotPassRoute,
          page: () => ForgotPasswordPage(),
        ),
        GetPage(
            name: AppRoute.empHomeMasterRoute,
            page: () => HomeMasterPage(),
            binding: EmpHomeMasterBinding()
        ),
        GetPage(
          name: AppRoute.empInterviewRoute,
          page: () => VideoInterview(),
        ),
        GetPage(
            name: AppRoute.empManageRoute,
            page: () => ManageEmployees(),
            binding: AllEmployeeBinding()
        ),
        GetPage(
          name: AppRoute.empEditEmployeeRoute,
          page: () => EmpEditEmployeePage(),
        ),
        GetPage(
          name: AppRoute.empDocsRoute,
          page: () => EmpDocumentsPage(),
        ),
        GetPage(
          name: AppRoute.allApplicantRoute,
          page: () => AllApplicants(),
          binding: AllApplicantBinding(),
        ),
        GetPage(
          name: AppRoute.jobApplicantRoute,
          page: () => JobApplicants(),
        ),
        GetPage(
          name: AppRoute.viewApplicantDetailRoute,
          page: () => ViewApplicantDetail(),
        ),
        GetPage(
          name: AppRoute.postJobRoute,
          page: () => JobPostPage(),
        ),
        GetPage(
          name: AppRoute.shareDocRoute,
          page: () => ShareDocPage(),
        ),
        GetPage(
          name: AppRoute.playVideoRoute,
          page: () => PlayVideo(),
        ),
        GetPage(
          name: AppRoute.playVideoJobSeekerRoute,
          page: () => PlayVideoJobKeeper(),
        ),

        GetPage(
          name: AppRoute.empTrainingVidoesRoute,
          page: () => TrainingVideo(),
        ),
        GetPage(
          name: AppRoute.empSubscriptionRoute,
          page: () => SubscriptionDetails(),
        ),
        GetPage(
          name: AppRoute.empProfileSettingRoute,
          page: () => EmpProfilePage(),
        ),
        GetPage(
          name: AppRoute.companySettingRoute,
          page: () => CompanyProfilePage(),
        ),
        GetPage(
          name: AppRoute.preQuestionnaireRoute,
          page: () => PreQuestionPage(),
        ),
        GetPage(
            name: AppRoute.empHomeMasterRoute,
            page: () => EmpHomePage(),
            binding: EmpHomeBinding()),
        GetPage(
          name: AppRoute.empMessagesRoute,
          page:()=> EmployerMessage(),
          binding: EmpMessagesBinding(),
        ),
        GetPage(name: AppRoute.verifyEmailPage,
            page:()=> VerifyEmailPage())
      ],
    );
  }
  void iOS_Permission() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }
}
Future<void> initServices() async {
  AuthService authService = AuthService();
  await Get.putAsync(() => authService.init());
  ProfileService profileService = ProfileService();
  await Get.putAsync(() => profileService.init());
  UserJobService userJobService = UserJobService();
  await Get.putAsync(() => userJobService.init());
  EmployeeService employeeService = EmployeeService();
  await Get.putAsync(() => employeeService.init());
  SubscriptionService subscriptionService = SubscriptionService();
  await Get.putAsync(() => subscriptionService.init());
}
Future<dynamic> myForegroundMessageHandler(RemoteMessage message) async {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.notification?.body}');
  print('Message data: ${message.data}');
  if (message != null) {
    await _showNotification1(message.notification);
    print('Message also contained a notification: $message');
  }
}
Future<void> _showNotification1(RemoteNotification? Notification ) async {
  // final json = jsonEncode(Notification);
  const android = AndroidNotificationDetails('channel id', 'channel name',
      priority: Priority.high, importance: Importance.max);
  const iOS = DarwinNotificationDetails();
  const platform = NotificationDetails(android: android, iOS: iOS);
  print("===$Notification==json:$json===============");
  await flutterLocalNotificationsPlugin.show(
      0, // notification id
      Notification?.title,
      Notification?.body,
      platform,
      payload: "json");
}