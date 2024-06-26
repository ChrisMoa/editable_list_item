import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const MyListViewWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ListItem {
  String name;
  int quantity;
  bool inStock;

  ListItem({
    required this.name,
    required this.quantity,
    required this.inStock,
  });
}

class ListItemNotifier extends StateNotifier<ListItem> {
  ListItemNotifier(super.state);

  void setName(String newName) {
    state = ListItem(name: newName, quantity: state.quantity, inStock: state.inStock);
  }

  void setQuantity(int newQuantity) {
    state = ListItem(name: state.name, quantity: newQuantity, inStock: state.inStock);
  }

  void setInStock(bool newInStock) {
    state = ListItem(name: state.name, quantity: state.quantity, inStock: newInStock);
  }
}

final listItemProvider = StateNotifierProvider.family<ListItemNotifier, ListItem, int>((ref, index) {
  return ListItemNotifier(ListItem(name: 'Item $index', quantity: index, inStock: index % 2 == 0));
});

class EditableListItem extends ConsumerWidget {
  final int index;

  const EditableListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(listItemProvider(index));
    final itemNotifier = ref.read(listItemProvider(index).notifier);

    return ListTile(
      title: TextField(
        controller: TextEditingController(text: item.name),
        onChanged: (newValue) {
          itemNotifier.setName(newValue);
        },
        decoration: const InputDecoration(
          labelText: 'Name',
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: item.quantity.toString()),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                itemNotifier.setQuantity(int.parse(value));
              }
            },
            decoration: const InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          Row(
            children: [
              const Text('In Stock'),
              Checkbox(
                value: item.inStock,
                onChanged: (bool? value) {
                  if (value != null) {
                    itemNotifier.setInStock(value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyListViewWidget extends ConsumerStatefulWidget {
  const MyListViewWidget({super.key});

  @override
  MyListViewWidgetState createState() => MyListViewWidgetState();
}

class MyListViewWidgetState extends ConsumerState<MyListViewWidget> {
  void _saveValues() {
    final items = List.generate(
      10,
      (index) => ref.read(listItemProvider(index)),
    );

    if (kDebugMode) {
      print(items.map((item) => '${item.name}, ${item.quantity}, ${item.inStock}').toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return EditableListItem(index: index);
            },
          ),
        ),
        ElevatedButton(
          onPressed: _saveValues,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
