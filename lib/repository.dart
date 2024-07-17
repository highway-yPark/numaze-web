import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/base_response_model.dart';
import 'package:numaze_web/cursor_pagination_model.dart';
import 'package:retrofit/retrofit.dart';

import 'common/const/data.dart';
import 'dio.dart';
import 'list_model.dart';
import 'model.dart';

part 'repository.g.dart';

final repositoryProvider = Provider<Repository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return Repository(dio, baseUrl: 'http://$ip');
  },
);

@RestApi()
abstract class Repository {
  factory Repository(Dio dio, {String baseUrl}) = _Repository;

  @GET("/s/{shop_domain}")
  Future<ShopBasicInfo> getShopBasicInfo({
    @Path('shop_domain') required String shopDomain,
  });

  @GET("/s/{shop_domain}/messages")
  Future<ShopMessageInfo> getShopMessageInfo({
    @Path('shop_domain') required String shopDomain,
  });

  @GET("/s/{shop_domain}/announcements")
  Future<ListModel<ShopAnnouncementsModel>> getShopAnnouncements({
    @Path('shop_domain') required String shopDomain,
  });

  @GET("/s/{shop_domain}/monthly-pick")
  Future<ListModel<MonthlyPickModel>> getShopMonthlyPicks({
    @Path('shop_domain') required String shopDomain,
  });

  @GET("/s/{shop_domain}/treatments")
  Future<ListModel<TreatmentCategory>> getTreatments({
    @Path('shop_domain') required String shopDomain,
  });

  @GET("/s/{shop_domain}/options")
  Future<ListModel<OptionCategory>> getOptions({
    @Path('shop_domain') required String shopDomain,
  });

  @GET("/s/{shop_domain}/styles")
  Future<CursorPagination<StyleModel>> getShopStyles({
    @Path('shop_domain') required String shopDomain,
    @Queries() PaginationParams? paginationParams,
  });

  @POST("/s/{shop_domain}/fullBook")
  Future<ListModelWithDuration<String>> getOccupiedDates({
    @Path('shop_domain') required String shopDomain,
    @Query('start_date') required String startDate,
    @Query('end_date') required String endDate,
    @Body() required SelectedTreatmentsRequest request,
  });

  @POST("/s/{shop_domain}/slots")
  Future<ListModel<DesignerAvailableTimeSlots>> getAvailableTimeSlots({
    @Path('shop_domain') required String shopDomain,
    @Query('date') required String date,
    @Body() required SelectedTreatmentsRequest request,
  });

  @POST("/s/{shop_domain}/appointment")
  Future<BaseResponseModel> createAppointment({
    @Path('shop_domain') required String shopDomain,
    @Body() required CustomerNewAppointmentRequest request,
  });

  @GET("/appointments/{appointment_id}")
  Future<CustomerAppointmentResponse> getCustomerAppointment({
    @Path('appointment_id') required String appointmentId,
  });

  @POST("/appointments/{appointment_id}")
  Future<void> customerRequestImages({
    @Path('appointment_id') required String appointmentId,
    @Part(name: 'files') required List<MultipartFile> files,
  });

  @POST("/appointments/{appointment_id}/payment")
  Future<void> paymentMade({
    @Path('appointment_id') required String appointmentId,
  });

  // @POST("/api/v1/auth/sms")
  // Future<void> requestVerificationCode({
  //   @Query('phone_number') required String phoneNumber,
  //   @Query('register') bool register = false,
  // });
  //
  // @POST("/api/v1/auth/sms/verify")
  // Future<void> verifyVerificationCode({
  //   @Query('phone_number') required String phoneNumber,
  //   @Query('verification_code') required String verificationCode,
  // });
}

final treatmentRepositoryProvider = Provider<TreatmentRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return TreatmentRepository(dio, baseUrl: 'http://$ip');
  },
);

@RestApi()
abstract class TreatmentRepository {
  factory TreatmentRepository(Dio dio, {String baseUrl}) = _TreatmentRepository;

  @GET("/treatments/{treatment_id}/styles")
  Future<CursorPagination<StyleModel>> paginate({
    @Path('treatment_id') required int treatmentId,
    @Queries() PaginationParams? paginationParams,
  });
}
