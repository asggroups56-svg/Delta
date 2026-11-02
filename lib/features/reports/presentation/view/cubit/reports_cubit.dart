import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/status.state.dart';
import '../../../data/repository/reports_repo.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepo reportsRepo;

  ReportsCubit(this.reportsRepo) : super(const ReportsState());

  Future<File?> getChartOfAccountReport({
    num? fromAccountNo,
    num? toAccountNo,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    int? fromAccountLevel,
    int? toAccountLevel,
    int accountType = 2,
    int finalAccount = 4,
    String reportName = 'AGL004',
    required String languageCode,
    String exportType = 'pdf',
  }) async {
    if (isClosed) return null;
    emit(state.copyWith(chartOfAccountStatus: const StatusState.loading()));

    final result = await reportsRepo.getChartOfAccountReport(
      fromAccountNo: fromAccountNo,
      toAccountNo: toAccountNo,
      fromCurrencyCode: fromCurrencyCode,
      toCurrencyCode: toCurrencyCode,
      fromAccountLevel: fromAccountLevel,
      toAccountLevel: toAccountLevel,
      accountType: accountType,
      finalAccount: finalAccount,
      reportName: reportName,
      languageCode: languageCode,
      exportType: exportType,
    );

    if (isClosed) return null;
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            chartOfAccountStatus: StatusState.failure(failure.errMessage),
          ),
        );
        return null;
      },
      (file) {
        emit(state.copyWith(chartOfAccountStatus: StatusState.success(file)));
        return file;
      },
    );
  }
}
