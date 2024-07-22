import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

abstract class ShopBasicBase {}

class ShopBasicError extends ShopBasicBase {
  final String data;

  ShopBasicError({
    required this.data,
  });
}

class ShopBasicLoading extends ShopBasicBase {}

@JsonSerializable()
class ShopBasicInfo extends ShopBasicBase {
  final String domain;
  final String name;
  final String englishName;
  final String description;
  final String address;
  final String simpleAddress;
  final String addressDetail;
  final String kakaotalkLink;
  final bool takeReservation;
  final bool approval;
  final String profileImage;
  final String? backgroundImage;
  final String shopType;
  final List<String> tags;
  final String parkingType;
  final String parkingMessage;
  final String additionalMessage;
  final int futureReservationDays;
  final bool selectDesigner;

  ShopBasicInfo({
    required this.domain,
    required this.name,
    required this.englishName,
    required this.description,
    required this.address,
    required this.simpleAddress,
    required this.addressDetail,
    required this.kakaotalkLink,
    required this.takeReservation,
    required this.approval,
    required this.profileImage,
    this.backgroundImage,
    required this.shopType,
    required this.tags,
    required this.parkingType,
    required this.parkingMessage,
    required this.additionalMessage,
    required this.futureReservationDays,
    required this.selectDesigner,
  });

  factory ShopBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$ShopBasicInfoFromJson(json);
}

abstract class ShopMessageBase {}

class ShopMessageError extends ShopMessageBase {
  final String data;

  ShopMessageError({
    required this.data,
  });
}

class ShopMessageLoading extends ShopMessageBase {}

@JsonSerializable()
class ShopMessageInfo extends ShopMessageBase {
  final String domain;
  final bool hasDeposit;
  final String depositAmount;
  final String bankAccount;
  final int depositTimeLimit;
  final String reservationMessage;
  final String additionalMessage;
  final bool memberReceiveDeposit;

  ShopMessageInfo({
    required this.domain,
    required this.hasDeposit,
    required this.depositAmount,
    required this.bankAccount,
    required this.depositTimeLimit,
    required this.reservationMessage,
    required this.additionalMessage,
    required this.memberReceiveDeposit,
  });

  factory ShopMessageInfo.fromJson(Map<String, dynamic> json) =>
      _$ShopMessageInfoFromJson(json);
}

@JsonSerializable()
class ShopAnnouncementsModel {
  final AnnouncementType announcementType;
  final String title;
  final String content;

  ShopAnnouncementsModel({
    required this.announcementType,
    required this.title,
    required this.content,
  });

  factory ShopAnnouncementsModel.fromJson(Map<String, dynamic> json) =>
      _$ShopAnnouncementsModelFromJson(json);
}

enum AnnouncementType {
  notice,
  event,
}

@JsonSerializable()
class MonthlyPickModel {
  final int styleId;
  final int treatmentId;
  final String thumbnail;
  final int categoryId;
  final String categoryName;
  final String treatmentName;

  MonthlyPickModel({
    required this.styleId,
    required this.treatmentId,
    required this.thumbnail,
    required this.categoryId,
    required this.categoryName,
    required this.treatmentName,
  });

  factory MonthlyPickModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyPickModelFromJson(json);
}

@JsonSerializable()
class TreatmentModel {
  final int id;
  final String name;
  final String thumbnail;
  final int minPrice;
  final int? maxPrice;
  final int discount;
  final int duration;
  final String description;
  // final int shortReservationDays;
  // final int order;
  // final bool hidden;
  final int styleCount;
  final List<int> optionIds;
  // final List<int> unavailableDesignerIds;

  TreatmentModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.minPrice,
    this.maxPrice,
    required this.discount,
    required this.duration,
    required this.description,
    // required this.shortReservationDays,
    // required this.order,
    // required this.hidden,
    required this.styleCount,
    required this.optionIds,
    // required this.unavailableDesignerIds,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) =>
      _$TreatmentModelFromJson(json);
}

