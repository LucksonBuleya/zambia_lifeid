enum ContactType { phone, whatsapp, email, website }

class OfficeContact {
  final String label;
  final String value;
  final ContactType type;

  const OfficeContact(this.label, this.value, this.type);

  /// The link opened when the contact is tapped.
  Uri get uri => switch (type) {
        ContactType.phone => Uri(scheme: 'tel', path: value.replaceAll(' ', '')),
        ContactType.whatsapp =>
          Uri.parse('https://wa.me/${value.replaceAll(RegExp(r'[^0-9]'), '')}'),
        ContactType.email => Uri(scheme: 'mailto', path: value),
        ContactType.website => Uri.parse(value),
      };
}

/// A government office. Only add details that appear in an official source.
/// Leave [address] null and [contacts] empty when they are not verified, and
/// the app will say so instead of guessing.
class GovOffice {
  final String id;
  final String name;
  final String authority;
  final String province;
  final String town;
  final String? address;
  final List<OfficeContact> contacts;

  /// Ids of the services this office is relevant to (see services_data.dart).
  final List<String> serviceIds;

  /// True for head offices, which are shown as a fallback for every province.
  final bool isHeadOffice;

  /// What the source confirms, e.g. "Town listed in a 2021 RTSA document".
  final String note;
  final String sourceName;
  final String sourceUrl;

  const GovOffice({
    required this.id,
    required this.name,
    required this.authority,
    required this.province,
    required this.town,
    this.address,
    this.contacts = const [],
    required this.serviceIds,
    this.isHeadOffice = false,
    required this.note,
    required this.sourceName,
    required this.sourceUrl,
  });

  bool get isFullyVerified => address != null && contacts.isNotEmpty;
}
