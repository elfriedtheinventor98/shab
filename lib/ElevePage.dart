/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ElevePage extends StatefulWidget {
  const ElevePage({super.key});

  @override
  State<ElevePage> createState() => _ElevePageState();
}

class _ElevePageState extends State<ElevePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _ageController = TextEditingController();
  final _classeController = TextEditingController();
  final _serieController = TextEditingController();
  final _nomParentController = TextEditingController();
  final _prenomsParentController = TextEditingController();
  final _anneController = TextEditingController();
  bool _showForm = false;

  Future<void> _ajouterEleve() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ajout de l'élève avec les informations de base et récupération de sa référence
        DocumentReference eleveRef = await FirebaseFirestore.instance.collection('Eleves').add({
          'Nom': _nomController.text,
          'Prenoms': _prenomsController.text,
          'Age': int.parse(_ageController.text),
          'Classe': _classeController.text,
          'Serie': _serieController.text,
          'ParentNom': _nomParentController.text,
          'ParentPrenoms': _prenomsParentController.text,
          'Annee': _anneController.text
        });

        // Création de la sous-collection Notes (vide initialement)
        eleveRef.collection('Notes'); // Crée la sous-collection Notes sans données

        // Création de la sous-collection Paiement avec un document pour chaque mois
        final List<String> moisList = [
          'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
        ];

        for (String mois in moisList) {
          await eleveRef.collection('Paiement').doc(mois).set({
            'Statut': 'Non payé', // Statut initial par défaut
          });
        }

        // Affichage de la snackbar en cas de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Élève ajouté avec succès'), backgroundColor: Colors.green),
        );

        // Réinitialisation de l'état du formulaire et fermeture du formulaire d'ajout
        setState(() {
          _showForm = false;
        });
        _formKey.currentState!.reset();

      } catch (e) {
        // Affichage de la snackbar en cas d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de l\'élève'), backgroundColor: Colors.blue),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Ajouter un élève")),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showForm = !_showForm;
              });
            },
            child: const Text("Ajouter un élève"),
          ),
          _showForm
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(labelText: "Nom"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _prenomsController,
                    decoration: InputDecoration(labelText: "Prénoms"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: "Âge"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _classeController,
                    decoration: InputDecoration(labelText: "Classe"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _serieController,
                    decoration: InputDecoration(labelText: "Série"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _nomParentController,
                    decoration: InputDecoration(labelText: "Nom du parent"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _prenomsParentController,
                    decoration: InputDecoration(labelText: "Prénoms du parent"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _anneController,
                    decoration: InputDecoration(labelText: "Année"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _ajouterEleve,
                    child: const Text("Valider"),
                  ),
                ],
              ),
            ),
          )
              : const SizedBox.shrink(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Eleves').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var eleve = snapshot.data!.docs[index];
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
                            backgroundColor: Colors.pink,
                            child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${eleve['Nom']} ${eleve['Prenoms']}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text("Classe : ${eleve['Classe']}, Série : ${eleve['Serie']}"),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotesPage(eleveId: eleve.id),
                                ),
                              );
                            },
                            child: const Text("Notes"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ElevePage extends StatefulWidget {
  const ElevePage({super.key});

  @override
  State<ElevePage> createState() => _ElevePageState();
}

class _ElevePageState extends State<ElevePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _ageController = TextEditingController();
  final _classeController = TextEditingController();
  final _serieController = TextEditingController();
  final _nomParentController = TextEditingController();
  final _prenomsParentController = TextEditingController();
  final _anneController = TextEditingController();
  final _filtreAnneeController = TextEditingController();
  bool _showForm = false;

  Future<void> _ajouterEleve() async {
    if (_formKey.currentState!.validate()) {
      try {
        DocumentReference eleveRef = await FirebaseFirestore.instance.collection('Eleves').add({
          'Nom': _nomController.text,
          'Prenoms': _prenomsController.text,
          'Age': int.parse(_ageController.text),
          'Classe': _classeController.text,
          'Serie': _serieController.text,
          'ParentNom': _nomParentController.text,
          'ParentPrenoms': _prenomsParentController.text,
          'Annee': _anneController.text
        });

        // Création des sous-collections
        eleveRef.collection('Notes');
        final List<String> moisList = [
          'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
        ];
        for (String mois in moisList) {
          await eleveRef.collection('Paiement').doc(mois).set({
            'Statut': 'Non payé',
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Élève ajouté avec succès'), backgroundColor: Colors.green),
        );

        setState(() {
          _showForm = false;
        });
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de l\'élève'), backgroundColor: Colors.blue),
        );
      }
    }
  }

  void _afficherFormulairePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
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
                    controller: _prenomsController,
                    decoration: InputDecoration(labelText: "Prénoms"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: "Âge"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _classeController,
                    decoration: InputDecoration(labelText: "Classe"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _serieController,
                    decoration: InputDecoration(labelText: "Série"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _nomParentController,
                    decoration: InputDecoration(labelText: "Nom du parent"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _prenomsParentController,
                    decoration: InputDecoration(labelText: "Prénoms du parent"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _anneController,
                    decoration: InputDecoration(labelText: "Année"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _ajouterEleve();
                      Navigator.pop(context);
                    },
                    child: const Text("Valider"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Ajouter un élève", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                ),
                onPressed: () {
                  _afficherFormulairePopup(context);
                },
                child: const Text("Ajouter un élève", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _filtreAnneeController,
                decoration: const InputDecoration(
                  labelText: "Filtrer par année",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Eleves').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final filteredDocs = snapshot.data!.docs.where((eleve) {
                    return _filtreAnneeController.text.isEmpty ||
                        eleve['Annee'] == _filtreAnneeController.text;
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var eleve = filteredDocs[index];
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
                              backgroundColor: Colors.pink,
                              child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${eleve['Nom']} ${eleve['Prenoms']}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text("Classe : ${eleve['Classe']}, Série : ${eleve['Serie']}"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Naviguer vers la page des notes pour l'élève sélectionné

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NotesPage(widget.eleveId)),
                                );
                                
                                
                              },
                              child: const Text("Notes"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  final String eleveId;
  const NotesPage(eleveId, {required this.eleveId, Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _matiereController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _ajouterNote() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('Eleves')
            .doc(widget.eleveId)
            .collection('Notes')
            .add({
          'Note': double.parse(_noteController.text),
          'Matiere': _matiereController.text,
          'Date': _selectedDate,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note ajoutée avec succès'), backgroundColor: Colors.green),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de la note'), backgroundColor: Colors.blue),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter des notes"),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: "Note"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              TextFormField(
                controller: _matiereController,
                decoration: InputDecoration(labelText: "Matière"),
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              const SizedBox(height: 20),
              Text("Date : ${_selectedDate.toLocal()}".split(' ')[0]),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: const Text("Choisir la date"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ajouterNote,
                child: const Text("Valider"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ElevePage extends StatefulWidget {
  const ElevePage({super.key});

  @override
  State<ElevePage> createState() => _ElevePageState();
}

class _ElevePageState extends State<ElevePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _ageController = TextEditingController();
  final _classeController = TextEditingController();
  final _serieController = TextEditingController();
  final _nomParentController = TextEditingController();
  final _prenomsParentController = TextEditingController();
  final _anneController = TextEditingController();
  final _filtreAnneeController = TextEditingController();
  bool _showForm = false;

  Future<void> _ajouterEleve() async {
    if (_formKey.currentState!.validate()) {
      try {
        DocumentReference eleveRef = await FirebaseFirestore.instance.collection('Eleves').add({
          'Nom': _nomController.text,
          'Prenoms': _prenomsController.text,
          'Age': int.parse(_ageController.text),
          'Classe': _classeController.text,
          'Serie': _serieController.text,
          'ParentNom': _nomParentController.text,
          'ParentPrenoms': _prenomsParentController.text,
          'Annee': _anneController.text
        });

        // Création des sous-collections
        eleveRef.collection('Notes');
        final List<String> moisList = [
          'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
        ];
        for (String mois in moisList) {
          await eleveRef.collection('Paiement').doc(mois).set({
            'Statut': 'Non payé',
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Élève ajouté avec succès'), backgroundColor: Colors.green),
        );

        setState(() {
          _showForm = false;
        });
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de l\'élève'), backgroundColor: Colors.blue),
        );
      }
    }
  }

  void _afficherFormulairePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
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
                    controller: _prenomsController,
                    decoration: InputDecoration(labelText: "Prénoms"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: "Âge"),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _classeController,
                    decoration: InputDecoration(labelText: "Classe"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _serieController,
                    decoration: InputDecoration(labelText: "Série"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _nomParentController,
                    decoration: InputDecoration(labelText: "Nom du parent"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _prenomsParentController,
                    decoration: InputDecoration(labelText: "Prénoms du parent"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  TextFormField(
                    controller: _anneController,
                    decoration: InputDecoration(labelText: "Année"),
                    validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _ajouterEleve();
                      Navigator.pop(context);
                    },
                    child: const Text("Valider"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Ajouter un élève", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                ),
                onPressed: () {
                  _afficherFormulairePopup(context);
                },
                child: const Text("Ajouter un élève", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _filtreAnneeController,
                decoration: const InputDecoration(
                  labelText: "Filtrer par année",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Eleves').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final filteredDocs = snapshot.data!.docs.where((eleve) {
                    return _filtreAnneeController.text.isEmpty ||
                        eleve['Annee'] == _filtreAnneeController.text;
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var eleve = filteredDocs[index];
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
                              backgroundColor: Colors.pink,
                              child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${eleve['Nom']} ${eleve['Prenoms']}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text("Classe : ${eleve['Classe']}, Série : ${eleve['Serie']}"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Naviguer vers la page des notes pour l'élève sélectionné
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NotesPage(eleveId: eleve.id)),
                                );
                              },
                              child: const Text("Notes"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  final String eleveId;
  const NotesPage({Key? key, required this.eleveId}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _matiereController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _ajouterNote() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('Eleves')
            .doc(widget.eleveId)
            .collection('Notes')
            .add({
          'Note': double.parse(_noteController.text),
          'Matiere': _matiereController.text,
          'Date': _selectedDate,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note ajoutée avec succès'), backgroundColor: Colors.green),
        );

        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de la note'), backgroundColor: Colors.blue),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une note'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: "Note"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              TextFormField(
                controller: _matiereController,
                decoration: InputDecoration(labelText: "Matière"),
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              ElevatedButton(
                onPressed: () {
                  _ajouterNote();
                },
                child: const Text("Valider"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

