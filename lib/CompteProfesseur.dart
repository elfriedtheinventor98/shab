/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CompteProfesseur extends StatefulWidget {
  final String profId;

  const CompteProfesseur(this.profId, {Key? key}) : super(key: key);

  @override
  State<CompteProfesseur> createState() => _CompteProfesseurState();
}

class _CompteProfesseurState extends State<CompteProfesseur> {
  late int currentWeekNumber;
  late String currentYear;


  @override
  void initState() {
    super.initState();
    try {
      // Calcul de la semaine et de l'année en cours
      final now = DateTime.now();
      final weekOfYear = int.tryParse(DateFormat('w').format(now)) ?? 1; // Utilisation de `int.tryParse`
      currentWeekNumber = weekOfYear;
      currentYear = DateFormat('y').format(now);
    } catch (e) {
      // Si une erreur survient, affichez-la dans la console
      print("Erreur lors du calcul de la semaine ou de l'année : $e");
      currentWeekNumber = 1; // Valeur par défaut
      currentYear = DateFormat('y').format(DateTime.now());
    }
  }

  // Fonction pour rafraîchir la page
  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Planning",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container pour afficher "Semaine N° X" et l'année en cours
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    "Semaine N° $currentWeekNumber",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentYear,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Container pour afficher les données de la sous-collection "Planning"
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ProfShab')
                  .doc(widget.profId)
                  .collection('Planning')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.docs.map((doc) {
                      String jour = doc['Jour'];
                      String horaireDebut = doc['HoraireDebut'];
                      String horaireFin = doc['HoraireFin'];
                      String programme = doc['Programme'];

                      // Calcul de la date du jour
                      /*int weekday = _getWeekdayFromString(jour);
                      DateTime now = DateTime.now();
                      DateTime currentWeekDay = now.add(Duration(days: weekday - now.weekday));
                      String formattedDate = DateFormat('dd MMM yyyy').format(currentWeekDay);*/

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$jour",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              "Début: $horaireDebut | Fin: $horaireFin",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Programme: $programme",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Bouton Actualiser
            Center(
              child: ElevatedButton(
                onPressed: _refreshPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  "Actualiser",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getWeekdayFromString(String jour) {
    switch (jour.toLowerCase()) {
      case 'lundi':
        return 1;
      case 'mardi':
        return 2;
      case 'mercredi':
        return 3;
      case 'jeudi':
        return 4;
      case 'vendredi':
        return 5;
      case 'samedi':
        return 6;
      case 'dimanche':
        return 7;
      default:
        return DateTime.now().weekday; // Par défaut, retourne le jour actuel
    }
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CompteProfesseur extends StatefulWidget {
  final String profId;

  const CompteProfesseur(this.profId, {Key? key}) : super(key: key);

  @override
  State<CompteProfesseur> createState() => _CompteProfesseurState();
}

class _CompteProfesseurState extends State<CompteProfesseur> {
  late int currentWeekNumber;
  late String currentYear;

  @override
  void initState() {
    super.initState();
    // Calcul de la semaine actuelle et de l'année en cours
    DateTime now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    int dayOfYear = now.difference(startOfYear).inDays + 1;
    currentWeekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
    currentYear = DateFormat('y').format(now);
  }

  // Fonction pour rafraîchir la page
  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Enlève la flèche de retour
        title: const Center(
          child: Text(
            "Planning",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Centre tous les éléments sous l'AppBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container pour afficher "Semaine N° X" et l'année en cours
              Container(
                width: double.infinity, // Largeur pour occuper tout l'espace disponible
                height: 100, // Hauteur fixée
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      "Semaine N° $currentWeekNumber",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentYear,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Container pour afficher les données de la sous-collection "Planning"
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ProfShab')
                    .doc(widget.profId)
                    .collection('Planning')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    // Affiche un message si la sous-collection "Planning" est vide
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Pas encore de planning",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data!.docs.map((doc) {
                        String jour = doc['Jour'];
                        String horaireDebut = doc['HoraireDebut'];
                        String horaireFin = doc['HoraireFin'];
                        String programme = doc['Programme'];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$jour",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "Début: $horaireDebut | Fin: $horaireFin",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Programme: $programme",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Divider(color: Colors.grey),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Bouton Actualiser
              Center(
                child: ElevatedButton(
                  onPressed: _refreshPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    "Actualiser",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texte en blanc
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getWeekdayFromString(String jour) {
    switch (jour.toLowerCase()) {
      case 'lundi':
        return 1;
      case 'mardi':
        return 2;
      case 'mercredi':
        return 3;
      case 'jeudi':
        return 4;
      case 'vendredi':
        return 5;
      case 'samedi':
        return 6;
      case 'dimanche':
        return 7;
      default:
        return DateTime.now().weekday; // Par défaut, retourne le jour actuel
    }
  }
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CompteProfesseur extends StatefulWidget {
  final String profId;

  const CompteProfesseur(this.profId, {Key? key}) : super(key: key);

  @override
  State<CompteProfesseur> createState() => _CompteProfesseurState();
}

class _CompteProfesseurState extends State<CompteProfesseur> {
  late int currentWeekNumber;
  late String currentYear;

  @override
  void initState() {
    super.initState();
    // Calcul de la semaine actuelle et de l'année en cours
    DateTime now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    int dayOfYear = now.difference(startOfYear).inDays + 1;
    currentWeekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
    currentYear = DateFormat('y').format(now);
  }

  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profId.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "Erreur : ID du professeur non spécifié",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Planning",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 305,
                height: 130,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      "Semaine N° $currentWeekNumber",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentYear,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('ProfShab')
                    .where('profId', isEqualTo: widget.profId)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Pas encore de planning",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }

                  // Obtention de l'ID du document correspondant
                  String documentId = snapshot.data!.docs.first.id;
                  print("Document ID trouvé : $documentId");

                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('ProfShab')
                        .doc(documentId)
                        .snapshots(),
                    builder: (context, documentSnapshot) {
                      if (!documentSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!documentSnapshot.data!.exists) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              "Pas encore de planning",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }

                      // Extraction du champ Planning
                      var data = documentSnapshot.data!.data() as Map<String, dynamic>;
                      if (data['Planning'] == null) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              "Pas encore de planning",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }

                      // Affichage des détails du planning
                      var planning = data['Planning'];
                      List<dynamic> jours = planning['Jour'] ?? [];
                      String horaireDebut = planning['HoraireDebut'] ?? '';
                      String horaireFin = planning['HoraireFin'] ?? '';
                      String programme = planning['Programme'] ?? '';

                      print("Planning trouvé : $planning");

                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: jours.isNotEmpty
                              ? jours.map((jour) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$jour",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Début: $horaireDebut | Fin: $horaireFin",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Programme: $programme",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  //const Divider(color: Colors.grey),
                                ],
                              ),
                            );
                          }).toList()
                              : [
                            const Text(
                              "Pas encore de planning",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _refreshPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    "Actualiser",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
