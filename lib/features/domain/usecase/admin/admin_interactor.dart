import 'package:code_path/core/resource/data_state.dart';

abstract class AdminInteractor{
  Future<DataState<int>> getUsersCount();
  Future<DataState<int>> getNewsCount();
}