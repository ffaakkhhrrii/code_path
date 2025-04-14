import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;

  final Exception? error;

  const DataState({this.data,this.error});
}

class DataIdle<T> extends DataState<T>{
  const DataIdle(T data):super(data: data);
}

class DataLoading<T> extends DataState<T>{
  const DataLoading();
}

class DataSuccess<T> extends DataState<T>{
  const DataSuccess(T data): super(data: data);
}

class DataFailed<T> extends DataState<T>{
  const DataFailed(Exception error): super(error: error);
}