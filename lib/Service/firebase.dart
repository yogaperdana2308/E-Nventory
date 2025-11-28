import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enventory/model/sales_model_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/firebase_model.dart';
import '../model/item_firebase.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // =============================================================
  //                        AUTH SERVICE
  // =============================================================

  Future<UserFirebaseModel> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final userModel = UserFirebaseModel(
      uid: uid,
      username: username,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );

    await firestore.collection("users").doc(uid).set(userModel.toMap());
    return userModel;
  }

  Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final snap = await firestore.collection("users").doc(uid).get();
    if (!snap.exists) return null;

    return UserFirebaseModel.fromMap(snap.data()!);
  }

  Future<void> updateUsername({
    required String uid,
    required String newUsername,
  }) async {
    await firestore.collection("users").doc(uid).update({
      "username": newUsername,
      "updateAt": DateTime.now().toIso8601String(),
    });
  }

  // =============================================================
  //                        ITEM SERVICE
  // =============================================================

  /// Tambah item
  Future<void> createItem(ItemFirebase item) async {
    final doc = firestore.collection("items").doc(); // generate ID

    final newItem = ItemFirebase(
      id: doc.id, // simpan ID ke model
      name: item.name,
      stock: item.stock,
      modal: item.modal,
      price: item.price,
      date: item.date,
    );

    await doc.set(newItem.toMap());
  }

  /// Ambil semua item
  Future<List<ItemFirebase>> getAllItems() async {
    final snap = await firestore.collection("items").get();
    return snap.docs
        .map((doc) => ItemFirebase.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Ambil 1 item
  Future<ItemFirebase?> getItem(String id) async {
    final snap = await firestore.collection("items").doc(id).get();
    if (!snap.exists) return null;
    return ItemFirebase.fromMap(snap.id, snap.data()!);
  }

  /// Update item
  Future<void> updateItem(ItemFirebase item) async {
    await firestore.collection("items").doc(item.id).update(item.toMap());
  }

  /// Hapus item
  Future<void> deleteItem(String id) async {
    await firestore.collection("items").doc(id).delete();
  }

  /// Kurangi stok setelah transaksi
  Future<void> reduceStock(String itemId, int qty) async {
    final doc = await firestore.collection("items").doc(itemId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final currentStock = data['stock'] ?? 0;
    final newStock = currentStock - qty;

    await firestore.collection("items").doc(itemId).update({
      'stock': newStock < 0 ? 0 : newStock,
    });
  }

  // =============================================================
  //                        SALES SERVICE
  // =============================================================

  /// Tambah penjualan
  Future<void> createSales(SalesModelFirebase sales) async {
    final doc = firestore.collection("sales").doc();

    final newSales = SalesModelFirebase(
      id: doc.id,
      itemId: sales.itemId,
      quantity: sales.quantity,
      price: sales.price,
      sales: sales.sales,
      date: sales.date,
    );

    await doc.set(newSales.toMap());
  }

  /// Ambil semua penjualan
  Future<List<SalesModelFirebase>> getAllSales() async {
    final snap = await firestore.collection("sales").get();

    return snap.docs
        .map((doc) => SalesModelFirebase.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Ambil penjualan berdasarkan range tanggal (buat chart)
  Future<List<SalesModelFirebase>> getSalesInDateRange({
    required String startDate,
    required String endDate,
  }) async {
    final snap = await firestore
        .collection("sales")
        .where("date", isGreaterThanOrEqualTo: startDate)
        .where("date", isLessThanOrEqualTo: endDate)
        .get();

    return snap.docs
        .map((doc) => SalesModelFirebase.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Update penjualan
  Future<void> updateSales(SalesModelFirebase sales) async {
    await firestore.collection("sales").doc(sales.id).update(sales.toMap());
  }

  /// Hapus penjualan
  Future<void> deleteSales(String id) async {
    await firestore.collection("sales").doc(id).delete();
  }
}

final firebaseService = FirebaseService();
