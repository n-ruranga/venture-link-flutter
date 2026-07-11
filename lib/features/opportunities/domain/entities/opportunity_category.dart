import 'package:flutter/material.dart';

enum OpportunityCategory {
  engineering('Engineering', Icons.code_rounded, Color(0xFF6366F1)),
  design('Design', Icons.brush_outlined, Color(0xFFEC4899)),
  marketing('Marketing', Icons.campaign_outlined, Color(0xFFF59E0B)),
  finance('Finance', Icons.account_balance_wallet_outlined, Color(0xFF10B981)),
  research('Research', Icons.science_outlined, Color(0xFF8B5CF6)),
  operations('Operations', Icons.settings_suggest_outlined, Color(0xFF64748B)),
  business('Business', Icons.business_center_outlined, Color(0xFF0EA5E9)),
  data('Data', Icons.analytics_outlined, Color(0xFF14B8A6));

  const OpportunityCategory(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

enum WorkMode {
  remote('Remote'),
  hybrid('Hybrid'),
  onCampus('On-campus');

  const WorkMode(this.label);

  final String label;
}
