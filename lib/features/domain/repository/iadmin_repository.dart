import 'package:code_path/core/resource/data_state.dart';

abstract class IAdminRepository{
  Future<DataState<int>> getUsersCount();
  Future<DataState<int>> getNewsCount();
}