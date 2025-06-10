part of '../tour_widget_wrapper.dart';

ShowcaseData _getProductTourData(ProductTourStep step) {
  switch (step) {
    case ProductTourStep.welcomePopup:
      return ShowcaseData.empty();
    case ProductTourStep.showCollection:
      return ShowcaseData(
        description:
            'This is your collection view. Here you can see all your collections.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
      );
    case ProductTourStep.showItemsInCollection:
      return ShowcaseData(
        description:
            'Each collection contains items. Click on a collection to see its items.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
      );
    case ProductTourStep.addNewCollection:
      return ShowcaseData(
        description: 'Click here to create a new collection.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
      );
    case ProductTourStep.addNewItem:
      return ShowcaseData(
        description: 'Add new items to your collection here.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
      );
    case ProductTourStep.showItemActions:
      return ShowcaseData(
        description:
            'Each item has actions you can perform. Try them out! Tap to view details, double tap to edit, and long press to open menu.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
      );
    case ProductTourStep.showCollectionActions:
      return ShowcaseData(
        description:
            'Collections also have their own set of actions. Long press to delete.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
      );
    case ProductTourStep.showCollectionMenu:
      return ShowcaseData(
        description: 'Access collection options through this menu.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
      );
    case ProductTourStep.showSettings:
      return ShowcaseData(
        description: 'Tap here to access settings and more options here.',
        onTargetClick: () {
          scaffoldKeyTutorial.currentState?.openDrawer();
          Future.delayed(
            const Duration(milliseconds: 350),
            () => coreSl<ProductBloc>().add(const ProductEvent.nextStep()),
          );
        },
      );
    case ProductTourStep.showAppearanceSection:
      return ShowcaseData(
        title: 'Appearance Settings',
        description: 'Customize the appearance of your collections here.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
        tooltipPosition: Position.top,
      );
    case ProductTourStep.showDataSection:
      return ShowcaseData(
        title: 'Data Management',
        description: 'Manage your data and backups in this section.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
        tooltipPosition: Position.top,
      );
    case ProductTourStep.showMoreSection:
      return ShowcaseData(
        title: 'More Options',
        description: 'Explore additional features in the More section.',
        onTargetClick: () {
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
        tooltipPosition: Position.top,
      );
    case ProductTourStep.closeSettings:
      return ShowcaseData(
        description:
            'Tap here to close settings to return to your collections.',
        onTargetClick: () {
          scaffoldKeyTutorial.currentState?.closeDrawer();
          coreSl<ProductBloc>().add(const ProductEvent.nextStep());
        },
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
