part of 'app_cubit.dart';

enum AppStatus { initial, ready, playing, stopped }

final class AppState extends Equatable {
  const AppState({
    required this.status,
    required this.remainingTime,
  });

  final AppStatus status;
  final int remainingTime;

  @override
  List<Object> get props => [status, remainingTime];

  AppState copyWith({
    AppStatus? status,
    int? remainingTime,
  }) {
    return AppState(
      status: status ?? this.status, 
      remainingTime: remainingTime ?? this.remainingTime
    );
  }
}
