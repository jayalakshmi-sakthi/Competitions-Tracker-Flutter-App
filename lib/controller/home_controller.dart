import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp_admin/competition/competition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference competitionCollection;

  // Controllers for text fields
  TextEditingController competitionNameCtrl = TextEditingController();
  TextEditingController competitionDetailsCtrl = TextEditingController();
  TextEditingController competitionImgCtrl = TextEditingController();
  TextEditingController competitionDateCtrl = TextEditingController();
  TextEditingController competitionPlaceCtrl = TextEditingController();

  // Default values
  String category = 'general';
  String level = 'no level';
  bool fee = false;

  // List to store competitions
  RxList<Competition> competition = <Competition>[].obs;

  @override
  Future<void> onInit() async {
    competitionCollection = firestore.collection('competition');
    await fetchCompetitions();
    super.onInit();
  }

  // Add a new competition
  Future<void> addCompetition() async {
    try {
      // Validate required fields: Competition Name and Image URL
      if (competitionNameCtrl.text.isEmpty || competitionImgCtrl.text.isEmpty) {
        Get.snackbar(
          'Invalid Input',
          'Competition Name and Image URL are required!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Parse date string to DateTime
      final competitionDate = DateTime.tryParse(competitionDateCtrl.text.trim());
      if (competitionDate == null) {
        Get.snackbar(
          'Invalid Input',
          'Please enter a valid date for the competition.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Create Firestore document
      DocumentReference doc = competitionCollection.doc();

      // Construct Competition object
      Competition competitionData = Competition(
        id: doc.id,
        name: competitionNameCtrl.text.trim(),
        category: category,
        details: competitionDetailsCtrl.text.trim(),
        date: competitionDate, // Store as DateTime object
        level: level,
        image: competitionImgCtrl.text.trim(),
        fee: fee,
      );

      // Convert DateTime to Timestamp for Firestore
      final competitionJson = competitionData.toJson();
      competitionJson['date'] = Timestamp.fromDate(competitionDate); // Ensure date is saved as Timestamp

      // Save to Firestore
      await doc.set(competitionJson);

      // Success notification
      Get.snackbar(
        'Success',
        'Competition added successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Reset form fields
      setValuesDefault();
      await fetchCompetitions();  // Refresh competitions after adding
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to add competition: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      if (kDebugMode) {
        print('Error adding competition: $e');
      }
    }
  }

  // Fetch all competitions
  Future<void> fetchCompetitions() async {
    try {
      // Retrieve all documents from Firestore
      QuerySnapshot competitionSnapshot = await competitionCollection.get();

      if (competitionSnapshot.docs.isEmpty) {
        competition.clear();
        update(); // Update UI when no competitions are found
        return;
      }

      // Parse documents
      final List<Competition> retrievedCompetitions = competitionSnapshot.docs
          .map((doc) {
        var competitionData = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime for the 'date' field
        if (competitionData['date'] is Timestamp) {
          competitionData['date'] = (competitionData['date'] as Timestamp).toDate();
        }

        // Convert DateTime to String if required for UI
        String formattedDate = DateFormat('yyyy-MM-dd').format(competitionData['date']);

        // Update the competitionData with the formatted date (optional, if needed for display)
        competitionData['date'] = formattedDate;

        return Competition.fromJson(competitionData);
      }).toList();

      // Update competition list
      competition.clear();
      competition.assignAll(retrievedCompetitions);
      update(); // Update UI when competitions are fetched
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to fetch competitions: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      if (kDebugMode) {
        print('Error fetching competitions: $e');
      }
    }
  }

  // Delete a competition
  Future<void> deleteCompetition(String competitionId) async {
    try {
      // Delete competition from Firestore
      await firestore.collection('competition').doc(competitionId).delete();

      // Remove the deleted competition from the local list
      competition.removeWhere((comp) => comp.id == competitionId);

      // Success notification
      Get.snackbar(
        'Success',
        'Competition deleted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      update(); // Update UI after deleting competition
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to delete competition: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Reset the form fields to default values
  void setValuesDefault() {
    competitionNameCtrl.clear();
    competitionDateCtrl.clear();
    competitionDetailsCtrl.clear();
    competitionImgCtrl.clear();

    category = 'general';
    level = 'no level';
    fee = false;
    update(); // Update the UI after resetting values
  }

  // Format the error message
  String _formatError(dynamic error) {
    if (error is FirebaseException) {
      return error.message ?? 'Unknown Firebase error';
    }
    return error.toString();
  }
}
