import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gocabs_live/config.dart';
import 'package:gocabs_live/widgets/snackbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  List<dynamic> rides = [];
  bool _loading = false;

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
    return OverlayLoaderWithAppIcon(
      overlayBackgroundColor: Colors.black,
      circularProgressColor: schemecolor,
      overlayOpacity: 0.5,
      isLoading: _loading,
      appIcon: Image.asset('assets/images/logo.png'),
      child: Scaffold(
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
                    RideListView(
                      rideStatus: 'Pending',
                      rides: rides,
                      setLoading: _setLoading,
                      context: context,
                      onDataPosted: fetchData,
                    ),
                    RideListView(
                      rideStatus: 'Process',
                      rides: rides,
                      setLoading: _setLoading,
                      context: context,
                      onDataPosted: fetchData,
                    ),
                    RideListView(
                      rideStatus: 'Completed',
                      rides: rides,
                      setLoading: _setLoading,
                      context: context,
                      onDataPosted: fetchData,
                    ),
                    RideListView(
                      rideStatus: 'Canceled',
                      rides: rides,
                      setLoading: _setLoading,
                      context: context,
                      onDataPosted: fetchData,
                    ),
                    RideListView(
                      rideStatus: 'Scheduled',
                      rides: rides,
                      setLoading: _setLoading,
                      context: context,
                      onDataPosted: fetchData,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }
}

class RideListView extends StatelessWidget {
  final String rideStatus;
  final List<dynamic> rides;
  final Function(bool) setLoading;
  final BuildContext context;
  final Function() onDataPosted;

  RideListView(
      {required this.rideStatus,
      required this.rides,
      required this.setLoading,
      required this.context,
      required this.onDataPosted});

  Future<void> postData(String rideid, String status) async {
    var url = 'https://13gocabs.com.au/api/Hdl_UpdateRideStatus.ashx';
    var response = await http.post(Uri.parse(url), body: {
      'rideid': rideid,
      'status': status,
    });

    if (response.statusCode == 200) {
      setLoading(false);
      print('Post request successful');
      onDataPosted();
    } else {
      setLoading(false);
      showSnackbar('Something went wrong please try again', context,
          Color.fromARGB(255, 255, 17, 0), Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredRides =
        rides.where((ride) => ride['ridestatus'] == rideStatus).toList();
    return ListView.builder(
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
                          ).pOnly(top: 4),
                          Text(
                            'Contact : ${filteredRides[index]['phoneno']}',
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
                              Icon(Icons.info_outline),
                              SizedBox(width: 4.0),
                              Text('${filteredRides[index]['ridestatus']}'),
                              SizedBox(width: 16.0),
                              Icon(Icons.directions_car),
                              SizedBox(width: 4.0),
                              Text('${filteredRides[index]['cartype']}'),
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
                                setLoading(true);
                                await postData(
                                    filteredRides[index]['rideid'].toString(),
                                    'Process');
                                setLoading(false);
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
                                primary: Color.fromARGB(255, 255, 17, 0),
                              ),
                              onPressed: () async {
                                setLoading(true);
                                await postData(
                                    filteredRides[index]['rideid'].toString(),
                                    'Canceled');
                                setLoading(false);
                              },
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
    );
  }
}
