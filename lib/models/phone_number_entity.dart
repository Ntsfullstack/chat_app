import 'package:isar/isar.dart';

part 'phone_number_entity.g.dart';

@collection
class PhoneNumberEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  final String? phoneNumber;
  final String? firstNumber;
  final String? idCountry;
  final String? country;

  final phones = IsarLinks<PhoneNumberEntity>();

  PhoneNumberEntity({
    this.firstNumber,
    this.phoneNumber,
    this.idCountry,
    this.country,
  });
}
