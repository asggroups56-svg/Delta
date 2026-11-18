import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/status.state.dart';
import '../../../data/repository/company_repo.dart';
import 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepo companyRepo;

  CompanyCubit(this.companyRepo) : super(const CompanyState());

  Future<void> getCompany({
    String deltaconfig = '1',
    required String languageCode,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(companyStatus: const StatusState.loading()));

    final result = await companyRepo.getCompany(
      deltaconfig: deltaconfig,
      languageCode: languageCode,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          companyStatus: StatusState.failure(failure.errMessage),
        ),
      ),
      (data) => emit(
        state.copyWith(companyStatus: StatusState.success(data)),
      ),
    );
  }

  /// Alias for convenience.
  Future<void> loadCompany({required String languageCode}) =>
      getCompany(languageCode: languageCode);
}
