part of 'details_bloc.dart';

@freezed
class DetailsEvent with _$DetailsEvent {
  const factory DetailsEvent.onPopulate(SearchResult result) =
      OnPopulateDetails;
  const factory DetailsEvent.onChangeTitle(String value) = OnChangeTitleDetails;
  const factory DetailsEvent.onChangeSubtitle(String value) =
      OnChangeSubtitleDetails;
  const factory DetailsEvent.onToggleEditMode() = OnToggleEditModeDetails;
  const factory DetailsEvent.onDeleteChild(int id) = OnDeleteChildDetails;
  const factory DetailsEvent.onDelete() = OnDeleteDetails;
  const factory DetailsEvent.onSubmit() = OnSubmitDetails;
}
