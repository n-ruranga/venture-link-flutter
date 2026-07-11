abstract final class OpportunityStrings {
  static const String applyNow = 'Apply Now';
  static const String applied = 'Applied';
  static const String applying = 'Submitting...';
  static const String applicationSuccess =
      'Application submitted successfully!';
  static const String alreadyApplied = 'You have already applied for this role';
  static const String applyError = 'Could not submit application. Try again.';
  static const String offlineMessage =
      'You are offline. Showing cached opportunities.';
  static const String loadError = 'Failed to load opportunities';
  static const String emptyOpportunities =
      'No opportunities available yet. Check back soon!';
  static const String emptySearch =
      'No opportunities match your search';
  static const String emptyBookmarks = 'No saved opportunities yet';
  static const String verified = 'Verified Startup';
  static const String deadline = 'Application Deadline';
  static const String saved = 'Saved';
  static const String allOpportunities = 'All Opportunities';
  static const String exploreSubtitle =
      'Search and filter internships at ALU startups';
}

enum OpportunityStatus {
  active('active'),
  closed('closed'),
  draft('draft');

  const OpportunityStatus(this.value);

  final String value;

  static OpportunityStatus fromString(String? value) {
    return OpportunityStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OpportunityStatus.active,
    );
  }
}
