# Zambia LifeID

A small Flutter (Android) class-project MVP that helps people in Zambia prepare
to apply for essential documents: National Registration Card (NRC), Birth
Certificate, Passport and Driving Licence.

It is a preparation guide, **not** an official government app.

## Run

```bash
flutter pub get
flutter run
```

Tests: `flutter test` · Static analysis: `flutter analyze`

## Project layout

```
lib/
  main.dart                     App entry, bottom navigation (Home / Offices / Templates / My Lists)
  theme.dart                    Colours and Material theme
  models/                       GovService, ChecklistItem, PrepTemplate ...
  data/services_data.dart       The four services (requirements, steps, fees, sources)
  data/templates_data.dart      Unofficial preparation templates
  data/offices_data.dart        Government offices (only details confirmed by a source)
  services/checklist_store.dart Saves ticked checklist items on the device (shared_preferences)
  screens/                      Home, service details, checklist, offices, templates, my lists
  widgets/                      Reusable cards, badges, checklist widgets, source links
```

## Information sources (checked 15 October 2026)

- Dept. of National Registration, Passport and Citizenship, Ministry of Home
  Affairs and Internal Security: https://www.mohais.gov.zm/?page_id=1610
- RTSA Driver Licencing: https://www.rtsa.org.zm/transport/driver-licencing/
- ZamPortal: https://zamportal.gov.zm/
- RTSA tender notice RTSA/ORD/10/2021 (names RTSA offices by town):
  https://www.rtsa.org.zm/wp-content/uploads/2021/08/Open-Tender-Adverts-for-Branding-Offices.pdf
- Embassy of Zambia, Stockholm, passport procedure (2019, names passport centres):
  https://zambiaembassy.se/wp-content/uploads/2019/05/PROCEDURE-FOR-APPLYING-FOR-ZAMBIAN-PASSPORT-AND-TRAVEL-DOCUMENT-OF-IDENTITY.pdf

Each section in the app is labelled as **From official source**, **General
advice**, or **Needs official verification**. Only the RTSA and Ministry head
offices have a verified address and contacts. Other offices are confirmed by
town only, and the app shows "Address not verified" for them.

## Note

The unused `windows/` and `linux/` desktop folders were removed because plugin
symlinks need Windows Developer Mode. Recreate them if ever needed with
`flutter create --platforms=windows,linux .`
