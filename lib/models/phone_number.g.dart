

part of 'phone_number.dart';
PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) => PhoneNumber(
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$PhoneNumberToJson(PhoneNumber instance) =>
    <String, dynamic>{
      'phone': instance.phone,
    };
