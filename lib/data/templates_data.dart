import 'package:flutter/material.dart';

import '../models/gov_service.dart';
import '../models/prep_template.dart';

// Unofficial preparation aids written for this app. They are not
// government forms and must never be presented as one.

const List<PrepTemplate> prepTemplates = [
  PrepTemplate(
    id: 'tpl_general',
    title: 'General document preparation',
    description: 'A simple routine to get any set of documents ready.',
    icon: Icons.folder_open_outlined,
    checklist: [
      ChecklistItem('g_list', 'Write down every document the service asks for'),
      ChecklistItem('g_originals', 'Find the originals and keep them in one folder'),
      ChecklistItem('g_copies', 'Make clear photocopies of each document'),
      ChecklistItem('g_names', 'Check names and dates match across all documents'),
      ChecklistItem('g_photos', 'Get passport-size photos if the service needs them'),
      ChecklistItem('g_confirm', 'Confirm current requirements and fees with the office'),
    ],
  ),
  PrepTemplate(
    id: 'tpl_visit',
    title: 'Office visit preparation',
    description: 'What to sort out before you travel to an office.',
    icon: Icons.event_available_outlined,
    checklist: [
      ChecklistItem('v_office', 'Confirm which office handles your service'),
      ChecklistItem('v_hours', 'Confirm the opening hours and the day you will go'),
      ChecklistItem('v_folder', 'Pack your document folder (originals and copies)'),
      ChecklistItem('v_people', 'Arrange for anyone who must come with you (e.g. a deponent)'),
      ChecklistItem('v_money', 'Bring enough money for fees and transport'),
      ChecklistItem('v_pen', 'Bring a pen and leave early to allow for queues'),
    ],
  ),
  PrepTemplate(
    id: 'tpl_worksheet',
    title: 'Personal information practice worksheet',
    description:
        'Practise organising details forms often ask for. Fill it in on paper. The app does not store it.',
    icon: Icons.edit_note_outlined,
    worksheetFields: [
      'Full name (as on your documents)',
      'Other names used before (if any)',
      'Date of birth',
      'Place of birth (village/town, district, province)',
      "Father's full name",
      "Mother's full name",
      'Current residential address',
      'Contact phone number',
      'Name of a person who can accompany you (if needed)',
    ],
  ),
  PrepTemplate(
    id: 'tpl_driving',
    title: 'Driving licence preparation',
    description: 'Step-by-step prep for a first provisional and full driving licence.',
    icon: Icons.directions_car_outlined,
    checklist: [
      ChecklistItem('d_age', 'Confirm you are at least 18 (16 for a motorcycle licence)'),
      ChecklistItem('d_medical', 'Get a medical certificate'),
      ChecklistItem('d_id_copy', 'Photocopy your NRC or passport'),
      ChecklistItem('d_study', 'Study road rules for the theory test'),
      ChecklistItem('d_office', 'Confirm with RTSA which office to visit'),
      ChecklistItem('d_provisional', 'Get your provisional driving licence'),
      ChecklistItem('d_practise', 'Practise driving with a qualified driver or driving school'),
      ChecklistItem('d_test', 'Take the practical driving test'),
      ChecklistItem('d_print', 'Pay for printing of your full licence'),
    ],
  ),
];
