import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'CompteProfesseur.dart';
import 'ManagerPage.dart';

import 'ParentPage.dart'; // Assurez-vous d'ajouter cloud_firestore dans pubspec.yaml

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  String? _selectedRole;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'assets/IMG-20230705-WA0003.jpg', // Remplacez par le chemin de votre image
                    fit: BoxFit.cover,
                    height: 150,
                    width: 224,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Container incurvé pour la dropdown list
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    hint: const Text(
                      "Sélectionner un compte",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    items: ["Manager", "Parent", "Professeur"].map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(
                          role,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                        if (value == "Manager") {
                          _showPasswordPopup(context);
                        } else if (value == "Professeur") {
                          _showIDPopup(context);
                        } else if (value == "Parent") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ParentPage()),
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour afficher le popup de mot de passe pour Manager
  void _showPasswordPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Entrer mot de passe",
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          onChanged: (value) {
            if (value == "hor88") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ManagerPage()),
              );
            } else if (value.length >= 8) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Mot de passe incorrect",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  /*// Fonction pour afficher le popup de saisie d'ID pour Professeur
  void _showIDPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _idController,
          decoration: InputDecoration(
            hintText: "Entrer votre identifiant",
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          onChanged: (value) async {
            await _checkProfessorID(value, context);
          },
        ),
      ),
    );
  }

  // Fonction pour vérifier l'existence de l'ID dans Firestore
  Future<void> _checkProfessorID(String profId, BuildContext context) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('ProfShab')
        .doc(profId)
        .get();

    if (docSnapshot.exists) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CompteProfesseur(profId)),
      );
    } else if (profId.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "ID introuvable",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }*/
  // Fonction pour afficher le popup de saisie d'ID pour Professeur
  void _showIDPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: "Entrer votre identifiant",
                hintStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String profId = _idController.text.trim(); // Supprime les espaces
                await _checkProfessorID(profId, context);
              },
              child: Text("Valider"),
            ),
          ],
        ),
      ),
    );
  }

// Fonction pour vérifier l'existence de l'ID dans Firestore
  Future<void> _checkProfessorID(String profId, BuildContext context) async {
    // Effectuer une requête pour trouver un document avec le champ "profId" correspondant
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ProfShab')
        .where('profId', isEqualTo: profId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Récupérer la référence du document trouvé et naviguer vers la page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CompteProfesseur(profId)),
      );
    } else {
      // Afficher le message d'erreur si aucun document n'est trouvé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "ID introuvable",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
