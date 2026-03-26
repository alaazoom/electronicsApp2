import 'package:equatable/equatable.dart';

class HelpCenterState extends Equatable {
  final bool isLoading;

  const HelpCenterState({this.isLoading = false});

  HelpCenterState copyWith({bool? isLoading}) {
    return HelpCenterState(isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [isLoading];
}
