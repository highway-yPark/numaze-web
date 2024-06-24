import 'package:json_annotation/json_annotation.dart';

part 'list_model.g.dart';

abstract class ListBase {}

class ListError extends ListBase {
  final String data;

  ListError({
    required this.data,
  });
}

class ListLoading extends ListBase {}

class ListEmpty extends ListBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class ListModel<T> extends ListBase {
  final List<T> data;

  ListModel({required this.data});

  factory ListModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ListModelFromJson(json, fromJsonT);

  // i want to make copyWith method
  ListModel copyWith({
    List<T>? data,
  }) {
    return ListModel<T>(
      data: data ?? this.data,
    );
  }
}
