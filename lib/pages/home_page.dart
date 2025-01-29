import 'package:comp_admin/controller/home_controller.dart';
import 'package:comp_admin/pages/add_comp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Competitions Admin'),
        ),
        body: ctrl.competition.isEmpty
            ? Center(
          child: Text(
            'No competitions available. Add a competition to get started!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: ctrl.competition.length,
          itemBuilder: (context, index) {
            var competition = ctrl.competition[index];

            String title = competition.name ?? 'No Title Available';
            String date = competition.date != null
                ? DateFormat('yyyy-MM-dd').format(competition.date!) // Format DateTime to string
                : 'No Date Available';

            return ListTile(
              title: Text(title),
              subtitle: Text(date),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete this competition?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (competition.id != null) {
                                ctrl.deleteCompetition(competition.id!); // Delete competition
                                Navigator.of(context).pop(); // Close the dialog
                              }
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AddCompPage());
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
