import 'package:comp_admin/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl package

import '../widgets/drop_down_btn.dart';

class AddCompPage extends StatelessWidget {
  const AddCompPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: Text('      Add Competition'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add New Competition',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Competition Name (Required)
                TextField(
                  controller: ctrl.competitionNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Competition Name'),
                    hintText: 'Enter the Competition Name',
                  ),
                ),
                SizedBox(height: 10),
                // Competition Details (Optional)
                TextField(
                  controller: ctrl.competitionDetailsCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Competition Details (Optional)'),
                    hintText: 'Enter the Competition Details (Optional)',
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 10),
                // Image URL (Required)
                TextField(
                  controller: ctrl.competitionImgCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Image Url'),
                    hintText: 'Enter the Image Url',
                  ),
                ),
                SizedBox(height: 10),
                // Competition Date (Optional)
                TextField(
                  controller: ctrl.competitionDateCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Competition Date (yyyy-MM-dd)'),
                    hintText: 'Enter the Competition date (Optional)',
                  ),
                  onTap: () async {
                    // Close the keyboard
                    FocusScope.of(context).requestFocus(FocusNode());

                    // Open Date Picker
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      // Format the date to yyyy-MM-dd
                      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                      ctrl.competitionDateCtrl.text = formattedDate; // Update text field with formatted date
                    }
                  },
                ),
                SizedBox(height: 10),
                // Competition Place (Optional)
                TextField(
                  controller: ctrl.competitionPlaceCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Place (Optional)'),
                    hintText: 'Enter the Competition Place (Optional)',
                  ),
                ),
                SizedBox(height: 20),
                // Category and Level (Optional)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropDownBtn(
                          items: ['Technical', 'Non-Technical', 'Both'],
                          selectedItemText: ctrl.category,
                          onSelected: (selectedValue) {
                            ctrl.category = selectedValue ?? 'General';
                            ctrl.update();
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropDownBtn(
                          items: ['Intra-college', 'Inter-college', 'Intra-Department', 'Inter-Department', 'National Level', 'International Level', 'Others'],
                          selectedItemText: ctrl.level,
                          onSelected: (selectedValue) {
                            ctrl.level = selectedValue ?? 'No-level';
                            ctrl.update();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Registration Fee (Optional)
                Text('Registration Fee? (Optional)'),
                DropDownBtn(
                  items: ['Yes', 'No'],
                  selectedItemText: ctrl.fee.toString(),
                  onSelected: (selectedValue) {
                    ctrl.fee = (selectedValue ?? 'No').toLowerCase() == 'yes';
                    ctrl.update();
                  },
                ),
                SizedBox(height: 10),
                // Add Competition Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Validate required fields: Competition Name and Image URL
                    if (ctrl.competitionNameCtrl.text.trim().isEmpty) {
                      Get.snackbar(
                        'Missing Fields',
                        'Competition Name is required.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }

                    if (ctrl.competitionImgCtrl.text.trim().isEmpty) {
                      Get.snackbar(
                        'Missing Fields',
                        'Image URL is required.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }

                    // Add competition
                    ctrl.addCompetition();
                  },
                  child: Text('Add Competition'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
