enum AnalyticsButton {
  settings('settings'),
  search('search'),
  editOrder('edit_order'),
  addTab('add_tab'),
  addEntry('add_entry'),
  importData('import_data'),
  exportData('export_data'),
  submitFeedback('submit_feedback'),
  home('home'),
  back('back')
  ;

  const AnalyticsButton(this.key);

  final String key;
}
