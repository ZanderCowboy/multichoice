import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/i18n/strings.g.dart';

typedef AppTipStrings = ({String title, String body});

AppTipStrings appTipStrings(BuildContext context, AppTip tip) {
  final tips = context.t.tips;
  return switch (tip) {
    AppTip.collections => (
      title: tips.collectionsTitle,
      body: tips.collectionsBody,
    ),
    AppTip.addCollection => (
      title: tips.addCollectionTitle,
      body: tips.addCollectionBody,
    ),
    AppTip.addEntry => (
      title: tips.addEntryTitle,
      body: tips.addEntryBody,
    ),
    AppTip.entryActions => (
      title: tips.entryActionsTitle,
      body: tips.entryActionsBody,
    ),
    AppTip.editAndSearch => (
      title: tips.editAndSearchTitle,
      body: tips.editAndSearchBody,
    ),
    AppTip.drawer => (
      title: tips.drawerTitle,
      body: tips.drawerBody,
    ),
  };
}
