import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      await _authRepository.signIn(
        email: email,
        password: password,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'لا يوجد حساب بهذا البريد الإلكتروني';
          break;

        case 'wrong-password':
        case 'invalid-credential':
          message = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
          break;

        case 'invalid-email':
          message = 'البريد الإلكتروني غير صحيح';
          break;

        case 'user-disabled':
          message = 'تم تعطيل هذا الحساب';
          break;

        case 'too-many-requests':
          message = 'تم إجراء محاولات كثيرة، حاول مرة أخرى لاحقًا';
          break;

        case 'network-request-failed':
          message = 'تأكد من اتصالك بالإنترنت';
          break;

        default:
          message = 'حدث خطأ أثناء تسجيل الدخول';
      }

      emit(LoginFailure(message));
    } catch (e) {
      emit(
        LoginFailure('حدث خطأ غير متوقع'),
      );
    }
  }
}