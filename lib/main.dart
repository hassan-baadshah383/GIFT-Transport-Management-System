import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gtms/admin/models/bus.dart';
import 'package:gtms/admin/models/emp_attendance.dart';
import 'package:gtms/admin/providers/fee_provider.dart';
import 'package:gtms/admin/providers/routes_provider.dart';
import 'package:gtms/admin/screens/driver_management/add_driver_screen.dart';
import 'package:gtms/admin/screens/driver_management/driver_detail_description.dart';
import 'package:gtms/admin/screens/driver_management/driver_details_screen.dart';
import 'package:gtms/admin/screens/routes_management/add_route_screen.dart';
import 'package:gtms/admin/screens/routes_management/routes_details_screen.dart';
import 'package:gtms/admin/screens/students_management/attendance_detail_screen.dart';
import 'package:gtms/admin/screens/students_management/edit_student_screen.dart';
import 'package:gtms/admin/screens/students_management/fee_detail_screen.dart';
import 'package:gtms/admin/screens/students_management/student_attendance_detail_screen.dart';
import 'package:gtms/admin/screens/students_management/student_detail_description.dart';
import 'package:gtms/admin/screens/students_management/student_detail_screen.dart';
import 'package:gtms/admin/screens/vehicle_management/car_detail_description.dart';
import 'package:gtms/admin/screens/vehicle_management/add_car_screen.dart';
import 'package:gtms/admin/screens/vehicle_management/bus_detail_description.dart';
import 'package:provider/provider.dart';
import 'student/screens/student_dashboard_screen.dart';
import '/student/models/student.dart';
import 'auth-screen.dart';
import 'auth.dart';
import './student/screens/attendance_details_screen.dart';
import 'student/screens/student_bus_details_screen.dart';
import 'student/providers/students.dart';
import './student/screens/student_profile_screen.dart';
import './student/screens/bus_location_screen.dart';
import 'driver/screens/driver_dashboard_screen.dart';
import '/driver/providers/drivers.dart';
import '/admin/screens/admin_dashboard_screen.dart';
import '/driver/screens/bus_details_screen.dart';
import '/driver/screens/driver_profile_screen.dart';
import '/admin/screens/vehicle_management/car_detail_screen.dart';
import '/admin/screens/vehicle_management/bus_detail_screen.dart';
import 'admin/providers/bus_provider.dart';
import 'admin/providers/car_provider.dart';
import 'admin/screens/vehicle_management/add_bus_screen.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await initializeFirebase();
  // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: EmployeAttendance(id: '', employeeId: '', punchDatetime: '', status: '')),
          ChangeNotifierProvider.value(value: Student(id: '', cnic: '', email: '', location: '', name: '', phone: 0, rollNo: 0)),
          ChangeNotifierProvider.value(value: FeeProvider()),
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProvider.value(value: StudentData()),
          ChangeNotifierProvider.value(
            value: DriverData(),
          ),
          ChangeNotifierProvider.value(value: CarProvider()),
          ChangeNotifierProvider.value(value: BusProvider()),
          ChangeNotifierProvider.value(value: Bus(id: '', number: '', driver: '', route: '', isRented: false, date: DateTime(2020))),
          ChangeNotifierProvider.value(value: DriverData()),
          ChangeNotifierProvider.value(value: RoutesProvider())
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'GIFT Transport Management System',
              theme: ThemeData(
                fontFamily: 'Times New Roman',
                appBarTheme: AppBarTheme(titleTextStyle: TextStyle(color: Colors.white), // Title text color
                iconTheme: IconThemeData(color: Colors.white),),
                tabBarTheme: TabBarTheme(labelColor: Colors.white, unselectedLabelColor: Colors.blueAccent),
                textTheme: const TextTheme(
                    bodyMedium: TextStyle(fontFamily: 'OpenSans-Regular.ttf'),),
                primaryColor: const Color.fromRGBO(0, 0, 128, 1),
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(secondary: const Color.fromRGBO(230, 126, 0, 1)),
              ),
              home: 
              // AdminDashboardScreen(),
              // StudentDashboardScreen(),
              auth.isAdmin && auth.isAuth
                  ? AdminDashboardScreen()
                  : auth.isStudent && auth.isAuth
                      ? StudentDashboardScreen()
                      : auth.isDriver && auth.isAuth
                          ? DriverDashboardScreen()
                          : AuthenticationScreen(),
              routes: {
                BusDetailsScreen.routeName: (context) => BusDetailsScreen(),
                AttendanceDetails.routeName: (context) => AttendanceDetails(),
                StudentProfile.routeName: (context) => StudentProfile(),
                BusLocationScreen.routeName: (context) => BusLocationScreen(),
                DriverProfile.routeName: (context) => DriverProfile(),
                DriverBusDetailsScreen.routeName: (context) =>
                    DriverBusDetailsScreen(),
                CarDetailScreen.routeName: (context) => CarDetailScreen(),
                AdminBusDetailScreen.routeName: (context) =>
                    AdminBusDetailScreen(),
                AddBusScreen.routeName: (context) => AddBusScreen(),
                BusDetailDescription.routeName: (context) =>
                    BusDetailDescription(),
                AddCarScreen.routeName: (context) => AddCarScreen(),
                CarDetailDescription.routeName: (context) =>
                    CarDetailDescription(),
                DriverDetailsScreen.routeName: (context) =>
                    DriverDetailsScreen(),
                AddDriverScreen.routeName: (context) => AddDriverScreen(),
                DriverDetailDescription.routeName: (context) =>
                    DriverDetailDescription(),
                RoutesDetailsScreen.routeName: (context) =>
                    RoutesDetailsScreen(),
                AddRouteScreen.routeName: (context) => AddRouteScreen(),
                StudentDetailScreen.routeName: (context) =>
                    StudentDetailScreen(),
                StudentDetailDescription.routeName: (context) =>
                    StudentDetailDescription(),
                AttendanceDetailScreen.routeName: (context) =>
                    AttendanceDetailScreen(),
                FeeDetailScreen.routeName: (context) => FeeDetailScreen(),
                StudentsAttendanceDetails.routeName: (context) =>
                    StudentsAttendanceDetails(),
                EditStudentScreen.routeName: (context) => EditStudentScreen(),
              }),
        ));
  }
}
