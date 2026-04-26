part of 'details_bloc.dart';

sealed class DetailsEvent {
  const DetailsEvent();

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

final class OnPopulateDetails extends DetailsEvent {
  const OnPopulateDetails(this.result);

  final SearchResult result;
}

final class OnChangeTitleDetails extends DetailsEvent {
  const OnChangeTitleDetails(this.value);

  final String value;
}

final class OnChangeSubtitleDetails extends DetailsEvent {
  const OnChangeSubtitleDetails(this.value);

  final String value;
}

final class OnToggleEditModeDetails extends DetailsEvent {
  const OnToggleEditModeDetails();
}

final class OnDeleteChildDetails extends DetailsEvent {
  const OnDeleteChildDetails(this.id);

  final int id;
}

final class OnDeleteDetails extends DetailsEvent {
  const OnDeleteDetails();
}

final class OnSubmitDetails extends DetailsEvent {
  const OnSubmitDetails();
}
