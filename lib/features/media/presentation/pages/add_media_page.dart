import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/textfieldcard.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/media/presentation/bloc/media_bloc.dart';

class AddMediaPage extends StatefulWidget {
  final UserDataEntity user;
  const AddMediaPage({super.key, required this.user});

  @override
  State<AddMediaPage> createState() => _AddMediaPageState();
}

class _AddMediaPageState extends State<AddMediaPage> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  String? _imageError;
  bool _isPickingImage = false;
  String _imageTitle = "";
  String _imageDescription = "";

  String _videoUrl = "";
  String _videoTitle = "";
  String _videoDescription = "";

  PlatformFile? _selectedDocument;
  String? _documentError;
  bool _isPickingDocument = false;
  String _documentTitle = "";
  String _documentDescription = "";

  Future<void> _pickImage() async {
    if (_isPickingImage) {
      return;
    }

    setState(() {
      _isPickingImage = true;
      _imageError = null;
    });

    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (!mounted) {
        return;
      }

      if (picked == null) {
        setState(() {
          _isPickingImage = false;
        });
        return;
      }

      final String nameLower = picked.name.toLowerCase();
      final bool isAllowedType =
          nameLower.endsWith('.jpg') ||
          nameLower.endsWith('.jpeg') ||
          nameLower.endsWith('.png');
      if (!isAllowedType) {
        setState(() {
          _selectedImage = null;
          _imageError = 'Only JPEG or PNG images are allowed.';
          _isPickingImage = false;
        });
        return;
      }

      final int sizeBytes = await picked.length();
      if (sizeBytes > 5 * 1024 * 1024) {
        setState(() {
          _selectedImage = null;
          _imageError = 'Image must be 5 MB or smaller.';
          _isPickingImage = false;
        });
        return;
      }

      setState(() {
        _selectedImage = picked;
        _isPickingImage = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedImage = null;
        _imageError = 'Unable to pick image.';
        _isPickingImage = false;
      });
    }
  }

  Future<void> _pickDocument() async {
    if (_isPickingDocument) {
      return;
    }

    setState(() {
      _isPickingDocument = true;
      _documentError = null;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (!mounted) {
        return;
      }

      if (result == null) {
        setState(() {
          _isPickingDocument = false;
        });
        return;
      }

      final PlatformFile file = result.files.first;

      final String nameLower = file.name.toLowerCase();
      final bool isAllowedType =
          nameLower.endsWith('.pdf') ||
          nameLower.endsWith('.doc') ||
          nameLower.endsWith('.docx');
      if (!isAllowedType) {
        setState(() {
          _selectedDocument = null;
          _documentError = 'Only PDF, DOC, or DOCX documents are allowed.';
          _isPickingDocument = false;
        });
        return;
      }

      final int sizeBytes = file.size;
      if (sizeBytes > 5 * 1024 * 1024) {
        setState(() {
          _selectedDocument = null;
          _documentError = 'Document must be 5 MB or smaller.';
          _isPickingDocument = false;
        });
        return;
      }

      setState(() {
        _selectedDocument = file;
        _isPickingDocument = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedDocument = null;
        _documentError = 'Unable to pick document.';
        _isPickingDocument = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          const Wallpaper(),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(90),
              child: Appbar(user: widget.user),
            ),

            body: SafeArea(
              top: false,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Gallery",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                      ),
                                ),
                                Spacer(),
                                Text(
                                  "0/50 Images • 1/30 Video links",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: 10,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Upload up to 50 images (max 5 MB each). Add up to 30 video links to showcase your work.",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          indicatorAnimation: TabIndicatorAnimation.elastic,
                          indicator: BoxDecoration(
                            color: AppColors.cardSecondaryBg,
                            border: Border.all(
                              color: AppColors.cardSecondaryBorder,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelColor: AppColors.primaryBlue,
                          labelStyle: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 12),

                          unselectedLabelColor: AppColors.textPrimary,
                          unselectedLabelStyle: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 12),
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined, size: 17),
                                  SizedBox(width: 5),
                                  Text("Images"),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.video_collection_outlined,
                                    size: 17,
                                  ),
                                  SizedBox(width: 5),
                                  Text("Videos"),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.document_scanner, size: 17),
                                  SizedBox(width: 5),
                                  Text("Docs"),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// ✅ ONLY THIS SCROLLS
                        Expanded(
                          child: TabBarView(
                            children: [
                              /// TAB 1
                              _uploadImageTab(),

                              /// TAB 2
                              _uploadVideoTab(),

                              /// TAB 3
                              _uploadDocumentTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    if (_isPickingImage && _selectedImage == null) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primaryBlue,
        ),
      );
    } else if (_selectedImage != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 18, color: AppColors.primaryBlue),
          SizedBox(width: 6),
          Text(
            "Uploaded: ${_selectedImage!.name}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.upload, size: 30, color: AppColors.iconPrimary),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Upload Images",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "JPEG, PNG formats, up to 2 MB",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentUploadButton() {
    if (_isPickingDocument && _selectedDocument == null) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primaryBlue,
        ),
      );
    } else if (_selectedDocument != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 18, color: AppColors.primaryBlue),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              "Selected: ${_selectedDocument!.name}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.upload_file, size: 30, color: AppColors.iconPrimary),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Upload Documents",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "PDF, DOC, DOCX formats, up to 10 MB",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _uploadImageTab() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: _isPickingImage ? null : _pickImage,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.cardSecondaryBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 3,
                  style: BorderStyle.solid,
                  color: AppColors.cardSecondaryBorder,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildUploadButton(),
              ),
            ),
          ),
          if (_imageError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 6),
              child: Text(
                _imageError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.redAccent,
                  fontSize: 11,
                ),
              ),
            ),
          SizedBox(height: 20),
          TextFieldCard(
            label: "Title (optional)",
            value: _imageTitle,
            icon: Icons.title,
            onSave: (value) {
              setState(() {
                _imageTitle = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFieldCard(
            label: "Description (optional)",
            value: _imageDescription,
            icon: Icons.description,
            onSave: (value) {
              setState(() {
                _imageDescription = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_selectedImage != null) {
                context.read<MediaBloc>().add(
                  AddImageEvent(
                    title: _imageTitle,
                    description: _imageDescription,
                    imagePath: _selectedImage?.path ?? "",
                  ),
                );

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please select an image to upload.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },

            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryBlue),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            child: BlocBuilder<MediaBloc, MediaState>(
              builder: (BuildContext context, MediaState state) {
                if (state is AddingImageState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.surfacePrimary,
                    ),
                  );
                }
                return Text(
                  "Upload",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadVideoTab() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFieldCard(
            label: "Video url",
            value: _videoUrl,
            icon: Icons.link,
            onSave: (value) {
              setState(() {
                _videoUrl = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFieldCard(
            label: "Title (optional)",
            value: _videoTitle,
            icon: Icons.title,
            onSave: (value) {
              setState(() {
                _videoTitle = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFieldCard(
            label: "Description (optional)",
            value: _videoDescription,
            icon: Icons.description,
            onSave: (value) {
              setState(() {
                _videoDescription = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_videoUrl.trim().isNotEmpty) {
                context.read<MediaBloc>().add(
                  AddVideoEvent(
                    title: _videoTitle,
                    description: _videoDescription,
                    videoUrl: _videoUrl.trim(),
                  ),
                );

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please add a video url to upload.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },

            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryBlue),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            child: BlocBuilder<MediaBloc, MediaState>(
              builder: (BuildContext context, MediaState state) {
                if (state is AddingImageState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.surfacePrimary,
                    ),
                  );
                }
                return Text(
                  "Upload",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadDocumentTab() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: _isPickingDocument ? null : _pickDocument,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.cardSecondaryBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 3,
                  style: BorderStyle.solid,
                  color: AppColors.cardSecondaryBorder,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildDocumentUploadButton(),
              ),
            ),
          ),
          if (_documentError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 6),
              child: Text(
                _documentError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.redAccent,
                  fontSize: 11,
                ),
              ),
            ),
          SizedBox(height: 20),
          TextFieldCard(
            label: "Title (optional)",
            value: _documentTitle,
            icon: Icons.title,
            onSave: (value) {
              setState(() {
                _documentTitle = value;
              });
            },
          ),
          SizedBox(height: 20),
          TextFieldCard(
            label: "Description (optional)",
            value: _documentDescription,
            icon: Icons.description,
            onSave: (value) {
              setState(() {
                _documentDescription = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_selectedDocument != null) {
                context.read<MediaBloc>().add(
                  AddDocumentEvent(
                    title: _documentTitle,
                    description: _documentDescription,
                    documentPath: _selectedDocument?.path ?? "",
                  ),
                );

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please select a document to upload.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },

            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryBlue),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            child: BlocBuilder<MediaBloc, MediaState>(
              builder: (BuildContext context, MediaState state) {
                if (state is AddingDocumentState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.surfacePrimary,
                    ),
                  );
                }
                return Text(
                  "Upload",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
