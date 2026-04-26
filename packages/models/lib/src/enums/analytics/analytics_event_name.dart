enum AnalyticsEventName {
  uiAction('ui_action'),
  crudAction('crud_action'),
  search('search'),
  searchResultOpened('search_result_opened'),
  tutorialAction('tutorial_action'),
  feedbackAction('feedback_action')
  ;

  const AnalyticsEventName(this.key);

  final String key;
}
