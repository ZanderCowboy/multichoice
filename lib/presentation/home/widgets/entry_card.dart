part of '../home_page.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: Colors.blueGrey,
      child: const SizedBox(
        height: 60,
        width: 200,
        // decoration: BoxDecoration(
        //   boxShadow: [BoxShadow(color: Colors.white)],
        //   color: Colors.blueGrey,
        // ),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('Title'),
                    Text('Subtitle'),
                  ],
                ),
              ),
              Placeholder(
                fallbackHeight: 40,
                fallbackWidth: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
