import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(RegisterInitial());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      await _authRepository.signUp(
        email: email,
        password: password,
      );

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'البريد الإلكتروني مستخدم بالفعل';
          break;

        case 'invalid-email':
          message = 'البريد الإلكتروني غير صحيح';
          break;

        case 'weak-password':
          message = 'كلمة المرور ضعيفة';
          break;

        case 'network-request-failed':
          message = 'تأكد من اتصالك بالإنترنت';
          break;

        default:
          message = 'حدث خطأ أثناء إنشاء الحساب';
      }

      emit(RegisterFailure(message));
    } catch (e) {
      emit(RegisterFailure('حدث خطأ غير متوقع'));
    }
  }
}