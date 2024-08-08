import 'package:authfication/bloc/auth_event.dart';
import 'package:authfication/bloc/auth_state.dart';
import 'package:authfication/data/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await _authService.signInWithEmailAndPassword(
          event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(message: "Login failed"));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await _authService.registerWithEmailAndPassword(
          event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(message: "Registration failed"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await _authService.signOut();
      emit(AuthUnauthenticated());
    });
  }
}
