enum AnalyticsEntity {
  tab('tab'),
  entry('entry'),
  allTabs('all_tabs'),
  allEntries('all_entries'),
  feedback('feedback'),
  tutorial('tutorial')
  ;

  const AnalyticsEntity(this.key);

  final String key;
}
