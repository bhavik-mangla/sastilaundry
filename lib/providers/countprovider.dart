import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/categ.dart';

class CountProvider with ChangeNotifier {
  List<int> count;
  CountProvider(this.count);

  void incrementCount(int itemNo) {
    int currentValue = count[itemNo];
    currentValue++;
    count[itemNo] = currentValue;
    notifyListeners();
  }

  void decrementCount(int itemNo) {
    int currentValue = count[itemNo];
    if (currentValue > 0) {
      currentValue--;
      count[itemNo] = currentValue;
      notifyListeners();
    }
  }

  void resetCount() {
    count = List<int>.filled(items.length, 0);
    notifyListeners();
  }
}

class PriceProvider with ChangeNotifier {
  List<int> price;
  PriceProvider(this.price);

  void resetCount() {
    price = List<int>.filled(items.length, 0);
    notifyListeners();
  }

  void updatePrice(int itemNo, int itemPrice) {
    price[itemNo] = itemPrice;
    notifyListeners();
  }
}
