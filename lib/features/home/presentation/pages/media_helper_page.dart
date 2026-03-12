import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/media/presentation/bloc/media_bloc.dart';
import 'package:qr_folio/features/media/presentation/pages/media_page.dart';

class MediaHelperPage extends StatefulWidget {
  final UserDataEntity user;
  const MediaHelperPage({super.key, required this.user});

  @override
  State<MediaHelperPage> createState() => _MediaHelperPageState();
}

class _MediaHelperPageState extends State<MediaHelperPage> {
  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(FetchMediaEvent());
  }

  @override
  Widget build(BuildContext context) {
    final List<MediaState> _mediaState = [
      LoadingMediaState(),
      AddingImageState(),
      ErrorAddingImageState(""),
      AddingVideoState(),
      ErrorAddingVideoState(""),
    ];

    return BlocConsumer<MediaBloc, MediaState>(
      listener: (context, state) {
        if (state is ErrorMediaState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
            ),
          );
        } else if (state is AddedImageState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Image added successfully",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
            ),
          );
        } else if (state is AddedVideoState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Video added successfully",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
            ),
          );
        } else if (state is ErrorAddingImageState ||
            state is ErrorAddingVideoState) {
          final errorMessage = state is ErrorAddingImageState
              ? state.message
              : (state as ErrorAddingVideoState).message;
          print("Error adding media: $errorMessage");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                "Failed to add media",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              ),
            ),
          );
        }
        else if(state is AddedDocumentState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Document added successfully",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
            ),
          );
        }
        else if(state is ErrorAddingDocumentState) {
          print("Error adding document: ${state.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                "Failed to add document",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LoadingMediaState ||
            state is AddingImageState ||
            state is ErrorAddingImageState ||
            state is AddingVideoState ||
            state is ErrorAddingVideoState ||
            state is AddingDocumentState ||
            state is ErrorAddingDocumentState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is LoadedMediaState) {
          return MediaPage(user: widget.user, mediaList: state.mediaList);
        } else if (state is ErrorMediaState) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              "Unexpected state: ${state.runtimeType}",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
