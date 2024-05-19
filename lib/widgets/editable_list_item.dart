import 'package:editable_list_item/provider/list_item_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