@JsonSerializable()
class TreatmentCategory {
  final int id;
  final String name;
  // final int shopTypeId;
  final List<TreatmentModel> treatments;

  TreatmentCategory({
    required this.id,
    required this.name,
    // required this.shopTypeId,
    required this.treatments,
  });

  factory TreatmentCategory.fromJson(Map<String, dynamic> json) =>
      _$TreatmentCategoryFromJson(json);
}

@JsonSerializable()
class OptionModel {
  final int id;
  final String name;
  final String description;
  final int duration;
  final int order;

  OptionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.order,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);
}

@JsonSerializable()
class OptionCategory {
  // final int id;
  final String name;
  // final int shopTypeId;
  final List<OptionModel> options;

  OptionCategory({
    // required this.id,
    required this.name,
    // required this.shopTypeId,
    required this.options,
  });

  factory OptionCategory.fromJson(Map<String, dynamic> json) =>
      _$OptionCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$OptionCategoryToJson(this);

  OptionCategory copyWith({
    List<OptionModel>? options,
  }) {
    return OptionCategory(
      // id: id,
      name: name,
      // shopTypeId: shopTypeId,
      options: options ?? this.options,
    );
  }
}

// class SelectedTreatment {
//   final int treatmentId;
//   final Map<String, int> selectedOptions;
//
//   SelectedTreatment({
//     required this.treatmentId,
//     required this.selectedOptions,
//   });
// }
class SelectedTreatment {
  final int treatmentId;
  final Map<String, int> selectedOptions;
  final int? styleId;
  final int? monthlyPickId;
  final int? treatmentStyleId;
  final String? styleImage;
  final String? monthlyPickImage;
  final String? treatmentStyleImage;

  SelectedTreatment({
    required this.treatmentId,
    required this.selectedOptions,
    this.styleId,
    this.monthlyPickId,
    this.treatmentStyleId,
    this.styleImage,
    this.monthlyPickImage,
    this.treatmentStyleImage,
  });
}

class SelectedCategory {
  final List<SelectedTreatment> selectedTreatments;

  SelectedCategory({required this.selectedTreatments});
}

@JsonSerializable()
class StyleModel {
  final int styleId;
  final int? categoryId;
  final int treatmentId;
  final String thumbnail;

  StyleModel({
    required this.styleId,
    this.categoryId,
    required this.treatmentId,
    required this.thumbnail,
  });

  factory StyleModel.fromJson(Map<String, dynamic> json) =>
      _$StyleModelFromJson(json);
}

@JsonSerializable()
class PaginationParams {
  final int? after;
  final int? count;

  const PaginationParams({
    this.after,
    this.count,
  });

  PaginationParams copyWith({
    int? after,
    int? count,
  }) {
    return PaginationParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}

@JsonSerializable()
class TreatmentOptionPair {
  final int treatment_id;
  final List<int> option_ids;
  final int? style_id;
  final int? monthly_pick_id;

  TreatmentOptionPair({
    required this.treatment_id,
    required this.option_ids,
    this.style_id,
    this.monthly_pick_id,
  });

  factory TreatmentOptionPair.fromJson(Map<String, dynamic> json) =>
      _$TreatmentOptionPairFromJson(json);

  Map<String, dynamic> toJson() => _$TreatmentOptionPairToJson(this);
}

@JsonSerializable()
class SelectedTreatmentsRequest {
  final List<TreatmentOptionPair> treatment_option_pairs;

  SelectedTreatmentsRequest({required this.treatment_option_pairs});

  factory SelectedTreatmentsRequest.fromJson(Map<String, dynamic> json) =>
      _$SelectedTreatmentsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedTreatmentsRequestToJson(this);
}

@JsonSerializable()
class CustomerNewAppointmentRequest {
  final int? designer_id;
  final String appointment_date;
  final int start_time;
  final String customer_name;
  final String customer_phone_number;
  final String? customer_request;
  final List<TreatmentOptionPair> treatment_option_pairs;

