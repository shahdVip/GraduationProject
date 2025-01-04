import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grad_roze/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';

class AdminEditingWidget extends StatefulWidget {
  const AdminEditingWidget({super.key});

  @override
  State<AdminEditingWidget> createState() => _AdminEditingWidgetState();
}

class _AdminEditingWidgetState extends State<AdminEditingWidget> {
  List<Map<String, String>> colors = [];
  List<Map<String, String>> flowerTypes = [];
  List<Map<String, String>> moments = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final colorsResponse = await http.get(Uri.parse('$url/colors/colors'));
      final flowerTypesResponse =
          await http.get(Uri.parse('$url/flowerTypes/flowerTypes'));
      final momentsResponse = await http.get(Uri.parse('$url/moments'));

      if (colorsResponse.statusCode == 200) {
        colors = List<Map<String, String>>.from(
          jsonDecode(colorsResponse.body).map((e) => {
                "id": e['_id'].toString(),
                "name": e['color'].toString(),
              }),
        );
      }

      if (flowerTypesResponse.statusCode == 200) {
        flowerTypes = List<Map<String, String>>.from(
          jsonDecode(flowerTypesResponse.body).map((e) => {
                "id": e['_id'].toString(),
                "name": e['flowerType'].toString(),
              }),
        );
      }

      if (momentsResponse.statusCode == 200) {
        moments = List<Map<String, String>>.from(
          jsonDecode(momentsResponse.body).map((e) => {
                "id": e['_id'].toString(),
                "text": e['text'].toString(),
                "imageUrl": e['imageUrl'].toString(),
              }),
        );
      }

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> addItem(String apiUrl, Map<String, String> data, File? file,
      VoidCallback onSuccess) async {
    try {
      if (file != null) {
        // Send multipart/form-data request if a file is present (Moments case)
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

        // Add text fields
        data.forEach((key, value) {
          request.fields[key] = value;
        });

        // Determine MIME type of the file
        final mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';
        final mimeTypeSplit = mimeType.split('/');

        // Add the file with proper MIME type
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // This key must match your backend's expected key for the file
            file.path,
            contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
          ),
        );

        // Send the request
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        print('Response Status (Multipart): ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add item: ${response.body}')),
          );
        }
      } else {
        // Send application/json request for other cases (Colors, Flower Types)
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        print('Response Status (JSON): ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add item: ${response.body}')),
          );
        }
      }
    } catch (e) {
      print('Error during add request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding item: $e')),
      );
    }
  }

  Future<void> deleteItem(
      String apiUrl, String id, VoidCallback onSuccess) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted successfully')),
        );
      } else {
        print('Failed to delete item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during delete request: $e');
    }
  }

  void showAddDialog({
    required BuildContext context,
    required String title,
    required String apiUrl,
    required VoidCallback onItemAdded,
  }) {
    final TextEditingController nameController = TextEditingController();
    File? selectedImage;

    final picker = ImagePicker();

    Future<void> pickImage(Function(void Function()) dialogSetState) async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        dialogSetState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, dialogSetState) {
            return AlertDialog(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Add $title',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Funnel Display',
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 18,
                      useGoogleFonts: false,
                    ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: '$title Name',
                      labelStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Funnel Display',
                                color: FlutterFlowTheme.of(context).primary,
                                useGoogleFonts: false,
                              ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (title == 'Moments') ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        await pickImage(dialogSetState);
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Text("Tap to select an image")),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).primary,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Name cannot be empty')),
                      );
                      return;
                    }

                    if (title == 'Moments' && selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an image')),
                      );
                      return;
                    }

                    final newItem = {
                      if (title == 'Colors')
                        'color': nameController.text.trim(),
                      if (title == 'Flower Types')
                        'flowerType': nameController.text.trim(),
                      if (title == 'Moments')
                        'text': nameController.text.trim(),
                    };

                    addItem(apiUrl, newItem, selectedImage, () {
                      onItemAdded();
                      Navigator.of(dialogContext).pop();
                    });
                  },
                  child: Text(
                    'Add',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).primary,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          return false; // Prevent navigating back
        },
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            title: Text(
              'Admin Editing',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Funnel Display',
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontSize: 18,
                    useGoogleFonts: false,
                  ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                buildSection(
                  title: 'Colors',
                  items: colors,
                  deleteApi: '$url/colors/delete',
                  addApi: '$url/colors/add',
                ),
                buildSection(
                  title: 'Flower Types',
                  items: flowerTypes,
                  deleteApi: '$url/flowerTypes/delete',
                  addApi: '$url/flowerTypes/add',
                ),
                buildMomentsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<Map<String, String>> items,
    required String deleteApi,
    required String addApi,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            buildHeader(title, addApi),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((item) {
                return Opacity(
                  opacity: 0.7,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              item['name']!,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontFamily: 'Funnel Display',
                                    fontSize: 14,
                                    useGoogleFonts: false,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              deleteItem(deleteApi, item['id']!, () {
                                setState(() {
                                  items.remove(item);
                                });
                              });
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMomentsSection() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            buildHeader('Moments', '$url/moments/addMoment'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: moments.map((item) {
                // Determine the image source dynamically
                final imageUrl = item['imageUrl']!.startsWith('/')
                    ? '$url${item['imageUrl']}'
                    : item['imageUrl']!;
                final isNetworkImage = imageUrl.startsWith('http');

                return Opacity(
                  opacity: 0.7,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item['imageUrl'] != null)
                            isNetworkImage
                                ? Image.network(
                                    imageUrl, // Dynamically construct URL
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.broken_image,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    imageUrl, // Local asset path
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.broken_image,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      );
                                    },
                                  )
                          else
                            Icon(
                              Icons.image_not_supported,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              size: 20,
                            ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              item['text']!,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontFamily: 'Funnel Display',
                                    fontSize: 14,
                                    useGoogleFonts: false,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              deleteItem(
                                '$url/moments/deleteMoments',
                                item['id']!,
                                () {
                                  setState(() {
                                    moments.remove(item);
                                  });
                                },
                              );
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String title, String addApi) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: AlignmentDirectional(-1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
              child: Text(
                title,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Funnel Display',
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 18,
                      useGoogleFonts: false,
                    ),
              ),
            ),
          ),
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            buttonSize: 40,
            fillColor: FlutterFlowTheme.of(context).primary,
            icon: Icon(
              Icons.add,
              size: 24,
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            onPressed: () {
              showAddDialog(
                context: context,
                title: title,
                apiUrl: addApi,
                onItemAdded: fetchData,
              );
            },
          ),
        ],
      ),
    );
  }
}
