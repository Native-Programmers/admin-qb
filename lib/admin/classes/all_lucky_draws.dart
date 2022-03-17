import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qb_admin/models/luckydraw.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

class LuckyDrawDataSource extends DataGridSource {
  BuildContext context;
  LuckyDrawDataSource({
    required List<LuckyDraw> luckyDraw,
    required this.context,
  }) {
    _luckyDrawData = luckyDraw
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<Widget>(columnName: 'name', value: Text(e.name)),
            DataGridCell<Widget>(
                columnName: 'product price', value: Text(e.productId)),
            DataGridCell<Widget>(
                columnName: 'visit product',
                value: ElevatedButton(
                  child: Text('Check Product'),
                  onPressed: () async {
                    if (!await launch(
                        'https://www.qismatbazaar.com/details/${e.productId}'))
                      throw 'Could not launch www.qismatbazaar.com';
                  },
                )),
            DataGridCell<Widget>(columnName: 'charges', value: Text(e.charges)),
            DataGridCell<Widget>(
                columnName: 'discount', value: Text(e.discount.toString())),
            DataGridCell<Widget>(
                columnName: 'end date',
                value: CountdownTimer(
                  endTime: DateTime.parse(e.date.toDate().toString())
                      .millisecondsSinceEpoch,
                  widgetBuilder: (context, time) {
                    return Row(
                      children: [
                        Text(
                          '${time?.days ?? '00'}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${time?.hours ?? '00'}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${time?.min ?? '00'}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${time?.sec ?? '00'}',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                )),
            DataGridCell<Widget>(
              columnName: 'isActive',
              value: Center(child: Text(e.isActive.toString().toUpperCase())),
            ),
            DataGridCell<Widget>(
              columnName: 'Winner',
              value: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.crown,
                      size: 12,
                    ),
                    Text('Decide Winner'),
                  ],
                ),
                onPressed: () async {
                  var random = new Random();
                  final data = await FirebaseFirestore.instance
                      .collection('participants')
                      .where('draw_id', isEqualTo: e.uid)
                      .get();

                  if (data.docs.length != 0) {
                    if (e.isActive) {
                      if (e.winnerId == 'null') {
                        if (data.docs.length == 1) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => SizedBox(
                                    width: 300,
                                    child: AlertDialog(
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            focusColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Cancel',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        )
                                      ],
                                      title: Text('Single Participant'),
                                      content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                'Only one participant exists. Do you want to wait or not!'),
                                            const Divider(
                                              height: 50,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      try {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (_) =>
                                                              AlertDialog(
                                                            elevation: 0,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            content:
                                                                SpinKitCubeGrid(
                                                                    color: Colors
                                                                        .brown),
                                                          ),
                                                        );
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'luckydraw')
                                                            .doc(e.uid)
                                                            .update({
                                                          'winner': data.docs[0]
                                                              ['user_id'],
                                                        }).then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Get.snackbar(
                                                            'Success',
                                                            'Winner assigned successfully!',
                                                            backgroundColor:
                                                                Colors.green,
                                                            colorText:
                                                                Colors.white,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    0),
                                                            borderRadius: 0,
                                                          );
                                                        }).onError((error,
                                                                stackTrace) {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);

                                                          Get.snackbar(
                                                            'Error',
                                                            'Please check your internet connection!',
                                                            backgroundColor:
                                                                Colors.red,
                                                            colorText:
                                                                Colors.white,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    0),
                                                            borderRadius: 0,
                                                          );
                                                        });
                                                      } catch (e) {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Get.snackbar(
                                                          'Error',
                                                          'Please check your internet connection!',
                                                          backgroundColor:
                                                              Colors.red,
                                                          colorText:
                                                              Colors.white,
                                                          margin:
                                                              EdgeInsets.all(0),
                                                          borderRadius: 0,
                                                        );
                                                      }
                                                    },
                                                    child:
                                                        Text('Do it anyways')),
                                                ElevatedButton(
                                                    onPressed: () {},
                                                    child:
                                                        Text('Increase Time')),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ));
                        } else {
                          int a;
                          a = random.nextInt(data.docs.length - 1);
                          try {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                content: SpinKitCubeGrid(color: Colors.brown),
                              ),
                            );
                            FirebaseFirestore.instance
                                .collection('luckydraw')
                                .doc(e.uid)
                                .update({
                              'winner': data.docs[a]['user_id'],
                            }).then((value) {
                              Navigator.pop(context);
                              Get.snackbar(
                                'Success',
                                'Winner assigned successfully!',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                margin: EdgeInsets.all(0),
                                borderRadius: 0,
                              );
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);

                              Get.snackbar(
                                'Error',
                                'Please check your internet connection!',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                margin: EdgeInsets.all(0),
                                borderRadius: 0,
                              );
                            });
                          } catch (e) {
                            Navigator.pop(context);
                            Get.snackbar(
                              'Error',
                              'Please check your internet connection!',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              margin: EdgeInsets.all(0),
                              borderRadius: 0,
                            );
                          }
                        }
                      } else {
                        Get.snackbar(
                          'Error',
                          'Winner is already decided',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: EdgeInsets.all(0),
                          borderRadius: 0,
                        );
                      }
                    } else {
                      Get.snackbar(
                        'Error',
                        'Lucky Draw is inactive/expired',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(0),
                        borderRadius: 0,
                      );
                    }
                  } else {
                    Get.snackbar(
                      'Error',
                      'No participants yet!',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(0),
                      borderRadius: 0,
                    );
                  }
                },
              ),
            ),
            DataGridCell<Widget>(
              columnName: 'End',
              value: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.speaker_phone),
                    Text('Announce'),
                  ],
                ),
                onPressed: () async {
                  if (e.isActive) {
                    if (e.winnerId != 'null') {
                      try {
                        TextEditingController _linkController =
                            new TextEditingController();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => SizedBox(
                            width: 300,
                            child: AlertDialog(
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.exit_to_app,
                                      color: Colors.red,
                                      size: 12,
                                    ))
                              ],
                              elevation: 0,
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: _linkController,
                                      decoration: InputDecoration(
                                          hintText:
                                              'Paster youtube video url here!'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter url to video';
                                        }
                                        return null;
                                      },
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (!_linkController.text.isEmpty) {
                                            FirebaseFirestore.instance
                                                .collection('luckydraw')
                                                .doc(e.uid)
                                                .update({
                                              'link': _linkController.text,
                                              'date': Timestamp.now(),
                                              'isActive': false,
                                            }).then((value) {
                                              Navigator.pop(context);
                                              Get.snackbar(
                                                'Success',
                                                'Winner assigned successfully!',
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                margin: EdgeInsets.all(0),
                                                borderRadius: 0,
                                              );
                                            }).onError((error, stackTrace) {
                                              Navigator.pop(context);

                                              Get.snackbar(
                                                'Error',
                                                'Please check your internet connection!',
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                margin: EdgeInsets.all(0),
                                                borderRadius: 0,
                                              );
                                            });
                                          } else {
                                            Get.snackbar(
                                              'Error',
                                              'Please paste link before submitting!',
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                              margin: EdgeInsets.all(0),
                                              borderRadius: 0,
                                            );
                                          }
                                        },
                                        child: Text('Finalize'))
                                  ]),
                            ),
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        Get.snackbar(
                          'Error',
                          'Please check your internet connection!',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: EdgeInsets.all(0),
                          borderRadius: 0,
                        );
                      }
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please select a winner before announcement!',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(0),
                        borderRadius: 0,
                      );
                    }
                  } else {
                    Get.snackbar(
                      'Error',
                      'Lucky Draw is inactive/expired',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(0),
                      borderRadius: 0,
                    );
                  }
                },
              ),
            ),
            DataGridCell<Widget>(
              columnName: 'view Winner',
              value: Center(
                  child: ElevatedButton(
                child: Text('View Winner'),
                onPressed: () {
                  if (e.winnerId != 'null') {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text('Winner Details'),
                              content: FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('userinfo')
                                      .doc(e.winnerId)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data!.exists) {
                                      var data = snapshot.data!.data()
                                          as Map<String, dynamic>;
                                      return SizedBox(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Name : '),
                                                  Text('Mobile No :'),
                                                  Text('Email : '),
                                                  Text('City : '),
                                                  Text('Address : '),
                                                  Text('Zip Code : '),
                                                ],
                                              ),
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(data['name']),
                                                    Text(data['mobile']),
                                                    Text(data['email']),
                                                    Text(data['city']),
                                                    Text(data['address']),
                                                    Text(data['zip']),
                                                  ]),
                                            ],
                                          ));
                                    }
                                    if (!snapshot.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      return Center(
                                        child: Text('No such data exists!'),
                                      );
                                    }
                                    if (snapshot.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.done &&
                                        !snapshot.data!.exists) {
                                      return Center(
                                        child: Text(
                                            'Please ask user to update their information.'),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.brown),
                                      );
                                    } else {
                                      return Center(
                                        child: Text('Something went wrong'),
                                      );
                                    }
                                  }),
                            ));
                  } else {
                    Get.snackbar(
                      'Error',
                      'Winner not decided yet!',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(0),
                      borderRadius: 0,
                    );
                  }
                },
              )),
            ),
          ]),
        )
        .toList();
  }
  List<DataGridRow> _luckyDrawData = [];

  @override
  List<DataGridRow> get rows => _luckyDrawData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: e.value,
      );
    }).toList());
  }
}
