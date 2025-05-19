import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FedaPayPage.dart';
import 'InfosPage.dart';



class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
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
          MaterialPageRoute(builder: (context) => ParentPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Infospage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuiviPage()),
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
            "Gestionnaire Parental",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Supprime le bouton retour
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container incurvé pour l'image
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/IMG-20241105-WA0015.jpg',
                    fit: BoxFit.cover,
                    height: 350,
                    width: 355,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentPage()),
                  );
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.payment_outlined, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "Payer les mensualités",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, color: Colors.black),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.black),
            label: 'Infos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared, color: Colors.black),
            label: 'Suivi',
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

// Page pour le paiement des mensualités
class PaymentPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement des Mensualités"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom de l'enfant"),
            ),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: "Prénoms de l'enfant"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Recherche de l'élève dans Firestore
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('Eleves')
                    .where('Nom', isEqualTo: _nameController.text)
                    .where('Prenoms', isEqualTo: _surnameController.text)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  // Affichage du popup de confirmation
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Confirmation de paiement",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text("Confirmer le paiement de 30 000 FCFA via Mobile Money ?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Rediriger vers une page pour exécuter un autre code
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FedaPayPage(eleveNom: _nameController.text,
                                elevePrenom: _surnameController.text,)));
                            },
                            child: const Text("Confirmer"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Aucun élève trouvé avec ce nom et prénom"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Rechercher"),
            ),
          ],
        ),
      ),
    );
  }
}

// Page pour le suivi des notes de l'élève
class SuiviPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suivi des Notes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom de l'enfant"),
            ),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: "Prénom de l'enfant"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  // Recherche de l'élève dans Firestore
                  final querySnapshot = await FirebaseFirestore.instance
                      .collection('Eleves')
                      .where('Nom', isEqualTo: _nameController.text)
                      .where('Prenoms', isEqualTo: _surnameController.text)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    // Attente de la requête pour obtenir les notes de l'élève
                    final notesQuery = await querySnapshot.docs.first.reference.collection('Notes').get();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Notes de l'élève"),
                          content: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: notesQuery.docs.length,
                              itemBuilder: (context, index) {
                                final noteData = notesQuery.docs[index];
                                return Card(
                                  child: ListTile(
                                    title: Text("Matière : ${noteData['Matiere']}"),
                                    subtitle: Text("Note : ${noteData['Note']}" ),

                                  ),
                                );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Fermer"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Aucun élève trouvé avec ce nom et prénom"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text("Rechercher"),
              ),
            ),
          ],
        ),
      ),
    );
 }
}