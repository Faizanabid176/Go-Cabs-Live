class Ride {
  final int rideId;
  final String name;
  final String phoneNo;
  final int noOfPassengers;
  final String pickup;
  final String dropoff;
  final String carType;
  final String pickupDate;
  final String pickupTime;
  final String rideStatus;
  final int activeIndex;

  Ride({
    required this.rideId,
    required this.name,
    required this.phoneNo,
    required this.noOfPassengers,
    required this.pickup,
    required this.dropoff,
    required this.carType,
    required this.pickupDate,
    required this.pickupTime,
    required this.rideStatus,
    required this.activeIndex,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideId: json['rideid'],
      name: json['name'],
      phoneNo: json['phoneno'],
      noOfPassengers: json['noofpassenger'],
      pickup: json['pickup'],
      dropoff: json['dropoff'],
      carType: json['cartype'],
      pickupDate: json['pickupdate'],
      pickupTime: json['pickuptime'],
      rideStatus: json['ridestatus'],
      activeIndex: json['activeindex'],
    );
  }
}
