import 'package:flutter/material.dart';
import 'package:multichoice/constants/spacing_constants.dart';
import 'package:multichoice/utils/custom_scroll_behaviour.dart';

part 'widgets/main_tab.dart';
part 'widgets/entry_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multichoice'),
        centerTitle: true,
        leading: const Drawer(),
        backgroundColor: Colors.lightBlue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          height: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VerticalTab(
                title: 'To Watch',
                subtitle: 'things to watch',
              ),
              gap_12,
              VerticalTab(
                title: 'Watching',
                subtitle: 'things busy watching',
              ),
              gap_12,
              VerticalTab(
                title: 'Finished',
                subtitle: 'things we finised watching',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
