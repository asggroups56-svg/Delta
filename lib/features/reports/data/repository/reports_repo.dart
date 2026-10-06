import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/chart_of_account_report_request_model.dart';

abstract interface class ReportsRepo {
  Future<Either<Failure, File>> getChartOfAccountReport({
    String reportName = 'AGL001',
    String exportType = 'pdf',
  });
}

class ReportsRepoImpl implements ReportsRepo {
  final ApiConsumer apiConsumer;

  ReportsRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, File>> getChartOfAccountReport({
    String reportName = 'AGL001',
    String exportType = 'pdf',
  }) {
    return handleDioRequest(
      request: () async {
        final requestModel = ChartOfAccountReportRequestModel(
          reportName: reportName,
          exportType: exportType,
        );

        final isPdf = exportType.toLowerCase() == 'pdf';
        final response = await apiConsumer.post(
          EndPoints.chartOfAccountReport,
          body: requestModel.toJson(),
          options: Options(
            responseType: ResponseType.bytes,
            headers: {
              'Accept': isPdf ? 'application/pdf' : '*/*',
            },
          ),
        );

        final Uint8List bytes;
        if (response is Uint8List) {
          bytes = response;
        } else if (response is List<int>) {
          bytes = Uint8List.fromList(response);
        } else if (response is List) {
          bytes = Uint8List.fromList(response.cast<int>());
        } else {
          throw const FormatException('Invalid report binary response data.');
        }

        final dir = await getTemporaryDirectory();
        final ext = isPdf ? 'pdf' : exportType.toLowerCase();
        final file = File(
          '${dir.path}/chart_of_account_${DateTime.now().millisecondsSinceEpoch}.$ext',
        );
        await file.writeAsBytes(bytes);
        return file;
      },
    );
  }
}
