import 'package:flutter/material.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/widgets/Bouquet/BouquetViewModel.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/widgets/Bouquet/BouquetViewWidget.dart';
import '../../widgets/MomentsModel.dart';
export '../../widgets/MomentsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart' show url;

class MomentPageWidget extends StatefulWidget {
  final MomentsModel moment;

  const MomentPageWidget({super.key, required this.moment});

  @override
  State<MomentPageWidget> createState() => _MomentPageWidgetState();
}

class _MomentPageWidgetState extends State<MomentPageWidget> {
  late Future<List<BouquetViewModel>> _futureBouquets;

  @override
  void initState() {
    super.initState();
    _futureBouquets = fetchBouquets(); // Fetch data when the page initializes
  }

  Future<List<BouquetViewModel>> fetchBouquets() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$url/item/items/tag/${widget.moment.text}',
        ),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        // Return an empty list if the response is empty or invalid
        if (jsonResponse.isEmpty) {
          return [];
        }

        return jsonResponse
            .map((data) => BouquetViewModel.fromJson(data))
            .toList();
      } else {
        print('Failed to load bouquets: Status Code ${response.statusCode}');
        print('Response body: ${response.body}');
        return []; // Return empty list instead of throwing an exception
      }
    } catch (e) {
      print('Error fetching bouquets: $e');
      return []; // Return empty list in case of any error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          widget.moment.text, // Use the moment's name here
          style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'Funnel Display',
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color:
              FlutterFlowTheme.of(context).primary, // Set the back icon color
        ),
      ),
      body: FutureBuilder<List<BouquetViewModel>>(
        future: _futureBouquets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bouquets available'));
          } else {
            final bouquets = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                  childAspectRatio: 1.0, // Aspect ratio for each item
                ),
                itemCount: bouquets.length,
                itemBuilder: (context, index) {
                  final bouquet = bouquets[index];
                  return BouquetViewWidget(
                      model:
                          bouquet); // Use BouquetViewWidget for each grid item
                },
              ),
            );
          }
        },
      ),
    );
  }
}
