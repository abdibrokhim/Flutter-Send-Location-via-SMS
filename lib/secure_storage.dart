// import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// class StorageService {
//   static Future<void> storeAccess(Map<String, Map<String, String>> data) async {
//     await addNewItemToKeyChain(data);
//   }

//   static Future<void> addNewItemToKeyChain(Map<String, Map<String, String>> data) async {
//     IOSOptions getIOSOptions() => const IOSOptions(
//           accountName: AppleOptions.defaultAccountName,
//         );

//     AndroidOptions getAndroidOptions() => const AndroidOptions(
//           encryptedSharedPreferences: true,
//         );
//     const storage = FlutterSecureStorage();

//     await storage.write(
//       key: "uuid",
//       value: data['uuid']!.toString(),
//       iOptions: getIOSOptions(),
//       aOptions: getAndroidOptions(),
//     );
//     await storage.write(
//       key: "name",
//       value: value,
//       iOptions: getIOSOptions(),
//       aOptions: getAndroidOptions(),
//     );
//     await storage.write(
//       key: "uuid",
//       value: value,
//       iOptions: getIOSOptions(),
//       aOptions: getAndroidOptions(),
//     );
//   }

//   static Future<Map<String, String>> readItemsFromToKeyChain() async {
//     const storage = FlutterSecureStorage();
//     IOSOptions getIOSOptions() => const IOSOptions(
//           accountName: AppleOptions.defaultAccountName,
//         );

//     AndroidOptions getAndroidOptions() => const AndroidOptions(
//           encryptedSharedPreferences: true,
//         );
//     return await storage.readAll(
//       iOptions: getIOSOptions(),
//       aOptions: getAndroidOptions(),
//     );
//   }

//   static Future<void> clearAccessStorage() async {
//     const storage = FlutterSecureStorage();
//     IOSOptions getIOSOptions() => const IOSOptions(
//           accountName: AppleOptions.defaultAccountName,
//         );

//     AndroidOptions getAndroidOptions() => const AndroidOptions(
//           encryptedSharedPreferences: true,
//         );
//     try {
//       await storage.delete(
//         key: "uuid",
//         iOptions: getIOSOptions(),
//         aOptions: getAndroidOptions(),
//       );
//     } catch (e) {
//       return Future.error(e);
//     }
//   }
// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static Future<void> storeData(Map<String, dynamic> data) async {
    // Assuming data is a map with keys as strings and values as maps
    // Example: data = {'3': {'name': 'Sister', 'number': '998909157824'}}
    await _writeToKeychain(data);
  }

  static Future<void> _writeToKeychain(Map<String, dynamic> data) async {
    IOSOptions getIOSOptions() => const IOSOptions(
          accountName: AppleOptions.defaultAccountName,
        );

    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    const storage = FlutterSecureStorage();

    for (var entry in data.entries) {
      String key = entry.key;
      Map<String, String> valueMap = entry.value.cast<String, String>();
      for (var valueEntry in valueMap.entries) {
        String valueKey = valueEntry.key;
        String value = valueEntry.value;
        await storage.write(
          key: '$key-$valueKey', // Store with combined key to avoid conflicts
          value: value,
          iOptions: getIOSOptions(),
          aOptions: getAndroidOptions(),
        );
      }
    }
  }

  static Future<Map<String, dynamic>> readItemsFromToKeyChain() async {
    const storage = FlutterSecureStorage();
    IOSOptions getIOSOptions() => const IOSOptions(
          accountName: AppleOptions.defaultAccountName,
        );

    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    return await storage.readAll(
      iOptions: getIOSOptions(),
      aOptions: getAndroidOptions(),
    );
  }

  static Future<void> clearAccessStorage() async {
    const storage = FlutterSecureStorage();
    IOSOptions getIOSOptions() => const IOSOptions(
          accountName: AppleOptions.defaultAccountName,
        );

    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    try {
      await storage.delete(
        key: "uuid",
        iOptions: getIOSOptions(),
        aOptions: getAndroidOptions(),
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}