import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum DisplayItem { list, grid }

// Cubit State
class DisplayState extends Equatable {
  final DisplayItem displayItem;

  const DisplayState(this.displayItem);

  @override
  List<Object> get props => [displayItem];
}
