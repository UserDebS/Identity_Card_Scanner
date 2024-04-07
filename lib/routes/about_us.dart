import 'package:flutter/material.dart';
import 'package:one_fa/util/custom_page_decoration.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      backgroundColor: Colors.black,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: boxdecoration(),
        child: const SingleChildScrollView(
          child: MainBodySkel(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        label: const Text('Go back'),
        icon: const Icon(Icons.arrow_left_rounded),
        extendedPadding: const EdgeInsets.all(15),
      ),
    );
  }
}

class MainBodySkel extends StatelessWidget {
  const MainBodySkel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Description on One for all',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'It is an automation type project which works on the database which has been pre-decided. It helps to collect user information efficiently and process the data as per its requirements in a suitable time with security measures in place.',
                  style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Team Members',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TeamMemberCard(
                name: 'Souvik Gosh',
                role: 'Flutter Backend Dev & Team lead',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1jw2vV3No_rsreIGbzMP3RDIhRCMFpApV'
              ),
              TeamMemberCard(
                name: 'Debmalya Sarkar',
                role: 'Flutter Full Stack Dev',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1snYDRlgq5l_NH0uj78geEB5OpvYRx_vb'
              ),
              TeamMemberCard(
                name: 'Arkabrata Basu',
                role: 'Flutter Frontend Dev',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1TVxCBwWoaL7Byfx8CIrzVCkNWQoIlXfu'
              ),
              TeamMemberCard(
                name: 'Arghadeep Paul',
                role: 'Flutter Backend Dev and PPT Writer',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1DesHG3jrShj-pNoJRJA7ssGzT7RcBemo'
              ),
              TeamMemberCard(
                name: 'Soham Sarkar',
                role: '',
                imageUrl: 'https://drive.google.com/uc?export=view&id=149zOeyz6T5ghJxOirihc14OLCMZZuCl6', // Example image URL
              ),
              TeamMemberCard(
                name: 'Aunshka Dey',
                role: '',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1zZL4NXjBXJLgpVAPaUtWeczIgNiwciBQ'
              ),
              TeamMemberCard(
                name: 'Manvi Kumari',
                role: '',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1IYMUOzrRiAmssAV3PyCLCdWx93tyN-2n'
              ),
              TeamMemberCard(
                name: 'Satwik Das',
                role: 'UI Designer Lead',
                imageUrl: 'https://drive.google.com/uc?export=view&id=13hWFG7FNyUUgSwHrstNhQpXy17NAgid1'
              ),
              TeamMemberCard(
                name: 'Debayudh Roy',
                role: 'UI Designer',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1jyzHDigTz5aqrJhekuIYQtYo-geIhgvW'
              ),
              TeamMemberCard(
                name: 'Arpan Gosh',
                role: 'PPT Writer',
                imageUrl: 'https://drive.google.com/uc?export=view&id=1epdRVOiN5EH81h--Ekuir09nU_Pr7KjB'
            ),
            ],
          ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const TeamMemberCard({
    Key? key,
    required this.name,
    required this.role,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage((imageUrl)), // Using image URL
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}