enum AnalyticsParamKey {
  page('page'),
  previousPage('previous_page'),
  button('button'),
  action('action'),
  entity('entity'),
  tabId('tab_id'),
  entryId('entry_id'),
  itemCount('item_count'),
  queryLength('query_length'),
  resultCount('result_count'),
  resultType('result_type'),
  tutorialStep('tutorial_step'),
  rating('rating'),
  category('category'),
  source('source'),
  errorMessage('error_message')
  ;

  const AnalyticsParamKey(this.key);

  final String key;
}
