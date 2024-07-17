// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopBasicInfo _$ShopBasicInfoFromJson(Map<String, dynamic> json) =>
    ShopBasicInfo(
      domain: json['domain'] as String,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      simpleAddress: json['simpleAddress'] as String,
      addressDetail: json['addressDetail'] as String,
      kakaotalkLink: json['kakaotalkLink'] as String,
      takeReservation: json['takeReservation'] as bool,
      profileImage: json['profileImage'] as String,
      backgroundImage: json['backgroundImage'] as String?,
      shopType: json['shopType'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      parkingType: json['parkingType'] as String,
      parkingMessage: json['parkingMessage'] as String,
      additionalMessage: json['additionalMessage'] as String,
      futureReservationDays: (json['futureReservationDays'] as num).toInt(),
      selectDesigner: json['selectDesigner'] as bool,
    );

Map<String, dynamic> _$ShopBasicInfoToJson(ShopBasicInfo instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'name': instance.name,
      'englishName': instance.englishName,
      'description': instance.description,
      'address': instance.address,
      'simpleAddress': instance.simpleAddress,
      'addressDetail': instance.addressDetail,
      'kakaotalkLink': instance.kakaotalkLink,
      'takeReservation': instance.takeReservation,
      'profileImage': instance.profileImage,
      'backgroundImage': instance.backgroundImage,
      'shopType': instance.shopType,
      'tags': instance.tags,
      'parkingType': instance.parkingType,
      'parkingMessage': instance.parkingMessage,
      'additionalMessage': instance.additionalMessage,
      'futureReservationDays': instance.futureReservationDays,
      'selectDesigner': instance.selectDesigner,
    };

ShopMessageInfo _$ShopMessageInfoFromJson(Map<String, dynamic> json) =>
    ShopMessageInfo(
      domain: json['domain'] as String,
      hasDeposit: json['hasDeposit'] as bool,
      depositAmount: json['depositAmount'] as String,
      bankAccount: json['bankAccount'] as String,
      depositTimeLimit: (json['depositTimeLimit'] as num).toInt(),
      reservationMessage: json['reservationMessage'] as String,
      additionalMessage: json['additionalMessage'] as String,
      memberReceiveDeposit: json['memberReceiveDeposit'] as bool,
    );

Map<String, dynamic> _$ShopMessageInfoToJson(ShopMessageInfo instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'hasDeposit': instance.hasDeposit,
      'depositAmount': instance.depositAmount,
      'bankAccount': instance.bankAccount,
      'depositTimeLimit': instance.depositTimeLimit,
      'reservationMessage': instance.reservationMessage,
      'additionalMessage': instance.additionalMessage,
      'memberReceiveDeposit': instance.memberReceiveDeposit,
    };

ShopAnnouncementsModel _$ShopAnnouncementsModelFromJson(
        Map<String, dynamic> json) =>
    ShopAnnouncementsModel(
      announcementType:
          $enumDecode(_$AnnouncementTypeEnumMap, json['announcementType']),
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$ShopAnnouncementsModelToJson(
        ShopAnnouncementsModel instance) =>
    <String, dynamic>{
      'announcementType': _$AnnouncementTypeEnumMap[instance.announcementType]!,
      'title': instance.title,
      'content': instance.content,
    };

const _$AnnouncementTypeEnumMap = {
  AnnouncementType.notice: 'notice',
  AnnouncementType.event: 'event',
};

MonthlyPickModel _$MonthlyPickModelFromJson(Map<String, dynamic> json) =>
    MonthlyPickModel(
      styleId: (json['styleId'] as num).toInt(),
      treatmentId: (json['treatmentId'] as num).toInt(),
      thumbnail: json['thumbnail'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      treatmentName: json['treatmentName'] as String,
    );

Map<String, dynamic> _$MonthlyPickModelToJson(MonthlyPickModel instance) =>
    <String, dynamic>{
      'styleId': instance.styleId,
      'treatmentId': instance.treatmentId,
      'thumbnail': instance.thumbnail,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'treatmentName': instance.treatmentName,
    };

TreatmentModel _$TreatmentModelFromJson(Map<String, dynamic> json) =>
    TreatmentModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      thumbnail: json['thumbnail'] as String,
      minPrice: (json['minPrice'] as num).toInt(),
      maxPrice: (json['maxPrice'] as num?)?.toInt(),
      discount: (json['discount'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      description: json['description'] as String,
      styleCount: (json['styleCount'] as num).toInt(),
      optionIds: (json['optionIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$TreatmentModelToJson(TreatmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'discount': instance.discount,
      'duration': instance.duration,
      'description': instance.description,
      'styleCount': instance.styleCount,
      'optionIds': instance.optionIds,
    };

TreatmentCategory _$TreatmentCategoryFromJson(Map<String, dynamic> json) =>
    TreatmentCategory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      treatments: (json['treatments'] as List<dynamic>)
          .map((e) => TreatmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TreatmentCategoryToJson(TreatmentCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'treatments': instance.treatments,
    };

OptionModel _$OptionModelFromJson(Map<String, dynamic> json) => OptionModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      duration: (json['duration'] as num).toInt(),
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$OptionModelToJson(OptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'duration': instance.duration,
      'order': instance.order,
    };

OptionCategory _$OptionCategoryFromJson(Map<String, dynamic> json) =>
    OptionCategory(
      name: json['name'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OptionCategoryToJson(OptionCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'options': instance.options,
    };

StyleModel _$StyleModelFromJson(Map<String, dynamic> json) => StyleModel(
      styleId: (json['styleId'] as num).toInt(),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      treatmentId: (json['treatmentId'] as num).toInt(),
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$StyleModelToJson(StyleModel instance) =>
    <String, dynamic>{
      'styleId': instance.styleId,
      'categoryId': instance.categoryId,
      'treatmentId': instance.treatmentId,
      'thumbnail': instance.thumbnail,
    };

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
      after: (json['after'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) =>
    <String, dynamic>{
      'after': instance.after,
      'count': instance.count,
    };

TreatmentOptionPair _$TreatmentOptionPairFromJson(Map<String, dynamic> json) =>
    TreatmentOptionPair(
      treatment_id: (json['treatment_id'] as num).toInt(),
      option_ids: (json['option_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      style_id: (json['style_id'] as num?)?.toInt(),
      monthly_pick_id: (json['monthly_pick_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TreatmentOptionPairToJson(
        TreatmentOptionPair instance) =>
    <String, dynamic>{
      'treatment_id': instance.treatment_id,
      'option_ids': instance.option_ids,
      'style_id': instance.style_id,
      'monthly_pick_id': instance.monthly_pick_id,
    };

SelectedTreatmentsRequest _$SelectedTreatmentsRequestFromJson(
        Map<String, dynamic> json) =>
    SelectedTreatmentsRequest(
      treatment_option_pairs: (json['treatment_option_pairs'] as List<dynamic>)
          .map((e) => TreatmentOptionPair.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SelectedTreatmentsRequestToJson(
        SelectedTreatmentsRequest instance) =>
    <String, dynamic>{
      'treatment_option_pairs': instance.treatment_option_pairs,
    };

CustomerNewAppointmentRequest _$CustomerNewAppointmentRequestFromJson(
        Map<String, dynamic> json) =>
    CustomerNewAppointmentRequest(
      designer_id: (json['designer_id'] as num?)?.toInt(),
      appointment_date: json['appointment_date'] as String,
      start_time: (json['start_time'] as num).toInt(),
      customer_name: json['customer_name'] as String,
      customer_phone_number: json['customer_phone_number'] as String,
      customer_request: json['customer_request'] as String?,
      treatment_option_pairs: (json['treatment_option_pairs'] as List<dynamic>)
          .map((e) => TreatmentOptionPair.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerNewAppointmentRequestToJson(
        CustomerNewAppointmentRequest instance) =>
    <String, dynamic>{
      'designer_id': instance.designer_id,
      'appointment_date': instance.appointment_date,
      'start_time': instance.start_time,
      'customer_name': instance.customer_name,
      'customer_phone_number': instance.customer_phone_number,
      'customer_request': instance.customer_request,
      'treatment_option_pairs': instance.treatment_option_pairs,
    };

DesignerAvailableTimeSlots _$DesignerAvailableTimeSlotsFromJson(
        Map<String, dynamic> json) =>
    DesignerAvailableTimeSlots(
      designerId: (json['designerId'] as num).toInt(),
      designerNickname: json['designerNickname'] as String,
      timeSlots: (json['timeSlots'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$DesignerAvailableTimeSlotsToJson(
        DesignerAvailableTimeSlots instance) =>
    <String, dynamic>{
      'designerId': instance.designerId,
      'designerNickname': instance.designerNickname,
      'timeSlots': instance.timeSlots,
    };

SelectedDateTime _$SelectedDateTimeFromJson(Map<String, dynamic> json) =>
    SelectedDateTime(
      selectedDate: json['selectedDate'] as String?,
      selectedTimeSlot: (json['selectedTimeSlot'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SelectedDateTimeToJson(SelectedDateTime instance) =>
    <String, dynamic>{
      'selectedDate': instance.selectedDate,
      'selectedTimeSlot': instance.selectedTimeSlot,
    };

OptionHistoryResponse _$OptionHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    OptionHistoryResponse(
      optionCategoryName: json['optionCategoryName'] as String,
      optionName: json['optionName'] as String,
      optionDuration: (json['optionDuration'] as num).toInt(),
    );

Map<String, dynamic> _$OptionHistoryResponseToJson(
        OptionHistoryResponse instance) =>
    <String, dynamic>{
      'optionCategoryName': instance.optionCategoryName,
      'optionName': instance.optionName,
      'optionDuration': instance.optionDuration,
    };

TreatmentHistoryResponse _$TreatmentHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    TreatmentHistoryResponse(
      treatmentCategoryName: json['treatmentCategoryName'] as String,
      treatmentName: json['treatmentName'] as String,
      treatmentMinPrice: (json['treatmentMinPrice'] as num).toInt(),
      treatmentMaxPrice: (json['treatmentMaxPrice'] as num?)?.toInt(),
      discount: (json['discount'] as num).toInt(),
      treatmentDuration: (json['treatmentDuration'] as num).toInt(),
      thumbnail: json['thumbnail'] as String,
      treatmentType: (json['treatmentType'] as num).toInt(),
      options: (json['options'] as List<dynamic>?)
          ?.map(
              (e) => OptionHistoryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TreatmentHistoryResponseToJson(
        TreatmentHistoryResponse instance) =>
    <String, dynamic>{
      'treatmentCategoryName': instance.treatmentCategoryName,
      'treatmentName': instance.treatmentName,
      'treatmentMinPrice': instance.treatmentMinPrice,
      'treatmentMaxPrice': instance.treatmentMaxPrice,
      'discount': instance.discount,
      'treatmentDuration': instance.treatmentDuration,
      'thumbnail': instance.thumbnail,
      'treatmentType': instance.treatmentType,
      'options': instance.options,
    };

CustomerAppointmentResponse _$CustomerAppointmentResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerAppointmentResponse(
      base64Uuid: json['base64Uuid'] as String,
      createdAt: json['createdAt'] as String,
      customerName: json['customerName'] as String,
      customerPhoneNumber: json['customerPhoneNumber'] as String,
      customerMembershipAmount:
          (json['customerMembershipAmount'] as num).toInt(),
      membershipExpirationDate: json['membershipExpirationDate'] as String?,
      designerName: json['designerName'] as String?,
      treatmentOptionHistory: (json['treatmentOptionHistory'] as List<dynamic>)
          .map((e) =>
              TreatmentHistoryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerImages: (json['customerImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      customerRequest: json['customerRequest'] as String?,
      appointmentDate: json['appointmentDate'] as String,
      startTime: (json['startTime'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      confirmed: json['confirmed'] as bool,
      status: json['status'] as String?,
      membership: json['membership'] as bool,
    );

Map<String, dynamic> _$CustomerAppointmentResponseToJson(
        CustomerAppointmentResponse instance) =>
    <String, dynamic>{
      'base64Uuid': instance.base64Uuid,
      'createdAt': instance.createdAt,
      'customerName': instance.customerName,
      'customerPhoneNumber': instance.customerPhoneNumber,
      'customerMembershipAmount': instance.customerMembershipAmount,
      'membershipExpirationDate': instance.membershipExpirationDate,
      'designerName': instance.designerName,
      'treatmentOptionHistory': instance.treatmentOptionHistory,
      'customerImages': instance.customerImages,
      'customerRequest': instance.customerRequest,
      'appointmentDate': instance.appointmentDate,
      'startTime': instance.startTime,
      'duration': instance.duration,
      'confirmed': instance.confirmed,
      'status': instance.status,
      'membership': instance.membership,
    };
