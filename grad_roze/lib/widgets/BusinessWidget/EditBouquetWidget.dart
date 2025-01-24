import 'dart:convert';

import 'package:chips_input_autocomplete/chips_input_autocomplete.dart';

import '/custom/animations.dart';
import '/custom/count_controller.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '/custom/util.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import image picker
import '/config.dart' show url;

import 'editBouquetModel.dart';
export 'editBouquetModel.dart';

class EditBouquetWidget extends StatefulWidget {
  const EditBouquetWidget({
    super.key,
    required this.bouquetId,
    required this.bouquetDetails,
    required this.business,
    this.onUpdated,
    this.onUpdatedrefresh,
  });

  final String bouquetId;
  final dynamic bouquetDetails;
  final String business;
  final VoidCallback? onUpdated;
  final Function? onUpdatedrefresh; // Accept the callback function

  @override
  State<EditBouquetWidget> createState() => _EditBouquetWidgetState();
}

class _EditBouquetWidgetState extends State<EditBouquetWidget>
    with TickerProviderStateMixin {
  late EditBouquetModel _model;
  List<String> colors = [];
  List<String> selectedColors = [];
  List<String> tags = [];
  List<String> selectedTags = [];
  List<String> flowerTypes = [];
  List<String> selectedFlowerTypes = [];
  File? _selectedImage;

  final picker = ImagePicker();
  final ChipsAutocompleteController controller = ChipsAutocompleteController();
  final ChipsAutocompleteController flowerTypesController =
      ChipsAutocompleteController();
  final ChipsAutocompleteController tagsController =
      ChipsAutocompleteController();
  final animationsMap = <String, AnimationInfo>{};
  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditBouquetModel());
    final bouquet = widget.bouquetDetails as Map<String, dynamic>? ?? {};

    // Initialize text controllers
    _model.flowerTypeTextController =
        TextEditingController(text: bouquet['name']);
    _model.descTextController =
        TextEditingController(text: bouquet['description']);
    _model.careTipsTextController =
        TextEditingController(text: bouquet['careTips']);
    _model.quantityValue = bouquet['price'];

    // Parse colors, tags, and flower types from bouquet
    selectedColors = bouquet['color'] is String
        ? (bouquet['color'] as String).split(',')
        : List<String>.from(bouquet['color'] ?? []);
    selectedTags = bouquet['tags'] is String
        ? (bouquet['tags'] as String).split(',')
        : List<String>.from(bouquet['tags'] ?? []);
    selectedFlowerTypes = bouquet['flowerType'] is String
        ? (bouquet['flowerType'] as String).split(',')
        : List<String>.from(bouquet['flowerType'] ?? []);

    // Delay setting the chips to ensure controllers are initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        controller.chips = List<String>.from(selectedColors);
        tagsController.chips = List<String>.from(selectedTags);
        flowerTypesController.chips = List<String>.from(selectedFlowerTypes);
      });
    });

    // Fetch options for autocomplete
    fetchColorsAndSetState();
    fetchFlowerTypesAndSetState();
    fetchTagsAndSetState();

    // Set listeners for the autocomplete controllers
    controller.addListener(() {
      setState(() {
        selectedColors = controller.chips;
      });
    });

    flowerTypesController.addListener(() {
      setState(() {
        selectedFlowerTypes = flowerTypesController.chips;
      });
    });

    tagsController.addListener(() {
      setState(() {
        selectedTags = tagsController.chips;
      });
    });

    // Setup animations
    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 250.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 250.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 70.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  Future<void> fetchColorsAndSetState() async {
    try {
      final fetchedColors = await fetchColors();
      setState(() {
        colors = fetchedColors;
      });
    } catch (e) {
      print('Error fetching colors: $e');
    }
  }

  Future<void> fetchFlowerTypesAndSetState() async {
    try {
      final fetchedFlowerTypes = await fetchFlowerTypes();
      setState(() {
        flowerTypes = fetchedFlowerTypes;
      });
    } catch (e) {
      print('Error fetching FlowerTypes: $e');
    }
  }

  Future<void> fetchTagsAndSetState() async {
    try {
      final fetchedTags = await fetchTags();
      setState(() {
        tags = fetchedTags;
      });
    } catch (e) {
      print('Error fetching Tags: $e');
    }
  }

  Future<List<String>> fetchColors() async {
    final Uri apiUrl = Uri.parse('$url/colors/colors');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => item['color'] as String).toList();
    }
    throw Exception('Failed to fetch colors');
  }

  Future<List<String>> fetchFlowerTypes() async {
    final Uri apiUrl = Uri.parse('$url/flowerTypes/flowerTypes');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => item['flowerType'] as String).toList();
    }
    throw Exception('Failed to fetch FlowerTypes');
  }

  Future<List<String>> fetchTags() async {
    final Uri apiUrl = Uri.parse('$url/tags/tags');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => item['tag'] as String).toList();
    }
    throw Exception('Failed to fetch Tags');
  }

  Future<void> getColorsOptions() async {
    controller.options = await fetchColors();
  }

  Future<void> getFlowerTypesOptions() async {
    flowerTypesController.options = await fetchFlowerTypes();
  }

  Future<void> getTagsOptions() async {
    tagsController.options = await fetchTags();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _updateBouquet() async {
    final String id = widget.bouquetId; // Replace with the actual item ID

    String name = _model.flowerTypeTextController.text;
    String color = jsonEncode(selectedColors);
    String flowerType = jsonEncode(selectedFlowerTypes);
    String tags = jsonEncode(selectedTags);
    String description = _model.descTextController.text.trim();
    String careTips = _model.careTipsTextController.text.trim();
    String price = (_model.quantityValue ?? 0).toString();

    final apiurl = Uri.parse('$url/item/update/$id');
    var request = http.MultipartRequest('PUT', apiurl);

    if (name.isNotEmpty) request.fields['name'] = name;
    if (color.isNotEmpty) request.fields['color'] = color;
    if (flowerType.isNotEmpty) request.fields['flowerType'] = flowerType;
    if (tags.isNotEmpty) request.fields['tags'] = tags;
    if (description.isNotEmpty) request.fields['description'] = description;
    if (careTips.isNotEmpty) request.fields['careTips'] = careTips;
    if (price.isNotEmpty) request.fields['price'] = price;
    if (_image != null) {
      // Check and split MIME type
      final mimeTypeData = lookupMimeType('', headerBytes: _image!)?.split('/');
      request.files.add(
        http.MultipartFile.fromBytes(
          'imageURL',
          _image!,
          contentType: mimeTypeData != null
              ? MediaType(mimeTypeData[0], mimeTypeData[1])
              : MediaType('image', 'jpeg'), // Default to jpeg
          filename: 'item.jpg',
        ),
      );
    } else {
      // Show an error if the image is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected for upload')),
      );
      return; // Exit the function early
    }

    try {
      // Sending the request
      final response = await request.send();

      if (response.statusCode == 200) {
        if (widget.onUpdatedrefresh != null) {
          widget.onUpdatedrefresh!();
        }
        // If the server returns a success response
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User updated successfully!'),
        ));
        Navigator.pop(context);
      } else {
        // If the server returns an error
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${data['message']}'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 4,
      ),
      child: SingleChildScrollView(
        // Added SingleChildScrollVie
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).accent4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 670),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 3,
                        color: Color(0x33000000),
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Update Bouquet',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Please enter the flower info below',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30,
                                      borderWidth: 1,
                                      buttonSize: 60,
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await Future.delayed(
                                            const Duration(seconds: 2));

                                        // Trigger the onAdded callback if provided
                                        if (widget.onUpdated != null) {
                                          widget.onUpdated!();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Image Picker Section
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: _image != null
                                            ? MemoryImage(_image!)
                                            : const AssetImage(
                                                'assets/images/defaults/bouquet.png',
                                              ) as ImageProvider,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 8,
                                          buttonSize: 50,
                                          icon: Icon(
                                            Icons.add_a_photo_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 30,
                                          ),
                                          onPressed: selectImage,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _model.flowerTypeTextController,
                                  focusNode: _model.flowerTypeFocusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Bouquet Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Dropdown for Colors
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 500),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16.0,
                                              ),
                                              child: Text(
                                                'COLORS: Only colors appeared allowed',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge,
                                              ),
                                            ),
                                          ),
                                          ChipsInputAutocomplete(
                                              widgetContainerDecoration:
                                                  BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 3,
                                                    color: Color(0x33000000),
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1,
                                                ),
                                              ),
                                              createCharacter: " ",
                                              validateInputMethod:
                                                  (String? input) {
                                                if (colors.contains(input)) {
                                                  return null; // Input is valid
                                                } else {
                                                  return 'Only predefined options are allowed'; // Input is invalid
                                                }
                                              },
                                              controller: controller),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Dropdown for Colors
                                Card(
                                  //for flowerTypes
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 500),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16.0,
                                              ),
                                              child: Text(
                                                'flowerTypes: Only Types appeared allowed',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge,
                                              ),
                                            ),
                                          ),
                                          ChipsInputAutocomplete(
                                              widgetContainerDecoration:
                                                  BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 3,
                                                    color: Color(0x33000000),
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1,
                                                ),
                                              ),
                                              createCharacter: " ",
                                              validateInputMethod:
                                                  (String? input) {
                                                if (flowerTypes
                                                    .contains(input)) {
                                                  return null; // Input is valid
                                                } else {
                                                  return 'Only predefined options are allowed'; // Input is invalid
                                                }
                                              },
                                              controller:
                                                  flowerTypesController),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  //for tags
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 500),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16.0,
                                              ),
                                              child: Text(
                                                'TAGS: Only Tags appeared allowed',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge,
                                              ),
                                            ),
                                          ),
                                          ChipsInputAutocomplete(
                                              widgetContainerDecoration:
                                                  BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 3,
                                                    color: Color(0x33000000),
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1,
                                                ),
                                              ),
                                              createCharacter: " ",
                                              validateInputMethod:
                                                  (String? input) {
                                                if (tags.contains(input)) {
                                                  return null; // Input is valid
                                                } else {
                                                  return 'Only predefined options are allowed'; // Input is invalid
                                                }
                                              },
                                              controller: tagsController),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _model.descTextController,
                                  focusNode: _model.descFocusNode,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _model.careTipsTextController,
                                  focusNode: _model.careTipsFocusNode,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'Care Tips',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Price:',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                    const SizedBox(width: 16),
                                    FlutterFlowCountController(
                                      decrementIconBuilder: (enabled) => Icon(
                                        Icons.remove_rounded,
                                        color: enabled
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : FlutterFlowTheme.of(context)
                                                .alternate,
                                      ),
                                      incrementIconBuilder: (enabled) => Icon(
                                        Icons.add_rounded,
                                        color: enabled
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : FlutterFlowTheme.of(context)
                                                .alternate,
                                      ),
                                      countBuilder: (count) => Text(
                                        count.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge,
                                      ),
                                      count: _model.quantityValue ??= 50,
                                      updateCount: (count) {
                                        setState(() {
                                          _model.quantityValue = count;
                                        });
                                      },
                                      stepSize: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _updateBouquet();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 32),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    child: Text('Update'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation2']!,
                  ),
                ),
              ),
            ],
          ),
        ).animateOnPageLoad(
          animationsMap['containerOnPageLoadAnimation1']!,
        ),
      ),
    )));
  }
}
