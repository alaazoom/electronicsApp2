import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionCubit extends Cubit<int> {
  SelectionCubit() : super(0);

  void select(int index) {
    emit(index);
  }
}
