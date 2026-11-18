import 'package:equatable/equatable.dart';

import '../../../../../core/network/status.state.dart';
import '../../../data/models/company_model.dart';

class CompanyState extends Equatable {
  final StatusState<CompanyResponse> companyStatus;

  const CompanyState({
    this.companyStatus = const StatusState.initial(),
  });

  /// Convenient alias matching screen usage.
  StatusState<CompanyResponse> get status => companyStatus;

  CompanyState copyWith({StatusState<CompanyResponse>? companyStatus}) {
    return CompanyState(
      companyStatus: companyStatus ?? this.companyStatus,
    );
  }

  @override
  List<Object?> get props => [companyStatus];
}

