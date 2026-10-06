import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../../../core/network/status.state.dart';

class ReportsState extends Equatable {
  final StatusState<File> chartOfAccountStatus;

  const ReportsState({
    this.chartOfAccountStatus = const StatusState.initial(),
  });

  ReportsState copyWith({
    StatusState<File>? chartOfAccountStatus,
  }) {
    return ReportsState(
      chartOfAccountStatus: chartOfAccountStatus ?? this.chartOfAccountStatus,
    );
  }

  @override
  List<Object?> get props => [chartOfAccountStatus];
}
