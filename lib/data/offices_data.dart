import '../models/gov_office.dart';

// Every entry below comes from an official source, checked 15 October 2026.
// Where a source only confirms that an office exists in a town, the address
// and contacts are left empty so the app shows them as "not verified".
// To add an office, copy an entry and fill in only what a source confirms.

const _rtsaWebsite = 'https://www.rtsa.org.zm/';
const _rtsaTender =
    'https://www.rtsa.org.zm/wp-content/uploads/2021/08/Open-Tender-Adverts-for-Branding-Offices.pdf';
const _rtsaTenderNote =
    'RTSA office in this town is named in an official RTSA tender notice (2021). '
    'Address, contacts and the services offered here are not verified.';

const _passportSheet =
    'https://zambiaembassy.se/wp-content/uploads/2019/05/PROCEDURE-FOR-APPLYING-FOR-ZAMBIAN-PASSPORT-AND-TRAVEL-DOCUMENT-OF-IDENTITY.pdf';
const _passportNote =
    'Named as a passport issuing centre in a Zambian Embassy document (2019). '
    'Address and contacts are not verified.';

GovOffice _rtsaTown(String town, String province) => GovOffice(
      id: 'rtsa_${town.toLowerCase()}',
      name: 'RTSA office - $town',
      authority: 'Road Transport and Safety Agency (RTSA)',
      province: province,
      town: town,
      serviceIds: const ['driving'],
      note: _rtsaTenderNote,
      sourceName: 'RTSA tender notice RTSA/ORD/10/2021',
      sourceUrl: _rtsaTender,
    );

GovOffice _passportCentre(String town, String province) => GovOffice(
      id: 'passport_${town.toLowerCase()}',
      name: 'Passport issuing centre - $town',
      authority: 'Dept. of National Registration, Passport and Citizenship',
      province: province,
      town: town,
      serviceIds: const ['passport'],
      note: _passportNote,
      sourceName: 'Embassy of Zambia, Stockholm - passport procedure',
      sourceUrl: _passportSheet,
    );

final List<GovOffice> govOffices = [
  // ------------------------------------------------------- Head offices
  const GovOffice(
    id: 'rtsa_hq',
    name: 'RTSA Head Office (Road Safety House)',
    authority: 'Road Transport and Safety Agency (RTSA)',
    province: 'Lusaka',
    town: 'Lusaka',
    address: 'Road Safety House, Dedan Kimathi Road, Plot No. 6956, P.O. Box 32167, Lusaka',
    contacts: [
      OfficeContact('Telephone', '+260 211 228798', ContactType.phone),
      OfficeContact('Hotline', '+260 955 983 983', ContactType.phone),
      OfficeContact('WhatsApp', '+260 96 5429499', ContactType.whatsapp),
      OfficeContact('Email', 'info@rtsa.org.zm', ContactType.email),
    ],
    serviceIds: ['driving'],
    isHeadOffice: true,
    note: 'Address and contacts as listed on the RTSA website.',
    sourceName: 'RTSA website - Contact Us',
    sourceUrl: _rtsaWebsite,
  ),
  const GovOffice(
    id: 'mohais_hq',
    name: 'Ministry of Home Affairs and Internal Security - Head Office',
    authority: 'Ministry of Home Affairs and Internal Security (oversees NRCs, birth registration and passports)',
    province: 'Lusaka',
    town: 'Lusaka',
    address: 'Independence Avenue, P.O. Box 50997, Lusaka',
    contacts: [
      OfficeContact('Citizen support portal', 'https://portal.citizensupport.gov.zm/',
          ContactType.website),
    ],
    serviceIds: ['nrc', 'birth', 'passport'],
    isHeadOffice: true,
    note: 'Ministry head office, as listed on the Ministry website. Ask which '
        'registration office serves your district.',
    sourceName: 'Ministry of Home Affairs and Internal Security - Contact Us',
    sourceUrl: 'https://www.mohais.gov.zm/?page_id=1692',
  ),

  // --------------------------------------- Passport centres (town only)
  _passportCentre('Lusaka', 'Lusaka'),
  _passportCentre('Ndola', 'Copperbelt'),
  _passportCentre('Livingstone', 'Southern'),

  // -------------------------------------------- RTSA offices (town only)
  _rtsaTown('Kabwe', 'Central'),
  _rtsaTown('Ndola', 'Copperbelt'),
  _rtsaTown('Luanshya', 'Copperbelt'),
  _rtsaTown('Chingola', 'Copperbelt'),
  _rtsaTown('Mufulira', 'Copperbelt'),
  _rtsaTown('Mokambo', 'Copperbelt'),
  _rtsaTown('Mansa', 'Luapula'),
  _rtsaTown('Kasama', 'Northern'),
];

/// Offices in [province], optionally only those relevant to [serviceId].
List<GovOffice> officesIn(String province, {String? serviceId}) => govOffices
    .where((o) => o.province == province)
    .where((o) => serviceId == null || o.serviceIds.contains(serviceId))
    .toList();

/// Head offices, optionally only those relevant to [serviceId].
List<GovOffice> headOffices({String? serviceId}) => govOffices
    .where((o) => o.isHeadOffice)
    .where((o) => serviceId == null || o.serviceIds.contains(serviceId))
    .toList();
