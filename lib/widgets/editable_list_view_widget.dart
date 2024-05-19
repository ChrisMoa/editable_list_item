import 'package:editable_list_item/widgets/editable_list_item.dart';
import 'package:editable_list_item/provider/list_item_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyListViewWidget extends ConsumerStatefulWidget {
  const MyListViewWidget({super.key});

  @override
  _MyListViewWidgetState createState() => _MyListViewWidgetState();
}

class _MyListViewWidgetState extends ConsumerState<MyListViewWidget> {
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
