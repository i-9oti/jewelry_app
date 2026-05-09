import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_helper.dart';

class UserState {
  final Map<String, dynamic>? currentUser;
  final bool isLoading;

  UserState({this.currentUser, this.isLoading = false});

  UserState copyWith({Map<String, dynamic>? currentUser, bool? isLoading}) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    
    final user = await DatabaseHelper.instance.loginUser(username, password);
    
    if (user != null) {
      state = state.copyWith(currentUser: user, isLoading: false);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', username);
      await prefs.setString('user_password', password);
      return true;
    }
    
    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final exists = await DatabaseHelper.instance.checkUserExists(username, email);
      if (exists) {
        state = state.copyWith(isLoading: false);
        return false; // Already exists
      }
      
      await DatabaseHelper.instance.registerUser(username, email, password);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> updateProfile(String username, String email, String password, String? profileImage) async {
    if (state.currentUser == null) return false;
    
    state = state.copyWith(isLoading: true);
    
    try {
      final oldEmail = state.currentUser!['email'];
      await DatabaseHelper.instance.updateUser(oldEmail, username, email, password, profileImage);
      
      final updatedUser = {
        ...state.currentUser!,
        'username': username,
        'email': email,
        'password': password,
        'profile_image': profileImage,
      };
      
      state = state.copyWith(currentUser: updatedUser, isLoading: false);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_password', password);
      
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(currentUser: null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_password');
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
