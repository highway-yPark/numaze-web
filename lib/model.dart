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

  SelectedTreatment({
    required this.treatmentId,
    required this.selectedOptions,
    this.styleId,
    this.monthlyPickId,
    this.treatmentStyleId,
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

  TreatmentOptionPair({
    required this.treatment_id,
    required this.option_ids,
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
