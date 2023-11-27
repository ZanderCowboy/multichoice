import 'package:flutter/material.dart';
import 'package:multichoice/constants/spacing_constants.dart';
import 'package:multichoice/presentation/home/widgets/custom_dialog.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

part 'widgets/main_tab.dart';
part 'widgets/entry_card.dart';
part 'widgets/empty_tab.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ScrollController scrollController = ScrollController();

  List tabs = [
    const VerticalTab(title: 'title', subtitle: 'subtitle'),
    const VerticalTab(title: 'title', subtitle: 'subtitle'),
    const VerticalTab(title: 'title', subtitle: 'subtitle'),
    const VerticalTab(title: 'title', subtitle: 'subtitle'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multichoice'),
        centerTitle: true,
        leading: const Drawer(),
        backgroundColor: Colors.lightBlue,
        actions: const <Widget>[
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.add_outlined,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height / 1.375,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: CustomScrollBehaviour(),
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length + 1,
                    itemBuilder: (context, index) {
                      if (index == tabs.length) {
                        return const EmptyTab();
                      } else {
                        return tabs[index];
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
