import 'package:flutter/material.dart';

import '../models/gov_service.dart';

// Requirements, steps and fees below were summarised from these official
// pages on 15 October 2026. Re-check them before relying on this app:
//  - DNRPC page, Ministry of Home Affairs and Internal Security:
//    https://www.mohais.gov.zm/?page_id=1610
//  - RTSA Driver Licencing page: https://www.rtsa.org.zm/transport/driver-licencing/
//
// "Before you apply" lists are general advice written for this app.
// Office details live in offices_data.dart.

const String lastCheckedDate = '15 October 2026';

/// The ten provinces of Zambia.
const List<String> zambianProvinces = [
  'Central',
  'Copperbelt',
  'Eastern',
  'Luapula',
  'Lusaka',
  'Muchinga',
  'Northern',
  'North-Western',
  'Southern',
  'Western',
];

const _dnrpcSource = OfficialSource(
  'Dept. of National Registration, Passport and Citizenship (Ministry of Home Affairs and Internal Security)',
  'https://www.mohais.gov.zm/?page_id=1610',
);

const _dnrpcAuthority =
    'Department of National Registration, Passport and Citizenship (DNRPC), '
    'Ministry of Home Affairs and Internal Security';

const List<GovService> govServices = [
  // ---------------------------------------------------------------- NRC
  GovService(
    id: 'nrc',
    name: 'National Registration Card (NRC)',
    shortName: 'NRC',
    shortDescription: 'Your national identity card, for ages 16 and above.',
    icon: Icons.badge_outlined,
    keywords: ['nrc', 'id', 'identity', 'national registration', 'card', 'green card'],
    overview:
        'The National Registration Card (NRC) is a national identity document. '
        'Green NRCs are issued to Zambian citizens, pink NRCs to Commonwealth '
        'nationals, and blue NRCs to other foreign nationals. You need a copy '
        'of your NRC for other services, such as a passport or driving licence.',
    beforeYouApply: [
      'Arrange for your deponent (a parent, biological relative or legal guardian) to come with you on the day.',
      'Bring original documents and keep photocopies ready.',
      'Check that names and dates match across all your documents.',
      'Confirm the office location and opening hours before you travel.',
    ],
    requirements: [
      ChecklistItem('nrc_age', 'Be 16 years or older at the time of applying'),
      ChecklistItem('nrc_birth_proof',
          'Proof of birth in Zambia: birth certificate, record of birth, or under-five card'),
      ChecklistItem('nrc_deponent',
          'A deponent to accompany you (parent, biological relative or legal guardian) for first registration'),
      ChecklistItem('nrc_deponent_copy', "A copy of your deponent's NRC"),
      ChecklistItem('nrc_born_abroad',
          'If born outside Zambia: proof of citizenship (e.g. travel documents, parents\' identity, citizenship or naturalisation certificate)'),
    ],
    requirementsStatus: InfoStatus.official,
    steps: [
      'Go to a National Registration office with your deponent and documents. The official page states this service is not available online.',
      'Complete the application form with your full name, your parents\' details and your address.',
      'Submit the form together with your deponent\'s NRC copy.',
      'Your passport-size photo is taken and placed on the card.',
      'Check your photo and all details on the card carefully.',
    ],
    stepsStatus: InfoStatus.official,
    authority: _dnrpcAuthority,
    officeGuidance:
        'NRCs are issued by the DNRPC. The Department works at district level, '
        'so ask your district office whether NRCs are currently being issued there.',
    sources: [_dnrpcSource],
    lastChecked: lastCheckedDate,
  ),

  // ---------------------------------------------------- Birth certificate
  GovService(
    id: 'birth',
    name: 'Birth Certificate',
    shortName: 'Birth Certificate',
    shortDescription: 'Register a birth and get the official certificate.',
    icon: Icons.child_friendly_outlined,
    keywords: ['birth', 'certificate', 'baby', 'child', 'registration', 'born'],
    overview:
        'Birth registration is the official recording of a child\'s birth. '
        'Under the Births and Deaths Registration Act (Cap 51), the birth of every '
        'child born in Zambia must be registered. The birth certificate is used to '
        'enrol in school, college or university, and to obtain an NRC or passport.',
    beforeYouApply: [
      'Register the birth as soon as possible. Registration is compulsory.',
      'If the child was born at home, arrange an independent witness early.',
      'Agree on the spelling of the child\'s names before filling in forms.',
      'Bring the parents\' identity documents in case the office asks for them.',
    ],
    requirements: [
      ChecklistItem('birth_informant',
          'An informant with legal authority: a biological parent, relative or legal guardian (or the person in charge of the hospital, if parents cannot)'),
      ChecklistItem('birth_forms', 'Duly completed prescribed forms'),
      ChecklistItem('birth_notice', 'Notice of birth'),
      ChecklistItem('birth_witness', 'Independent witness form (if the child was born at home)'),
    ],
    requirementsStatus: InfoStatus.official,
    steps: [
      'Obtain the prescribed birth registration forms. Ask the registration office where to get them. The official page states this service is not available online.',
      'Record the child\'s names, place and date of birth, and the parents\' details on the form.',
      'Attach the notice of birth, plus the independent witness form if the child was born at home.',
      'Submit the forms. The birth certificate is then issued.',
    ],
    stepsStatus: InfoStatus.official,
    authority: _dnrpcAuthority,
    officeGuidance:
        'Births are registered through the DNRPC. The Department works at district '
        'level. Ask your district registration office where to submit the forms.',
    fees: [
      FeeItem('First issue of a birth certificate', 'Free'),
      FeeItem('Lost birth certificate', 'K310.00'),
      FeeItem('Replacement (any reason)', 'K220.00'),
    ],
    sources: [_dnrpcSource],
    lastChecked: lastCheckedDate,
  ),

  // ------------------------------------------------------------- Passport
  GovService(
    id: 'passport',
    name: 'Passport',
    shortName: 'Passport',
    shortDescription: 'National travel document for travelling abroad.',
    icon: Icons.flight_takeoff_outlined,
    keywords: ['passport', 'travel', 'abroad', 'visa', 'trip'],
    overview:
        'A passport is a national travel document. Passports are valid for 5 years '
        'for children and 10 years for adults. You must apply in person at a Passport '
        'and Citizenship office, or at the nearest Zambian mission or consulate if '
        'you are abroad.',
    beforeYouApply: [
      'The checklist below is for applicants aged 16 and above. Children under 16 need different forms (completed by a parent or guardian). See the official source.',
      'Find a recommender early: they must have known you for at least 2 years and cannot be a family member.',
      'Photocopies must be certified as true copies by a Commissioner for Oaths.',
      'Lost passport? You will also need a police report and a sworn affidavit.',
    ],
    requirements: [
      ChecklistItem('pp_barcode', 'Completed passport application Bar Code Form'),
      ChecklistItem('pp_form_a', 'Completed Form A'),
      ChecklistItem('pp_affidavit', 'Completed affidavit form'),
      ChecklistItem('pp_photos',
          'Two recent passport-size photos with a clear/white background, not mounted (confirm exact size at the office)'),
      ChecklistItem('pp_recommender',
          'One photo endorsed by a recommender who has known you for at least 2 years (not a family member)'),
      ChecklistItem('pp_nrc', 'Photocopy of your NRC'),
      ChecklistItem('pp_birth', 'Copy of your birth certificate'),
      ChecklistItem('pp_marriage', 'If married: copy of marriage certificate (or an affidavit)'),
      ChecklistItem('pp_previous', 'If renewing: copies of details from your previous passport'),
      ChecklistItem('pp_certified', 'All photocopies certified by a Commissioner for Oaths'),
    ],
    requirementsStatus: InfoStatus.official,
    steps: [
      'Prepare your documents and have the photocopies certified by a Commissioner for Oaths.',
      'Ask your recommender to endorse one of your photos.',
      'Go in person to a Passport and Citizenship office (or the nearest Zambian mission if abroad).',
      'Complete the forms, make payment and attend the interview.',
      'Submit your application.',
    ],
    stepsStatus: InfoStatus.official,
    authority: _dnrpcAuthority,
    officeGuidance:
        'Passports are issued by the DNRPC. Apply in person at a Passport and '
        'Citizenship office, or at the nearest Zambian mission or consulate abroad.',
    fees: [
      FeeItem('32-page ordinary passport', 'K320.00'),
      FeeItem('48-page passport', 'K520.00'),
      FeeItem('Express service (extra)', 'K200.00'),
    ],
    sources: [
      _dnrpcSource,
      OfficialSource('ZamPortal - Government services portal', 'https://zamportal.gov.zm/'),
    ],
    lastChecked: lastCheckedDate,
  ),

  // ------------------------------------------------------ Driving licence
  GovService(
    id: 'driving',
    name: 'Driving Licence',
    shortName: 'Driving Licence',
    shortDescription: 'Get a provisional licence, pass your test, then your full licence.',
    icon: Icons.directions_car_outlined,
    keywords: ['driving', 'licence', 'license', 'car', 'rtsa', 'provisional', 'learner', 'drive'],
    overview:
        'A driving licence allows you to drive on public roads. New drivers first '
        'get a provisional driving licence, then take a practical driving test. '
        'After passing, the full licence is printed. Driver licensing is handled '
        'by the Road Transport and Safety Agency (RTSA).',
    beforeYouApply: [
      'Get your medical certificate first. It is required for a provisional licence.',
      'Make a clear photocopy of your NRC or passport.',
      'Study road rules before your theory test.',
      'Practise driving with a qualified driver or a driving school before the practical test.',
      'Budget for the provisional licence, the practical test and printing (see fees below).',
    ],
    requirements: [
      ChecklistItem('dl_medical', 'Medical certificate'),
      ChecklistItem('dl_age',
          'Be at least 18 years old (16 for a provisional rider\'s / motorcycle licence)'),
      ChecklistItem('dl_id', 'Copy of identity: NRC or passport'),
    ],
    requirementsStatus: InfoStatus.official,
    steps: [
      'Get a medical certificate and a copy of your NRC or passport.',
      'Visit an RTSA office and ask how to book the theory test.',
      'Pay for and collect your provisional driving licence.',
      'Practise driving. RTSA states the practical test fee is payable 7 days after getting your provisional licence.',
      'Take the practical driving test.',
      'After passing, pay for printing of your driving licence.',
    ],
    stepsStatus: InfoStatus.needsVerification,
    stepsNote:
        'This order is put together from the fee notes on the RTSA page, which links '
        'the provisional licence fee to the theory test. Confirm the exact process with RTSA.',
    authority: 'Road Transport and Safety Agency (RTSA)',
    officeGuidance:
        'Driver licensing is handled by RTSA. Check with RTSA which office near you '
        'offers theory and practical driving tests before you travel.',
    fees: [
      FeeItem('Provisional driving licence', 'K117.00'),
      FeeItem('Practical driving test', 'K87.00'),
      FeeItem('Printing of licence after passing', 'K144.00'),
    ],
    sources: [
      OfficialSource('RTSA - Driver Licencing',
          'https://www.rtsa.org.zm/transport/driver-licencing/'),
      OfficialSource('ZamPortal - Services for drivers',
          'https://zamportal.gov.zm/service-category/for-drivers/'),
    ],
    lastChecked: lastCheckedDate,
  ),
];

GovService serviceById(String id) => govServices.firstWhere((s) => s.id == id);
