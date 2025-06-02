import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/static_keys.dart';

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
          description: 'Each item has actions you can perform. Try them out!',
          onBarrierClick: () {
            coreSl<ProductBloc>().add(const ProductEvent.nextStep());
          },
        );
      case ProductTourStep.showCollectionActions:
        return ShowcaseData(
          description: 'Collections also have their own set of actions.',
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
      case ProductTourStep.thanksPopup:
        return const ShowcaseData(
          description:
              "Thanks for completing the tour! You're all set to use MultiChoice.",
        );
      case ProductTourStep.none:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ProductTourStep.reset:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
