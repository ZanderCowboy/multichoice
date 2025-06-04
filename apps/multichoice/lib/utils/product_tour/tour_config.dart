import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/app/export.dart';

class TourConfig {
  static ShowcaseData getShowcaseData(ProductTourStep step) {
    switch (step) {
      case ProductTourStep.welcomePopup:
        return ShowcaseData.empty();
      case ProductTourStep.showCollection:
        return ShowcaseData(
          description:
              'This is your collection view. Here you can see all your collections.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.showItemsInCollection:
        return ShowcaseData(
          description:
              'Each collection contains items. Click on a collection to see its items.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.addNewCollection:
        return ShowcaseData(
          description: 'Click here to create a new collection.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.addNewItem:
        return ShowcaseData(
          description: 'Add new items to your collection here.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.showItemActions:
        return ShowcaseData(
          description:
              'Each item has actions you can perform. Try them out! Tap to view details, double tap to edit, and long press to open menu.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.showCollectionActions:
        return ShowcaseData(
          description:
              'Collections also have their own set of actions. Long press to delete.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.showCollectionMenu:
        return ShowcaseData(
          description: 'Access collection options through this menu.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.showSettings:
        return ShowcaseData(
          description: 'Access settings and more options here.',
          onTargetClick: () {
            scaffoldKey.currentState?.openDrawer();
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
          disposeOnTap: true,
          disableBarrierInteraction: true,
        );
      case ProductTourStep.showDetails:
        return ShowcaseData(
          description: 'View item details here.',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
          overlayOpacity: 0.3,
        );
      case ProductTourStep.closeSettings:
        return ShowcaseData(
          description: 'Close settings to return to your collections.',
          onTargetClick: () {
            scaffoldKey.currentState?.closeDrawer();
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
          disposeOnTap: true,
          disableBarrierInteraction: true,
        );
      case ProductTourStep.thanksPopup:
        return const ShowcaseData(
          description:
              "Thanks for completing the tour! You're all set to use MultiChoice.",
        );
      case ProductTourStep.noneCompleted:
      case ProductTourStep.reset:
        return ShowcaseData.empty();
    }
  }
}
