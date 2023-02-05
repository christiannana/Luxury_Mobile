import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';


class StorageSrevice {
  // LocalStorage storage =  LocalStorage('luxury_db');
  final storage = GetStorage();

  onSaveData(key, value) {
    storage.write(key, value);
  }

  onReadData(key) {
   return storage.read(key);
  }
  
  onDeleteData(key) {
   storage.remove(key);
  }

 
}
