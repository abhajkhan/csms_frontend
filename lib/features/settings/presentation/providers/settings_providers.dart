import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/change_password_controller.dart';

final changePasswordControllerProvider =
    AutoDisposeAsyncNotifierProvider<ChangePasswordController, void>(
      ChangePasswordController.new,
    );
