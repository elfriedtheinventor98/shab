import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/*
class AjouterProfPage extends StatefulWidget {
  const AjouterProfPage({Key? key}) : super(key: key);

  @override
  State<AjouterProfPage> createState() => _AjouterProfPageState();
}

class _AjouterProfPageState extends State<AjouterProfPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _matiereController = TextEditingController();
  final _tarifController = TextEditingController();

  Future<void> _ajouterProfesseur() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('ProfShab').add({
          'Nom': _nomController.text,
          'Prenom': _prenomController.text,
          'Matiere': _matiereController.text,
          'Tarif': double.parse(_tarifController.text),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Professeur ajouté avec succès'), backgroundColor: Colors.green),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'ajout du professeur'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Professeur", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: Offset(0, 2)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(labelText: "Nom"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(labelText: "Prénom"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _matiereController,
                    decoration: InputDecoration(labelText: "Matière"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _tarifController,
                    decoration: InputDecoration(labelText: "Tarif moyen"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _ajouterProfesseur,
                    child: const Text("Ajouter", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/

class AjouterProfPage extends StatefulWidget {
  const AjouterProfPage({Key? key}) : super(key: key);

  @override
  State<AjouterProfPage> createState() => _AjouterProfPageState();
}

class _AjouterProfPageState extends State<AjouterProfPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _matiereController = TextEditingController();
  final _tarifController = TextEditingController();

  // Fonction pour générer le prochain profId
  Future<String> _genererProfId() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ProfShab')
        .orderBy('profId', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String lastId = snapshot.docs.first['profId'];
      int lastNumber = int.parse(lastId.substring(2)); // Extrait le nombre après "PS"
      String nextId = 'PS${(lastNumber + 1).toString().padLeft(2, '0')}';
      return nextId;
    } else {
      return 'PS01'; // Si aucun document n'existe, retourne 'PS01'
    }
  }

  Future<void> _ajouterProfesseur() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Génère le prochain profId
        String newProfId = await _genererProfId();

        // Ajoute le professeur avec l'attribut Planning directement dans le document
        await FirebaseFirestore.instance.collection('ProfShab').add({
          'profId': newProfId,
          'Nom': _nomController.text,
          'Prenom': _prenomController.text,
          'Matiere': _matiereController.text,
          'Tarif': double.parse(_tarifController.text),
          'Planning': {
            'Jour': [], // Peut être modifié pour être une liste vide ou un jour par défaut
            'HoraireDebut': '',
            'HoraireFin': '',
            'Programme': '',
          },
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Professeur ajouté avec succès'), backgroundColor: Colors.green),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'ajout du professeur'), backgroundColor: Colors.red),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Professeur", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: Offset(0, 2)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(labelText: "Nom"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(labelText: "Prénom"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _matiereController,
                    decoration: InputDecoration(labelText: "Matière"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _tarifController,
                    decoration: InputDecoration(labelText: "Tarif moyen"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _ajouterProfesseur,
                    child: const Text("Ajouter", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
