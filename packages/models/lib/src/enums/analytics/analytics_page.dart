enum AnalyticsPage {
  home('home'),
  settings('settings'),
  search('search'),
  details('details'),
  editTab('edit_tab'),
  editEntry('edit_entry'),
  feedback('feedback'),
  tutorial('tutorial'),
  changelog('changelog'),
  dataTransfer('data_transfer')
  ;

  const AnalyticsPage(this.key);

  final String key;
}
