import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/features/auth/data/datasource/auth_datasource_impl.dart';
import 'package:qr_folio/features/auth/data/repo/auth_repo_impl.dart';
import 'package:qr_folio/features/auth/domain/usecase/login_usecase.dart';
import 'package:qr_folio/features/auth/domain/usecase/logout_usecase.dart';
import 'package:qr_folio/features/auth/domain/usecase/signup_usecase.dart';
import 'package:qr_folio/features/auth/domain/usecase/verify_email_usecase.dart';
import 'package:qr_folio/features/auth/presentation/pages/auth_bloc_helper.dart';
import 'package:qr_folio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:qr_folio/features/home/data/datasource/user_datasource_impl.dart';
import 'package:qr_folio/features/home/data/repo/user_data_repo_impl.dart';
import 'package:qr_folio/features/home/domain/usecase/get_user_usecase.dart';
import 'package:qr_folio/features/home/domain/usecase/update_user_usecase.dart';
import 'package:qr_folio/features/home/domain/usecase/upload_photo_usecase.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/features/media/data/datasource/media_datasource_impl.dart';
import 'package:qr_folio/features/media/data/repo/media_repo_impl.dart';
import 'package:qr_folio/features/media/domain/usecase/add_image_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/add_video_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/add_document_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/delete_media_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/get_media_usecase.dart';
import 'package:qr_folio/features/media/presentation/bloc/media_bloc.dart';
import 'package:qr_folio/features/qr/data/datasource/qr_datasource_impl.dart';
import 'package:qr_folio/features/qr/data/repo/qr_repo_impl.dart';
import 'package:qr_folio/features/qr/domain/usecase/copy_qr_link_usecase.dart';
import 'package:qr_folio/features/qr/domain/usecase/export_qr_png_usecase.dart';
import 'package:qr_folio/features/qr/domain/usecase/export_qr_svg_usecase.dart';
import 'package:qr_folio/features/qr/domain/usecase/share_qr_usecase.dart';
import 'package:qr_folio/features/qr/presentation/bloc/qr_bloc.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUsecase: LoginUsecase(
              repo: AuthRepoImpl(datasource: AuthDatasourceImpl(dio: Dio())),
            ),
            logoutUsecase: LogoutUsecase(
              authRepo: AuthRepoImpl(
                datasource: AuthDatasourceImpl(dio: Dio()),
              ),
            ),
            signupUsecase: SignupUsecase(
              repo: AuthRepoImpl(datasource: AuthDatasourceImpl(dio: Dio())),
            ),
            verifyEmailUsecase: VerifyEmailUsecase(
              repo: AuthRepoImpl(datasource: AuthDatasourceImpl(dio: Dio())),
            ),
          )..add(AuthCheckEvent()),
        ),
        BlocProvider<UserBloc>(
          create: (context) {
            final userRepo = UserDataRepoImpl(
              datasource: UserDatasourceImpl(dio: Dio()),
            );
            return UserBloc(
              getUserUsecase: GetUserUsecase(repo: userRepo),
              updateUserUsecase: UpdateUserUsecase(repo: userRepo),
              uploadPhotoUsecase: UploadPhotoUsecase(repo: userRepo),
            );
          },
        ),
        BlocProvider<MediaBloc>(
          create: (context) => MediaBloc(
            getMediaUsecase: GetMediaUsecase(
              mediaRepo: MediaRepoImpl(
                mediaDatasource: MediaDatasourceImpl(dio: Dio()),
              ),
            ),
            addImageUsecase: AddImageUsecase(
              mediaRepo: MediaRepoImpl(
                mediaDatasource: MediaDatasourceImpl(dio: Dio()),
              ),
            ),
            addVideoUsecase: AddVideoUsecase(
              mediaRepo: MediaRepoImpl(
                mediaDatasource: MediaDatasourceImpl(dio: Dio()),
              ),
            ),
            addDocumentUsecase: AddDocumentUsecase(
              mediaRepo: MediaRepoImpl(
                mediaDatasource: MediaDatasourceImpl(dio: Dio()),
              ),
            ),
            deleteMediaUsecase: DeleteMediaUsecase(
              mediaRepo: MediaRepoImpl(
                mediaDatasource: MediaDatasourceImpl(dio: Dio()),
              ),
            ),
          ),
        ),
        BlocProvider<QrBloc>(
          create: (context) {
            final qrRepo = QrRepoImpl(qrDatasource: QrDatasourceImpl());
            return QrBloc(
              exportQrPngUsecase: ExportQrPngUsecase(qrRepo: qrRepo),
              exportQrSvgUsecase: ExportQrSvgUsecase(qrRepo: qrRepo),
              copyQrLinkUsecase: CopyQrLinkUsecase(qrRepo: qrRepo),
              shareQrUsecase: ShareQrUsecase(qrRepo: qrRepo),
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Folio',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(),
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryBlue,
            secondary: AppColors.secondaryBlue,
            surface: AppColors.surfacePrimary,
            error: AppColors.error,
            onPrimary: AppColors.textOnPrimary,
            onSecondary: AppColors.textOnPrimary,
            onSurface: AppColors.textPrimary,
            onError: AppColors.textOnPrimary,
          ),
          scaffoldBackgroundColor: AppColors.backgroundPrimary,
          cardColor: AppColors.cardPrimaryBg,
          cardTheme: CardThemeData(
            color: AppColors.cardPrimaryBg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.cardPrimaryBorder, width: 1),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.backgroundPrimary,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            titleTextStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        home: const AuthBlocHelper(),
      ),
    );
  }
}
