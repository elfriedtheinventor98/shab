/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfPage extends StatefulWidget {
  const ProfPage({Key? key}) : super(key: key);

  @override
  State<ProfPage> createState() => _ProfPageState();
}

class _ProfPageState extends State<ProfPage> {
  void _modifierPlanning(String profId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedDay = 'Lundi';

        TextEditingController debutController = TextEditingController();
        TextEditingController finController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Modifier Planning"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Jour de la semaine"),
                  value: selectedDay,
                  items: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche']
                      .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                      .toList(),
                  onChanged: (value) => selectedDay = value!,
                ),

                TextFormField(
                  controller: debutController,
                  decoration: InputDecoration(labelText: "Horaire de début"),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: finController,
                  decoration: InputDecoration(labelText: "Horaire de fin"),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Récupère la référence de la sous-collection Planning
                CollectionReference planningCollection = FirebaseFirestore.instance
                    .collection('ProfShab')
                    .doc(profId)
                    .collection('Planning');

                // Récupère le premier document de la sous-collection Planning
                var snapshot = await planningCollection.limit(1).get();

                if (snapshot.docs.isNotEmpty) {
                  // Utilise l'ID du premier document pour effectuer une mise à jour
                  String documentId = snapshot.docs.first.id;

                  await planningCollection.doc(documentId).update({
                    'Jour': selectedDay,
                    'HoraireDebut': debutController.text,
                    'HoraireFin': finController.text,
                  });
                } else {
                  // Crée un nouveau document si aucun document n'existe dans Planning
                  await planningCollection.add({
                    'Jour': selectedDay,
                    'HoraireDebut': debutController.text,
                    'HoraireFin': finController.text,
                  });
                }
                Navigator.of(context).pop();
              },

              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Liste des Professeurs",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Définit la couleur du texte en blanc
            ),
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ProfShab').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var prof = snapshot.data!.docs[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${prof['Nom']} ${prof['Prenom']}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text("Matière : ${prof['Matiere']}, Tarif : ${prof['Tarif']}"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _modifierPlanning(prof.id),
                      child: const Text("Modifier planning"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ProfPage extends StatefulWidget {
  const ProfPage({Key? key}) : super(key: key);

  @override
  State<ProfPage> createState() => _ProfPageState();
}

class _ProfPageState extends State<ProfPage> {
  void _modifierPlanning(String profId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Initialisation des variables pour le dialogue
        List<String> selectedDays = [];
        TextEditingController debutController = TextEditingController();
        TextEditingController finController = TextEditingController();
        TextEditingController programmeController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Modifier Planning"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Sélecteur de jours
                MultiSelectDialogField(
                  items: [
                    MultiSelectItem("Lundi", "Lundi"),
                    MultiSelectItem("Mardi", "Mardi"),
                    MultiSelectItem("Mercredi", "Mercredi"),
                    MultiSelectItem("Jeudi", "Jeudi"),
                    MultiSelectItem("Vendredi", "Vendredi"),
                    MultiSelectItem("Samedi", "Samedi"),
                    MultiSelectItem("Dimanche", "Dimanche"),
                  ],
                  title: const Text("Sélectionnez les jours de la semaine"),
                  selectedColor: Colors.blue,
                  buttonText: const Text("Jours de la semaine"),
                  onConfirm: (values) {
                    selectedDays = values.cast<String>();
                  },
                ),

                // Champ Horaire de début
                TextFormField(
                  controller: debutController,
                  decoration: InputDecoration(labelText: "Horaire de début"),
                  keyboardType: TextInputType.datetime,
                ),
                // Champ Horaire de fin
                TextFormField(
                  controller: finController,
                  decoration: InputDecoration(labelText: "Horaire de fin"),
                  keyboardType: TextInputType.datetime,
                ),
                // Champ Programme
                TextFormField(
                  controller: programmeController,
                  decoration: InputDecoration(labelText: "Programmation avec les Classes "),
                ),
              ],
            ),
          ),
          actions: [

            ElevatedButton(
              onPressed: () async {
                // Récupère la référence du document ProfShab avec l'ID spécifique
                DocumentReference profDocument = FirebaseFirestore.instance
                    .collection('ProfShab')
                    .doc(profId);

                // Met à jour le champ Planning dans le document
                await profDocument.update({
                  'Planning': {
                    'Jour': selectedDays,
                    'HoraireDebut': debutController.text,
                    'HoraireFin': finController.text,
                    'Programme': programmeController.text,
                  }
                }).catchError((error) async {
                  // En cas d'erreur (ex. le champ n'existe pas), créer le champ Planning
                  await profDocument.set({
                    'Planning': {
                      'Jour': selectedDays,
                      'HoraireDebut': debutController.text,
                      'HoraireFin': finController.text,
                      'Programme': programmeController.text,
                    }
                  }, SetOptions(merge: true));
                });

                Navigator.of(context).pop();
              },
              child: const Text("Modifier"),
            ),





          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Liste des Professeurs",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ProfShab').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var prof = snapshot.data!.docs[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${prof['Nom']} ${prof['Prenom']}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text("Matière : ${prof['Matiere']}, Tarif : ${prof['Tarif']}"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _modifierPlanning(prof.id),
                      child: const Text("Modifier planning"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
