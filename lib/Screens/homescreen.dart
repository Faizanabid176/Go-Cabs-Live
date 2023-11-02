import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gocabs_live/config.dart';
import 'package:gocabs_live/widgets/snackbar.dart';
import 'dart:convert'; // Json decoding ke liye
import 'package:http/http.dart' as http;
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  List<dynamic> rides = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // API se data fetch karne ka function
  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://13gocabs.com.au/api/Hdl_GetAllRides.ashx'));
    if (response.statusCode == 200) {
      setState(() {
        rides = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Cabs Rides'),
        centerTitle: true,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: <Widget>[
            Container(
              color: schemecolor,
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Pending',
                  ),
                  Tab(
                    text: 'Process',
                  ),
                  Tab(
                    text: 'Completed',
                  ),
                  Tab(text: 'Cancelled'),
                  Tab(text: 'Scheduled'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Completed Tab
                  RideListView(rideStatus: 'Pending', rides: rides),
                  RideListView(rideStatus: 'Process', rides: rides),
                  RideListView(rideStatus: 'Completed', rides: rides),
                  // Canceled Tab
                  RideListView(rideStatus: 'Canceled', rides: rides),
                  // Scheduled Tab
                  RideListView(rideStatus: 'Scheduled', rides: rides),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RideListView extends StatefulWidget {
  final String rideStatus;
  final List<dynamic> rides;

  RideListView({required this.rideStatus, required this.rides});

  @override
  State<RideListView> createState() => _RideListViewState();
}

class _RideListViewState extends State<RideListView> {
  bool _loading = false;

  Future<void> postData(String rideid, String status) async {
    var url =
        'https://13gocabs.com.au/api/Hdl_UpdateRideStatus.ashx'; // Replace with your API endpoint URL
    var response = await http.post(Uri.parse(url), body: {
      'rideid': rideid,
      'status': status,
    });

    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      print('Post request successful');
    } else {
      setState(() {
        _loading = false;
      });
      showSnackbar('Something went wrong please try again.', context,
          Color.fromARGB(255, 255, 17, 0), Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredRides = widget.rides
        .where((ride) => ride['ridestatus'] == widget.rideStatus)
        .toList();
    return OverlayLoaderWithAppIcon(
      overlayBackgroundColor: Colors.black,
      circularProgressColor: schemecolor,
      overlayOpacity: 0.5,
      isLoading: _loading,
      appIcon: Image.asset('assets/images/logo.png'),
      child: ListView.builder(
        itemCount: filteredRides.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        child: Image.asset(
                          'assets/images/user.png',
                          color: schemecolor,
                        ), // Replace with your image
                        radius: 40.0,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'RideID : ${filteredRides[index]['rideid']}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${filteredRides[index]['name']}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ).pOnly(top: 4, bottom: 4),
                            Text(
                              'From: ${filteredRides[index]['pickup']}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'To: ${filteredRides[index]['dropoff']}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: <Widget>[
                                Icon(CupertinoIcons.calendar),
                                SizedBox(width: 4.0),
                                Text(filteredRides[index]['pickupdate']),
                                SizedBox(width: 16.0),
                                Icon(Icons.access_time),
                                SizedBox(width: 4.0),
                                Text(filteredRides[index]['pickuptime']),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons
                                    .directions_car), // Custom icon for available seats
                                SizedBox(width: 4.0),
                                Text(
                                    'Ride Status : ${filteredRides[index]['ridestatus']}'), // Display available seats count
                                SizedBox(width: 16.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  filteredRides[index]['ridestatus'] == 'Pending'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0)),
                                onPressed: () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  postData('4', 'Process');
                                },
                                child: Text('Accept'),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: Color.fromARGB(255, 255, 17,
                                      0), // Set background color here
                                ),
                                onPressed: () async {},
                                child: Text('Reject'),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: null,
                            child: Text(filteredRides[index]['ridestatus']),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
