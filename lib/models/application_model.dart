/*
 * *
 *  * Created by NullByte08 in 2024.
 *
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wit_by_bit/models/pizza_model.dart';

class ApplicationModelNotifier extends StateNotifier<ApplicationModel> {
  ApplicationModelNotifier()
      : super(ApplicationModel(
          mapOfSelectedPizzas: {},
        ));

  addPizza(PizzaModel pizzaModel) {
    var map = state.mapOfSelectedPizzas;
    map[pizzaModel.id] = (map[pizzaModel.id] ?? 0) + 1;
    state = ApplicationModel(
      mapOfSelectedPizzas: map,
    );
  }

  removePizza(PizzaModel pizzaModel) {
    var map = state.mapOfSelectedPizzas;
    int? currentNumber = map[pizzaModel.id];
    if (currentNumber != null && currentNumber > 0) {
      var newVal = currentNumber - 1;
      if (newVal == 0) {
        map.remove(pizzaModel.id);
      } else {
        map[pizzaModel.id] = newVal;
      }

      state = ApplicationModel(
        mapOfSelectedPizzas: map,
      );
    }
  }
}

class ApplicationModel {
  final Map<int, int> mapOfSelectedPizzas;

  ApplicationModel({required this.mapOfSelectedPizzas});
}

final applicationModelProvider = StateNotifierProvider<ApplicationModelNotifier, ApplicationModel>((ref) {
  return ApplicationModelNotifier();
});