  CustomerNewAppointmentRequest({
    required this.designer_id,
    required this.appointment_date,
    required this.start_time,
    required this.customer_name,
    required this.customer_phone_number,
    required this.customer_request,
    required this.treatment_option_pairs,
  });

  factory CustomerNewAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerNewAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerNewAppointmentRequestToJson(this);
}

@JsonSerializable()
class DesignerAvailableTimeSlots {
  final int designerId;
  final String designerNickname;
  final List<int> timeSlots;

  DesignerAvailableTimeSlots({
    required this.designerId,
    required this.designerNickname,
    required this.timeSlots,
  });

  factory DesignerAvailableTimeSlots.fromJson(Map<String, dynamic> json) =>
      _$DesignerAvailableTimeSlotsFromJson(json);
}

@JsonSerializable()
class SelectedDateTime {
  final String? selectedDate;
  final int? selectedTimeSlot;

  SelectedDateTime({
    this.selectedDate,
    this.selectedTimeSlot,
  });

  factory SelectedDateTime.fromJson(Map<String, dynamic> json) =>
      _$SelectedDateTimeFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedDateTimeToJson(this);

  SelectedDateTime copyWith({String? selectedDate, int? selectedTimeSlot}) {
    return SelectedDateTime(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
    );
  }
}

class SelectedDesigner {
  final int designerId;
  final String designerNickname;

  SelectedDesigner({
    required this.designerId,
    required this.designerNickname,
  });
}

@JsonSerializable()
class OptionHistoryResponse {
  final String optionCategoryName;
  final String optionName;
  final int optionDuration;

  OptionHistoryResponse({
    required this.optionCategoryName,
    required this.optionName,
    required this.optionDuration,
  });

  factory OptionHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$OptionHistoryResponseFromJson(json);
}

@JsonSerializable()
class TreatmentHistoryResponse {
  final String treatmentCategoryName;
  final String treatmentName;
  final int treatmentMinPrice;
  final int? treatmentMaxPrice;
  final int discount;
  final int treatmentDuration;
  final String thumbnail;
  final int treatmentType;
  final List<OptionHistoryResponse>? options;

  TreatmentHistoryResponse({
    required this.treatmentCategoryName,
    required this.treatmentName,
    required this.treatmentMinPrice,
    this.treatmentMaxPrice,
    required this.discount,
    required this.treatmentDuration,
    required this.thumbnail,
    required this.treatmentType,
    required this.options,
  });

  factory TreatmentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$TreatmentHistoryResponseFromJson(json);
}

abstract class CustomerAppointmentBase {}

class CustomerAppointmentError extends CustomerAppointmentBase {
  final String data;

  CustomerAppointmentError({
    required this.data,
  });
}

class CustomerAppointmentLoading extends CustomerAppointmentBase {}

@JsonSerializable()
class CustomerAppointmentResponse extends CustomerAppointmentBase {
  final String base64Uuid;
  final String createdAt;
  final String customerName;
  final String customerPhoneNumber;
  final int customerMembershipAmount;
  final String? membershipExpirationDate;
  final String? designerName;
  final List<TreatmentHistoryResponse> treatmentOptionHistory;
  final List<String>? customerImages;
  final String? customerRequest;
  final String appointmentDate;
  final int startTime;
  final int duration;
  final bool confirmed;
  final String? status;
  final bool membership;

  CustomerAppointmentResponse({
    required this.base64Uuid,
    required this.createdAt,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerMembershipAmount,
    required this.membershipExpirationDate,
    required this.designerName,
    required this.treatmentOptionHistory,
    required this.customerImages,
    required this.customerRequest,
    required this.appointmentDate,
    required this.startTime,
    required this.duration,
    required this.confirmed,
    required this.status,
    required this.membership,
  });

  factory CustomerAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerAppointmentResponseFromJson(json);
}
