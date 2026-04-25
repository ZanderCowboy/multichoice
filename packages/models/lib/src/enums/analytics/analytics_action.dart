enum AnalyticsAction {
  tap('tap'),
  submit('submit'),
  success('success'),
  failure('failure'),
  create('create'),
  update('update'),
  delete('delete'),
  reorder('reorder'),
  open('open'),
  close('close'),
  search('search'),
  skip('skip'),
  next('next'),
  previous('previous'),
  reset('reset')
  ;

  const AnalyticsAction(this.key);

  final String key;
}
