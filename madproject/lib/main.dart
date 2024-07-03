import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PETPAL',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(background: const Color.fromARGB(255, 92, 196, 244))),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(
      const Duration(seconds: 3),
      () {
        _controller.stop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Image.asset('assets/logo.jpg', width: 800, height: 800),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RegistrationScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PETPAL'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                validateRegistration(context);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void validateRegistration(BuildContext context) {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('All fields are required!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Password and Confirm Password do not match!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TabbedScreen(),
        ),
      );
    }
  }
}

class TabbedScreen extends StatelessWidget {
  const TabbedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PET PAL'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.local_offer),
                text: 'Offers',
              ),
              Tab(
                icon: Icon(Icons.local_hospital),
                text: 'Doctor',
              ),
              Tab(
                icon: Icon(Icons.info),
                text: 'About Us',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(),
            const OffersTab(), // Added OffersTab here
            const DoctorTab(), // Added DoctorTab here
            const AboutUsScreen(child: Text('About Us Content')),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/petservices.jpg',
    'assets/adoption.jpg',
    'assets/events.jpg',
    'assets/market.jpg',
    'assets/emergency.jpg'
  ];

  final List<String> descriptions = [
    'PET SERVICES',
    'PET ADOPTION SERVICES',
    'PET EVENTS AND MEETUPS',
    'PET MARKETPLACE',
    'PET EMERGENCY SERVICES',
  ];

  final List<Widget> screens = [
    PetServicesScreen(),
    PetAdoptionScreen(),
    PetEventsScreen(),
    PetMarketplaceScreen(),
    EmergencyServicesScreen(),
  ];

  HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imagePaths.length,
      options: CarouselOptions(
        height: 500.0, // Adjust the height as needed
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screens[index]),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              children: [
                Image.asset(
                  imagePaths[index],
                  width: 740, // Adjust the width as needed
                  height: 400, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(descriptions[index]),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PetServicesScreen extends StatelessWidget {
  final List<ServiceProvider> serviceProviders = [
    ServiceProvider(
      name: 'Happy Paws Veterinary Clinic',
      category: 'Veterinary Clinic',
      location: '123 Main St, Cityville',
      rating: 4.8,
      contactNumber: '123-456-7890',
    ),
    ServiceProvider(
      name: 'Purr-fect Pet Grooming',
      category: 'Pet Grooming',
      location: '456 Oak St, Townsville',
      rating: 4.5,
      contactNumber: '987-654-3210',
    ),
    ServiceProvider(
      name: 'Cozy Critters Boarding',
      category: 'Boarding',
      location: '789 Pine St, Villageland',
      rating: 4.2,
      contactNumber: '555-123-4567',
    ),
    ServiceProvider(
      name: 'Trusty Tails Pet Sitters',
      category: 'Pet Sitters',
      location: '101 Maple St, Hamlet',
      rating: 4.7,
      contactNumber: '999-888-7777',
    ),
    // Add more service providers as needed
  ];

  PetServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Services'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for pet services...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // Implement search logic based on the query
                // You can filter the serviceProviders list based on the query
                // and update the UI accordingly
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: serviceProviders.length,
              itemBuilder: (context, index) {
                return ServiceCard(serviceProviders[index], onTap: () {
                  // Navigate to the appointment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PetServicesAppointmentScreen(), // Use the appointment screen here
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceProvider {
  final String name;
  final String category;
  final String location;
  final double rating;
  final String contactNumber; // New property for contact number

  ServiceProvider({
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.contactNumber,
  });
}

class ServiceCard extends StatelessWidget {
  final ServiceProvider serviceProvider;
  final VoidCallback onTap;

  const ServiceCard(this.serviceProvider, {required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(serviceProvider.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${serviceProvider.category}'),
            Text('Location: ${serviceProvider.location}'),
            Text('Rating: ${serviceProvider.rating}'),
            Text('Contact: ${serviceProvider.contactNumber}'),
          ],
        ),
        onTap: onTap, // Use the provided onTap callback
      ),
    );
  }
}

// Import necessary packages and files

class PetServicesAppointmentScreen extends StatefulWidget {
  const PetServicesAppointmentScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PetServicesAppointmentScreenState createState() =>
      _PetServicesAppointmentScreenState();
}

class _PetServicesAppointmentScreenState
    extends State<PetServicesAppointmentScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Implement date selection logic
  }

  Future<void> _selectTime(BuildContext context) async {
    // Implement time selection logic
  }

  Future<void> _confirmBooking() async {
    // Implement the logic to save the appointment details
    // You can use _selectedDate, _selectedTime, and _reasonController.text
    // to save the appointment information

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Booked'),
        content: const Text(
          'Your appointment has been booked. We will get back to you with further details.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Optionally, you can navigate to another screen or perform additional actions
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Date:'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Select Time:'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Time: ${_selectedTime.format(context)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Reason for Appointment:'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Your Reason',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _confirmBooking, // Use _confirmBooking instead of an anonymous function
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}

class Pet {
  final String name;
  final String species;
  final int age;
  final String imageUrl;

  Pet({
    required this.name,
    required this.species,
    required this.age,
    required this.imageUrl,
  });
}

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onAdopt;

  const PetCard({
    super.key,
    required this.pet,
    required this.onAdopt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display pet image
            Expanded(
              flex: 1,
              child: Image.asset(
                pet.imageUrl,
                width: 200, // Set your desired width
                height: 200, // Set your desired height
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            // Display pet details
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${pet.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Species: ${pet.species}'),
                  Text('Age: ${pet.age} years'),
                  // Add more details as needed
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Add an adopt button
            ElevatedButton(
              onPressed: onAdopt,
              child: const Text('Adopt me'),
            ),
          ],
        ),
      ),
    );
  }
}

class PetAdoptionScreen extends StatelessWidget {
  PetAdoptionScreen({Key? key}) : super(key: key);

  final List<Pet> availablePets = [
    Pet(
        name: 'BRUNO',
        species: 'Dog',
        age: 2,
        imageUrl: 'assets/adoption1.jpg'),
    Pet(
        name: 'Whiskers',
        species: 'Cat',
        age: 1,
        imageUrl: 'assets/adoption2.jpg'),
    // Add more pets as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Adoption'),
      ),
      body: ListView.builder(
        itemCount: availablePets.length,
        itemBuilder: (context, index) {
          final pet = availablePets[index];
          return PetCard(
            pet: pet,
            onAdopt: () => _showAdoptionDialog(context, pet),
          );
        },
      ),
    );
  }

  void _showAdoptionDialog(BuildContext context, Pet pet) {
    showDialog(
      context: context,
      builder: (context) => _AdoptionDialog(
        pet: pet,
        onConfirm: (userDetails) => _confirmAdoption(context, pet, userDetails),
      ),
    );
  }

  void _confirmAdoption(
      BuildContext context, Pet pet, UserDetails userDetails) {
    // Close the adoption dialog first
    Navigator.pop(context);

    // Show the confirmation message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adoption Successful'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You have adopted ${pet.name}!'),
            const SizedBox(height: 10),
            const Text('Details:'),
            Text('Name: ${userDetails.name}'),
            Text('Email: ${userDetails.email}'),
            Text('Phone: ${userDetails.phone}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class UserDetails {
  final String name;
  final String email;
  final String phone;

  UserDetails({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class _AdoptionDialog extends StatefulWidget {
  final Pet pet;
  final Function(UserDetails) onConfirm;

  const _AdoptionDialog({
    required this.pet,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  __AdoptionDialogState createState() => __AdoptionDialogState();
}

class __AdoptionDialogState extends State<_AdoptionDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adopt ${widget.pet.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter your details to adopt ${widget.pet.name}:'),
          const SizedBox(height: 10),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Your Name'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Your Email'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Your Phone'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final userDetails = UserDetails(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
            );
            widget.onConfirm(userDetails);
            Navigator.pop(context);
          },
          child: const Text('Confirm Adoption'),
        ),
      ],
    );
  }
}

class PetEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;

  PetEvent({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
  }) : id = const Uuid()
            .v4(); // Generate a unique identifier when creating the event
}

class PetEventsScreen extends StatelessWidget {
  final List<PetEvent> petEvents = [
    PetEvent(
      title: 'Dog Playdate at the Park',
      description: 'Join us for a fun day at the park with your furry friends!',
      location: 'Central Park',
      date: DateTime(2023, 12, 20, 14, 0), // Year, month, day, hour, minute
    ),
    PetEvent(
      title: 'Cat Lovers Meetup',
      description: 'A gathering for cat lovers to share stories and tips.',
      location: 'Pet Cafe, 123 Main St',
      date: DateTime(2023, 12, 22, 18, 30),
    ),
    PetEvent(
      title: 'Small Pets Social Hour',
      description:
          'Bring your small pets for a social hour and meet other small pet owners.',
      location: 'Pet Playground, 456 Oak St',
      date: DateTime(2023, 12, 25, 16, 0),
    ),
    PetEvent(
      title: 'Exotic Pets Exhibition',
      description:
          'Explore a variety of exotic pets and learn about their care and habitat.',
      location: 'Exotic World, 789 Pine St',
      date: DateTime(2023, 12, 28, 12, 0),
    ),
    // Add more events as needed
  ];

  PetEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Events and Meetups'),
      ),
      body: ListView.builder(
        itemCount: petEvents.length,
        itemBuilder: (context, index) {
          final petEvent = petEvents[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(petEvent.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${petEvent.description}'),
                  Text('Location: ${petEvent.location}'),
                  Text('Date: ${petEvent.date.toLocal()}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _showEventDetailsDialog(context, petEvent);
                },
                child: const Text('Join'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEventDetailsDialog(BuildContext context, PetEvent petEvent) {
    final passNumber = _generatePassNumber(petEvent);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(petEvent.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Location: ${petEvent.location}'),
            Text('Date: ${petEvent.date.toLocal()}'),
            Text('Pass Number: $passNumber'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _generatePassNumber(PetEvent petEvent) {
    // Combine event details and unique identifier to create a pass number
    return '${petEvent.title.replaceAll(' ', '')}_${petEvent.date.millisecondsSinceEpoch}_${petEvent.id.substring(0, 8)}';
  }
}

class PetProduct {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  PetProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class PetMarketplaceScreen extends StatelessWidget {
  final List<PetProduct> petProducts = [
    PetProduct(
      name: 'Pet Bed',
      description: 'Comfortable bed for your furry friend',
      price: 29.99,
      imageUrl: 'assets/shop1.jpg',
    ),
    PetProduct(
      name: 'Interactive Cat Toy',
      description: 'Keep your cat entertained for hours',
      price: 14.99,
      imageUrl: 'assets/shop2.jpg',
    ),
    PetProduct(
      name: 'Dog Leash',
      description: 'Stylish and durable leash for your dog',
      price: 19.99,
      imageUrl: 'assets/shope3.jpg',
    ),
    // Add more products as needed
  ];

  PetMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Marketplace'),
      ),
      body: ListView.builder(
        itemCount: petProducts.length,
        itemBuilder: (context, index) {
          final petProduct = petProducts[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(
                petProduct.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(petProduct.name),
              subtitle: Text(
                  '${petProduct.description}\n\$${petProduct.price.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showPurchaseDialog(context, petProduct);
                },
                child: const Text('Buy'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, PetProduct petProduct) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController paymentMethodController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${petProduct.name}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              petProduct.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text('Description: ${petProduct.description}'),
            Text('Price: \$${petProduct.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Buyer\'s Name:'),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            const Text('Purchase Details:'),
            const SizedBox(height: 8),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: paymentMethodController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(
                context,
                petProduct,
                nameController.text,
                amountController.text,
                paymentMethodController.text,
              );
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    PetProduct petProduct,
    String buyerName,
    String amount,
    String paymentMethod,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Confirmation'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You have purchased ${petProduct.name}!\n\n'
                'Details:\n'
                'Buyer\'s Name: $buyerName\n'
                'Description: ${petProduct.description}\n'
                'Price: \$${petProduct.price.toStringAsFixed(2)}\n'
                'Amount: $amount\n'
                'Payment Method: $paymentMethod\n'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class EmergencyService {
  final String name;
  final String contactNumber;
  final String address;
  final String ambulanceDetails;
  final int timeToReach; // in minutes

  EmergencyService({
    required this.name,
    required this.contactNumber,
    required this.address,
    required this.ambulanceDetails,
    required this.timeToReach,
  });
}

class EmergencyServicesScreen extends StatelessWidget {
  final List<EmergencyService> emergencyServices = [
    EmergencyService(
      name: 'Pet Emergency Clinic',
      contactNumber: '123-456-7890',
      address: '123 Main Street, Cityville',
      ambulanceDetails: 'City Ambulance Services',
      timeToReach: 15,
    ),
    EmergencyService(
      name: 'Animal Care Hospital',
      contactNumber: '987-654-3210',
      address: '456 Oak Avenue, Townsville',
      ambulanceDetails: 'Town Ambulance Services',
      timeToReach: 20,
    ),
    EmergencyService(
      name: 'Paws and Claws Vet Center',
      contactNumber: '555-123-4567',
      address: '789 Pine Street, Villageland',
      ambulanceDetails: 'Village Ambulance Services',
      timeToReach: 18,
    ),
    EmergencyService(
      name: 'Safe Paws Veterinary Clinic',
      contactNumber: '111-222-3333',
      address: '567 Cedar Road, Safetown',
      ambulanceDetails: 'Safetown Ambulance Services',
      timeToReach: 25,
    ),
    EmergencyService(
      name: 'Emergency Pet Care Center',
      contactNumber: '999-888-7777',
      address: '101 Maple Lane, Urgencyville',
      ambulanceDetails: 'Urgencyville Ambulance Services',
      timeToReach: 22,
    ),
    // Add more emergency services as needed
  ];

  EmergencyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
      ),
      body: ListView.builder(
        itemCount: emergencyServices.length,
        itemBuilder: (context, index) {
          final emergencyService = emergencyServices[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(emergencyService.name),
              subtitle: Text(
                'Contact: ${emergencyService.contactNumber}\nAddress: ${emergencyService.address}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showDirectionsDialog(context, emergencyService);
                    },
                    child: const Text('Get Directions'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _callAmbulance(context, emergencyService);
                    },
                    child: const Text('Call Ambulance'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDirectionsDialog(
      BuildContext context, EmergencyService emergencyService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Get Directions to ${emergencyService.name}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Contact: ${emergencyService.contactNumber}'),
            Text('Address: ${emergencyService.address}'),
            const SizedBox(height: 16),
            const Text('Do you want to get directions to this location?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement logic to open navigation or map
              Navigator.pop(context);
            },
            child: const Text('Yes, Get Directions'),
          ),
        ],
      ),
    );
  }

  void _callAmbulance(BuildContext context, EmergencyService emergencyService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Ambulance'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ambulance Details: ${emergencyService.ambulanceDetails}'),
            Text(
                'Estimated Time to Reach: ${emergencyService.timeToReach} minutes'),
            const SizedBox(height: 16),
            const Text('Do you want to call the ambulance?'),
          ],
        ),
        actions: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _showConfirmation(context, emergencyService);
                },
                child: const Text('Yes, Call Ambulance'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmation(
      BuildContext context, EmergencyService emergencyService) {
    // Implement logic to initiate a call to the ambulance
    Navigator.pop(context); // Close the call ambulance dialog

    // Show confirmation message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ambulance Called'),
        content: const Text(
            'An ambulance has been dispatched. Please wait for assistance.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the confirmation dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class OffersTab extends StatelessWidget {
  const OffersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Current Offers',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: const [
              OfferItem(
                productName: 'PUPPY',
                discount: '20%',
                originalPrice: '\$25.00',
                description:
                    'A cute little german puppy just made it in hurry, dont miss your chance.',
                imagePath: 'assets/PUPPY.jpg', // Adjust the image path
              ),
              OfferItem(
                productName: 'PERSIAN CAT',
                discount: '15%',
                originalPrice: '\$30.00',
                description:
                    'A persian cat owned by a family before, has beautiful fur and unique eyes,anyone would want it.',
                imagePath: 'assets/PERSIAN.jpg', // Adjust the image path
              ),
              OfferItem(
                productName: 'LABRADOR',
                discount: '10%',
                originalPrice: '\$45.00',
                description:
                    'Labradors are friendly, versatile dogs known for their intelligence and affable nature.',
                imagePath: 'assets/LABRADOR.jpg', // Adjust the image path
              ),
              OfferItem(
                productName: 'PYTHON',
                discount: '25%',
                originalPrice: '\$60.00',
                description:
                    'The Python snake is a nonvenomous constrictor known for its impressive size and distinctive pattern.',
                imagePath: 'assets/python.jpg', // Adjust the image path
              ),
              OfferItem(
                productName: 'HAMSTER',
                discount: '18%',
                originalPrice: '\$40.00',
                description:
                    'Hamsters are small, nocturnal rodents with cheek pouches for storing food. Known for their friendly demeanor and low maintenance, they make popular pets in the small mammal category.',
                imagePath: 'assets/HAMSTER.jpg', // Adjust the image path
              ),
              // Add more OfferItems as needed
            ],
          ),
        ),
      ],
    );
  }
}

class OfferItem extends StatelessWidget {
  final String productName;
  final String discount;
  final String originalPrice;
  final String description;
  final String imagePath; // New parameter for the image path

  const OfferItem({
    required this.productName,
    required this.discount,
    required this.originalPrice,
    required this.description,
    required this.imagePath, // New parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 60, // Adjust the width as needed
          height: 60, // Adjust the height as needed
          fit: BoxFit.cover,
        ),
        title: Text(productName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Discount: $discount'),
            Text('Original Price: $originalPrice'),
            Text('Description: $description'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PaymentScreen(productName, discount, originalPrice),
            ),
          );
        },
      ),
    );
  }
}

class DoctorTab extends StatelessWidget {
  const DoctorTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Veterinary Services',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Schedule an Appointment:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text('Monday - Friday: 9:00 AM - 5:00 PM'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppointmentScreen(),
                ),
              );
            },
            child: const Text('Book Appointment'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Meet Our Doctors:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const DoctorCard(
            name: 'Dr. John Doe, DVM',
            specialty: 'Board-Certified Veterinarian',
            overview:
                'Dr. John Doe has over 15 years of experience as a veterinarian. He specializes in general veterinary care for all types of pets.',
            phone: '123-456-7890',
            email: 'dr.johndoe@example.com',
            reviews: [
              'Very knowledgeable and caring.',
              'Excellent service every time.',
              'Would recommend to all pet owners.',
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComposeMessageScreen(),
                ),
              );

              if (result != null) {
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Message Sent'),
                    content: const Text(
                      'Your message has been sent. Dr. John Doe will get back to you as soon as possible.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Contact via Email'),
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String overview;
  final String phone;
  final String email;
  final List<String> reviews;

  const DoctorCard({
    required this.name,
    required this.specialty,
    required this.overview,
    required this.phone,
    required this.email,
    required this.reviews,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(specialty),
        Text(overview),
        Text('Phone: $phone'),
        Text('Email: $email'),
        const SizedBox(height: 10),
        const Text(
          'Reviews:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        for (var review in reviews)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('• $review'),
          ),
      ],
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 30)), // 30 days in the future
    ))!;
    if (pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = (await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ))!;
    if (pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Date:'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Select Time:'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Time: ${_selectedTime.format(context)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Reason for Appointment:'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Your Reason',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate the appointment booking process
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Appointment Booked'),
                    content: const Text(
                      'Your appointment has been booked. We will get back to you with further details.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final String productName;
  final String discount;
  final String originalPrice;

  const PaymentScreen(
    this.productName,
    this.discount,
    this.originalPrice, {
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details - ${widget.productName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${widget.productName}'),
            Text('Discount: ${widget.discount}'),
            Text('Original Price: ${widget.originalPrice}'),
            const SizedBox(height: 20),
            const Text('Select Payment Method:'),
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              items: ['Cash', 'Card', 'Online'].map((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
            ),
            if (_selectedPaymentMethod == 'Card' ||
                _selectedPaymentMethod == 'Online')
              const SizedBox(height: 20),
            // Conditionally show CardDetailsForm
            if (_selectedPaymentMethod == 'Card' ||
                _selectedPaymentMethod == 'Online')
              const CardDetailsForm(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your payment logic here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Payment Success'),
                    content: const Text('Thank you for your purchase!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetailsForm extends StatelessWidget {
  const CardDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card Details:'),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Card Number'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Expiration Date'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ComposeMessageScreen extends StatefulWidget {
  const ComposeMessageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComposeMessageScreenState createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Write your message:'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to send the message
                Navigator.pop(context, _messageController.text);
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key, required Text child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const AboutUsContent(),
    );
  }
}

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About PetPal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '''
              Welcome to PetPal, your one-stop destination for all things pet-related! We are a passionate group of students from Bahria University who have come together to create a unique platform that caters to the diverse needs of pet owners and pet enthusiasts.
              
              SERVICES OFFERED
              
              **PET SERVICES:**
              PetPal offers a comprehensive range of pet services, connecting pet owners with trusted service providers. From grooming to veterinary care, our platform ensures that your furry friends receive the best care they deserve.

              **PET ADOPTION SERVICES:**
              Find your perfect companion through PetPal's adoption services. Explore a variety of pets in need of loving homes, and make a difference in their lives by providing a forever home.

              **PET EVENTS AND MEETUPS:**
              Join our vibrant community by participating in local pet events, meetups, and playdates. Connect with fellow pet lovers, share experiences, and create lasting memories with your pets.

              **PET MARKET PLACE:**
              Discover a marketplace filled with unique pet products, accessories, and services. Buy and sell pet items, explore exclusive deals, and find everything you need to pamper your pets.

              **PET EMERGENCY SERVICES:**
              In times of need, PetPal is here to help with quick access to emergency veterinary care. Locate nearby pet clinics and hospitals, and even call for an ambulance if the situation demands immediate attention.

              We, at PetPal, believe in fostering a community that celebrates the joy and companionship that pets bring to our lives. Thank you for choosing PetPal as your go-to platform for all things pets!

              For any inquiries or suggestions, feel free to [03160970100][03150692099](example:info@petpal.com).
              ''',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
