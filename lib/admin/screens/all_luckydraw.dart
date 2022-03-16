import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qb_admin/admin/classes/all_lucky_draws.dart';
import 'package:qb_admin/blocs/luckydraw/luckydraw_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

String dropdownValue = 'all';

class LuckyDraws extends StatefulWidget {
  const LuckyDraws({Key? key}) : super(key: key);

  @override
  _LuckyDrawsState createState() => _LuckyDrawsState();
}

class _LuckyDrawsState extends State<LuckyDraws> {
  GlobalKey _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('QISMAT DRAW'),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: DropdownButton(
                  dropdownColor: Colors.black,
                  elevation: 0,
                  value: dropdownValue,
                  items: ['all', 'active', 'expired'].map((map) {
                    return DropdownMenuItem<String>(
                      value: map.toString(),
                      child: Text(
                        map,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue as String;
                    });
                  }),
            )
          ]),
      body:
          BlocBuilder<LuckyDrawBloc, LuckyDrawState>(builder: (context, state) {
        if (state is LuckyDrawLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.brown,
            ),
          );
        }
        if (state is LuckyDrawLoaded) {
          return SfDataGrid(
            source:
                LuckyDrawDataSource(luckyDraw: state.draw, context: context),
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.both,
            sortingGestureType: SortingGestureType.tap,
            allowTriStateSorting: true,
            columns: <GridColumn>[
              GridColumn(
                columnName: 'name',
                label: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'product Id',
                label: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Product Id',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Visit Product',
                label: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Visit Product',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'price',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Price',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Discount',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Discount (%)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'date',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Remaining Time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'isActive',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Availability Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'Winner',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Select Winner',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'End Draw',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'End Lucky draw',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text('Unable to load data. Please try again later.'),
          );
        }
      }),
    );
  }
}
