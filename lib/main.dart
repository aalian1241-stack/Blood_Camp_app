import 'package:flutter/material.dart';

void main() {
  runApp(const AlkhidmatBloodCampApp());
}

class AlkhidmatBloodCampApp extends StatelessWidget {
  const AlkhidmatBloodCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alkhidmat Blood Camp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFA5F5F5),
      ),
      home: const DonorHomeScreen(),
    );
  }
}

// Model class to represent Donor data safely
class Donor {
  final String name;
  final String bloodGroup;
  final String timeSlot;
  final String lastDonationDate;
  bool isCheckedIn;

  Donor({
    required this.name,
    required this.bloodGroup,
    required this.timeSlot,
    required this.lastDonationDate,
    this.isCheckedIn = false,
  });
}

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  // Form Key for Validation
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastDonationController = TextEditingController();

  // Selected Dropdown Values
  String _selectedBloodGroup = 'A+';
  String _selectedTimeSlot = '09:00 AM - 10:00 AM';

  // Available Options
  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  final List<String> _timeSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
  ];

  // List storing all donor entries
  final List<Donor> _donorList = [];

  // Function to Add Donor
  void _addDonor() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _donorList.add(
          Donor(
            name: _nameController.text.trim(),
            bloodGroup: _selectedBloodGroup,
            timeSlot: _selectedTimeSlot,
            lastDonationDate: _lastDonationController.text.trim().isEmpty
                ? 'First Time Donor'
                : _lastDonationController.text.trim(),
          ),
        );
      });

      // Clear input fields after adding
      _nameController.clear();
      _lastDonationController.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slot booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Function to Toggle Donor Check-In Status
  void _toggleCheckIn(int index) {
    setState(() {
      _donorList[index].isCheckedIn = !_donorList[index].isCheckedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alkhidmat / Bano Qabil Blood Drive',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FORM SECTION: BOOK SLOT
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book a Blood Camp Slot',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Donor Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Donor Full Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter donor name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Blood Group and Time Slot Selection
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedBloodGroup,
                              decoration: const InputDecoration(
                                labelText: 'Blood Group',
                                border: OutlineInputBorder(),
                              ),
                              items: _bloodGroups.map((group) {
                                return DropdownMenuItem(
                                  value: group,
                                  child: Text(group),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBloodGroup = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedTimeSlot,
                              decoration: const InputDecoration(
                                labelText: 'Time Slot',
                                border: OutlineInputBorder(),
                              ),
                              items: _timeSlots.map((slot) {
                                return DropdownMenuItem(
                                  value: slot,
                                  child: Text(
                                    slot,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTimeSlot = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Last Donation Date Input
                      TextFormField(
                        controller: _lastDonationController,
                        decoration: const InputDecoration(
                          labelText: 'Last Donation (e.g., DD/MM/YYYY)',
                          hintText: 'Leave empty if first time',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _addDonor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade800,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text(
                            'Book Donor Slot',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // RECORDS LIST SECTION
            Text(
              'Registered Donors (${_donorList.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 8),

            // Donor Cards / Empty State
            _donorList.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'No registered donors yet. Book a slot above!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _donorList.length,
                    itemBuilder: (context, index) {
                      final donor = _donorList[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.shade800,
                            foregroundColor: Colors.white,
                            radius: 24,
                            child: Text(
                              donor.bloodGroup,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            donor.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Slot: ${donor.timeSlot}'),
                                Text(
                                  'Last Donation: ${donor.lastDonationDate}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: donor.isCheckedIn
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              foregroundColor: donor.isCheckedIn
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            onPressed: () => _toggleCheckIn(index),
                            child: Text(
                              donor.isCheckedIn ? 'Checked-In' : 'Check-In',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}