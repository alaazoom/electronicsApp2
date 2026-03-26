import 'package:flutter_bloc/flutter_bloc.dart';

enum ViewType { list, grid }

class ViewTypeCubit extends Cubit<ViewType> {
  ViewTypeCubit() : super(ViewType.list);

  void showList() => emit(ViewType.list);
  void showGrid() => emit(ViewType.grid);
}
