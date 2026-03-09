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
  goHome('go_home'),
  back('back'),
  followTutorial('follow_tutorial'),
  continueTutorial('continue_tutorial'),
  layout('layout_switch'),
  theme('theme_switch'),
  about('about'),
  ;

  const AnalyticsButton(this.key);

  final String key;
}
