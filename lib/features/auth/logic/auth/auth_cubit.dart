import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  StreamSubscription<User?>? _authSubscription;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _listenToAuthState();
  }

  void _listenToAuthState() {
    emit(AuthLoading());

    _authSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
      onError: (error) {
        emit(AuthError('حدث خطأ أثناء التحقق من حالة المستخدم'));
      },
    );
  }

  Future<void> logout() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تسجيل الخروج'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}