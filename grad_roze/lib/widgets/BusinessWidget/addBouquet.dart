import 'package:chips_input_autocomplete/chips_input_autocomplete.dart';

import '/custom/animations.dart';
import '/custom/count_controller.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import image picker
import '/config.dart' show url;
import 'addBouquetModel.dart';
export 'addBouquetModel.dart';

class AddBouquetWidget extends StatefulWidget {
  const AddBouquetWidget({super.key, required this.business, this.onAdded});
  final String business;
  final VoidCallback? onAdded;
  @override
  State<AddBouquetWidget> createState() => _AddBouquetWidgetState();
}

class _AddBouquetWidgetState extends State<AddBouquetWidget>
    with TickerProviderStateMixin {
  late AddBouquetModel _model;
  List<String> colors = []; // List of colors fetched from the API
  List<String> selectedColors = [];
  List<String> tags = []; // List of colors fetched from the API
  List<String> selectedTags = [];
  List<String> flowerTypes = []; // List of colors fetched from the API
  List<String> selectedFlowerTypes = [];
  File? _selectedImage; // Store the selected image
  final picker = ImagePicker(); // ImagePicker instance
  final animationsMap = <String, AnimationInfo>{};
  final ChipsAutocompleteController controller = ChipsAutocompleteController();
  String chipsOutputExampleOnlyOptions = '';
  final ChipsAutocompleteController flowerTypesController =
      ChipsAutocompleteController();
  String chipsOutputFlowerTypes = '';
  final ChipsAutocompleteController tagsController =
      ChipsAutocompleteController();
  String chipsOutputTags = '';
  @override
  void initState() {
    super.initState();
    fetchFlowerTypesAndSetState(); // Fetch colors on init
    getFlowerTypesOptions();
    fetchColorsAndSetState(); // Fetch colors on init
    getColorsOptions();
    fetchTagsAndSetState(); // Fetch colors on init
    getTagsOptions();
    _model = createModel(context, () => AddBouquetModel());

    // Initialize controllers and focus nodes
    _model.flowerTypeTextController ??= TextEditingController();
    _model.flowerTypeFocusNode ??= FocusNode();

    _model.colorTextController ??= TextEditingController();
    _model.colorFocusNode ??= FocusNode();

    _model.descTextController ??= TextEditingController();
    _model.descFocusNode ??= FocusNode();

    _model.careTipsTextController ??= TextEditingController();
    _model.careTipsFocusNode ??= FocusNode();

    // Add animations
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
    controller.addListener(() {
      setState(() {
        chipsOutputExampleOnlyOptions = controller.chips.join(', ');
        selectedColors = controller.chips;
      });
    });
    flowerTypesController.addListener(() {
      setState(() {
        chipsOutputFlowerTypes = flowerTypesController.chips.join(', ');
        selectedFlowerTypes = flowerTypesController.chips;
      });
    });
    tagsController.addListener(() {
      setState(() {
        chipsOutputTags = tagsController.chips.join(', ');
        selectedTags = tagsController.chips;
      });
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  // add bouquets

  Future<void> fetchColorsAndSetState() async {
    try {
      final fetchedColors = await fetchColors();
      setState(() {
        colors = fetchedColors; // Update the state with fetched colors
      });
    } catch (e) {
      print('Error fetching colors: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load colors. Please try again.')),
      );
    }
  }

  Future<void> fetchFlowerTypesAndSetState() async {
    try {
      final fetchedFlowerTypes = await fetchFlowerTypes();
      setState(() {
        flowerTypes =
            fetchedFlowerTypes; // Update the state with fetched FlowerTypes
      });
    } catch (e) {
      print('Error fetching FlowerTypes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load FlowerTypes. Please try again.')),
      );
    }
  }

  Future<void> fetchTagsAndSetState() async {
    try {
      final fetchedTags = await fetchTags();
      setState(() {
        tags = fetchedTags; // Update the state with fetched FlowerTypes
      });
    } catch (e) {
      print('Error fetching Tags: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Tags. Please try again.')),
      );
    }
  }

  Future<List<String>> fetchTags() async {
    try {
      final Uri apiUrl = Uri.parse('$url/tags/tags'); // Full API URL
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => item['tag'] as String).toList();
      } else {
        throw Exception(
            'Failed to fetch Tags. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Tags: $e');
    }
  }

  Future<List<String>> fetchFlowerTypes() async {
    try {
      final Uri apiUrl =
          Uri.parse('$url/flowerTypes/flowerTypes'); // Full API URL
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => item['flowerType'] as String).toList();
      } else {
        throw Exception(
            'Failed to fetch FlowerTypes. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching FlowerTypes: $e');
    }
  }

  Future<List<String>> fetchColors() async {
    try {
      final Uri apiUrl = Uri.parse('$url/colors/colors'); // Full API URL
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => item['color'] as String).toList();
      } else {
        throw Exception(
            'Failed to fetch colors. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching colors: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Store selected image
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> getTagsOptions() async {
    tagsController.options = await fetchTags();
  }

  Future<void> getColorsOptions() async {
    controller.options = await fetchColors();
  }

  Future<void> getFlowerTypesOptions() async {
    flowerTypesController.options = await fetchFlowerTypes();
  }

  Future<void> _addBouquet() async {
    final Uri apiUrl = Uri.parse('$url/item/addItem');

    try {
      final request = http.MultipartRequest('POST', apiUrl);

      // Adding text fields to the request
      request.fields['name'] = _model.flowerTypeTextController.text.trim();
      request.fields['description'] = _model.descTextController.text.trim();
      request.fields['price'] = _model.quantityValue.toString();
      request.fields['careTips'] = _model.careTipsTextController.text.trim();
      request.fields['business'] = widget.business;

      // Adding arrays as JSON strings
      request.fields['tags'] = selectedTags.join(',');
      request.fields['color'] = selectedColors.join(',');
      request.fields['flowerType'] = selectedFlowerTypes.join(',');

      // Adding image file if selected
      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
              'image', _selectedImage!.path), // Ensure field name matches
        );
      } else {
        request.fields['useDefaultImage'] = 'true';
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        final responseData = jsonDecode(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')),
        );
        Navigator.pop(context); // Close the form after success
      } else {
        final responseData = jsonDecode(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${responseData['message']}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    _model.flowerTypeFocusNode?.dispose();
    _model.colorFocusNode?.dispose();
    _model.descFocusNode?.dispose();
    _model.careTipsFocusNode?.dispose();
    super.dispose();
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
                                            'Add Bouquet',
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
                                        if (widget.onAdded != null) {
                                          widget.onAdded!();
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
                                        backgroundImage: _selectedImage != null
                                            ? FileImage(_selectedImage!)
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
                                          onPressed: _pickImage,
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
                                      _addBouquet();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 32),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    child: Text('Add'),
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
