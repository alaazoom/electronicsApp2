import 'package:equatable/equatable.dart';

enum AddListingSubmitStatus { idle, submitting, success, offline, failure }

class AddListingSubmitState extends Equatable {
  final AddListingSubmitStatus status;
  final String errorMessage;

  const AddListingSubmitState({
    this.status = AddListingSubmitStatus.idle,
    this.errorMessage = '',
  });

  AddListingSubmitState copyWith({
    AddListingSubmitStatus? status,
    String? errorMessage,
  }) {
    return AddListingSubmitState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
