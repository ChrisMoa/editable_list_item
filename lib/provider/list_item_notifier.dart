import 'package:editable_list_item/model/list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListItemNotifier extends StateNotifier<ListItem> {
  ListItemNotifier(ListItem state) : super(state);

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
