import 'package:flutter/material.dart';
import 'package:shab/AjouterProf.dart';


import 'ComptabilitePage.dart';
import 'ElevePage.dart';

import 'ProfPage.dart';
import 'RapportStatPage.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({super.key});

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  int _selectedIndex = 0; // Variable pour suivre l'élément sélectionné

  // Méthode pour gérer les actions de la barre de navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Actions spécifiques à chaque élément du BottomNavigationBar
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManagerPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AjouterProfPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfPage()),
        );
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Center(
          child: Text(
            "Gestionnaire des activités",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Supprime le bouton retour
      ),
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Card pour la Comptabilité
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComptabilitePage()),
                  );
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16), // Ajoute de l'espace en dessous
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.account_balance, color: Colors.white, size: 40),
                      SizedBox(width: 10),
                      Text(
                        "Comptabilité",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card pour la Liste des Elèves
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ElevePage()),
                  );
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16), // Ajoute de l'espace en dessous
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.people, color: Colors.white, size: 40),
                      SizedBox(width: 10),
                      Text(
                        "Liste des Elèves",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card pour la Liste des Profs
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfPage()),
                  );
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16), // Ajoute de l'espace en dessous
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.school, color: Colors.white, size: 40),
                      SizedBox(width: 10),
                      Text(
                        "Liste des Profs",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card pour les Statistiques Annuelles
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RapportStatPage()),
                  );
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16), // Ajoute de l'espace en dessous
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.insert_chart, color: Colors.white, size: 40),
                      SizedBox(width: 10),
                      Text(
                        "Statistiques Annuelles",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        currentIndex: _selectedIndex, // Suivi de l'élément sélectionné
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, color: Colors.black),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add, color: Colors.black),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared, color: Colors.black),
            label: 'Planning',
          ),

        ],
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
