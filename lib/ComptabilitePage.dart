/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ComptabilitePage extends StatefulWidget {
  const ComptabilitePage({super.key});

  @override
  State<ComptabilitePage> createState() => _ComptabilitePageState();
}

class _ComptabilitePageState extends State<ComptabilitePage> {
  final TextEditingController _searchController = TextEditingController();
  int _chiffreAffaireTotal = 0;
  String _anneeCourante = DateTime.now().year.toString();
  List<Map<String, dynamic>> _elevesData = [];

  @override
  void initState() {
    super.initState();
    _fetchChiffreAffaireTotal(_anneeCourante);
    _fetchElevesData();
  }

  // Fonction pour récupérer le chiffre d'affaires total de l'année en cours
  void _fetchChiffreAffaireTotal(String annee) async {
    int total = 0;
    final elevesSnapshot = await FirebaseFirestore.instance
        .collection('Eleves')
        .where('Annee', isEqualTo: annee)
        .get(); // Rechercher 'Annee' dans Eleves

    for (var eleve in elevesSnapshot.docs) {
      final paiementsSnapshot = await eleve.reference.collection('Paiement').get();
      for (var paiement in paiementsSnapshot.docs) {
        if (paiement['Statut'] == 'Payé') {
          total += 30000;
        }
      }
    }

    setState(() {
      _chiffreAffaireTotal = total;
    });
  }


  // Fonction pour récupérer les informations des élèves
  void _fetchElevesData() async {
    final elevesSnapshot = await FirebaseFirestore.instance.collection('Eleves').get();
    List<Map<String, dynamic>> tempData = [];

    for (var eleve in elevesSnapshot.docs) {
      final paiementsSnapshot = await eleve.reference.collection('Paiement').get();
      String statutPaiement = 'Non payé';
      String moisPaiement = '';

      // Boucler sur chaque mois pour vérifier le statut de paiement
      for (var paiement in paiementsSnapshot.docs) {
        moisPaiement = paiement.id; // Nom du mois en tant que document ID
        if (paiement['Statut'] == 'Payé') {
          statutPaiement = 'Payé';
          break; // Sortir de la boucle dès qu'un paiement est trouvé
        }
      }

      // Ajouter les données de l'élève et son statut de paiement
      tempData.add({
        'nom': eleve['Nom'],
        'prenom': eleve['Prenoms'],
        'mois': moisPaiement,
        'statut': statutPaiement,
      });
    }

    setState(() {
      _elevesData = tempData;
    });
  }

  // Recherche du chiffre d'affaires pour une année spécifique
  void _searchChiffreAffaireParAnnee(String annee) {
    _fetchChiffreAffaireTotal(annee);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Chiffre d\'Affaires',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Le chiffre d\'affaires pour l\'année $annee est $_chiffreAffaireTotal FCFA'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
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
        backgroundColor: Colors.blue[900],
        title: const Center(
          child: Text(
            "Point Comptable",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: 325, // Remplacez 200 par la largeur souhaitée
            height: 100, // Remplacez 150 par la hauteur souhaitée
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Année: $_anneeCourante',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'CA: $_chiffreAffaireTotal FCFA',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Rechercher par année",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchChiffreAffaireParAnnee(_searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _elevesData.length,
                itemBuilder: (context, index) {
                  final eleve = _elevesData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.orange[200] : Colors.lightGreen[200],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${index + 1}. ${eleve['Nom']} ${eleve['Prenoms']}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Mois: ${eleve['mois']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Statut: ${eleve['statut']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: eleve['statut'] == 'Payé' ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Afficher le nom et les prénoms de l'élève
                        Text(
                          "${index + 1}. ${eleve['nom']} ${eleve['prenom']}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        // Utiliser un FutureBuilder pour récupérer le statut de paiement
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Eleves')
                              .doc(eleve['id']) // Remplacer eleve.id par eleve['id'] si vous avez stocké l'id dans le Map
                              .collection('Paiement')
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // Afficher un indicateur de chargement pendant la récupération des données
                            }
                            if (snapshot.hasError) {
                              return Text('Erreur: ${snapshot.error}'); // Gérer les erreurs
                            }

                            // Une fois les données récupérées, vérifier le statut des paiements
                            int paiementCount = 0;
                            //String mois = DateFormat.MMMM('fr_FR').format(DateTime.now());
                            String mois = '';
                            String statut = 'Non payé';

                            // Parcourir les documents de la sous-collection Paiement
                            for (var paiement in snapshot.data!.docs) {
                              if (paiement['Statut'] == 'Payé') {
                                paiementCount++;
                                mois = paiement.id; // Utiliser l'ID du document comme mois
                                statut = 'Payé'; // Mettre à jour le statut
                              }
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Mois: $mois',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Statut: $statut',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: statut == 'Payé' ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),


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
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ComptabilitePage extends StatefulWidget {
  const ComptabilitePage({super.key});

  @override
  State<ComptabilitePage> createState() => _ComptabilitePageState();
}

class _ComptabilitePageState extends State<ComptabilitePage> {
  final TextEditingController _searchController = TextEditingController();
  int _chiffreAffaireTotal = 0;
  String _anneeCourante = DateTime.now().year.toString();
  List<Map<String, dynamic>> _elevesData = [];

  @override
  void initState() {
    super.initState();
    // Initialisation des données locales pour le formatage de la date
    initializeDateFormatting().then((_) {
      _fetchChiffreAffaireTotal(_anneeCourante);
      _fetchElevesData();
    });
  }

  // Fonction pour récupérer le chiffre d'affaires total de l'année en cours
  void _fetchChiffreAffaireTotal(String annee) async {
    int total = 0;
    final elevesSnapshot = await FirebaseFirestore.instance
        .collection('Eleves')
        .where('Annee', isEqualTo: annee)
        .get(); // Rechercher 'Annee' dans Eleves

    for (var eleve in elevesSnapshot.docs) {
      final paiementsSnapshot = await eleve.reference.collection('Paiement').get();
      for (var paiement in paiementsSnapshot.docs) {
        if (paiement['Statut'] == 'Payé') {
          total += 30000;
        }
      }
    }

    setState(() {
      _chiffreAffaireTotal = total;
    });
  }

  // Fonction pour récupérer les informations des élèves
  void _fetchElevesData() async {
    final elevesSnapshot = await FirebaseFirestore.instance.collection('Eleves').get();
    List<Map<String, dynamic>> tempData = [];

    String moisCourant = DateFormat.MMMM('fr_FR').format(DateTime.now()); // Récupérer le mois courant

    for (var eleve in elevesSnapshot.docs) {
      final paiementsSnapshot = await eleve.reference.collection('Paiement').get();
      String statutPaiement = 'Non payé';

      // Boucler sur chaque mois pour vérifier le statut de paiement
      for (var paiement in paiementsSnapshot.docs) {
        if (paiement.id == moisCourant && paiement['Statut'] == 'Payé') {
          statutPaiement = 'Payé';
          break;
        }
      }

      // Ajouter les données de l'élève et son statut de paiement pour le mois courant uniquement
      tempData.add({
        'nom': eleve['Nom'],
        'prenom': eleve['Prenoms'],
        'mois': moisCourant,
        'statut': statutPaiement,
      });
    }

    setState(() {
      _elevesData = tempData;
    });
  }

  // Recherche du chiffre d'affaires pour une année spécifique
  void _searchChiffreAffaireParAnnee(String annee) {
    _fetchChiffreAffaireTotal(annee);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Chiffre d\'Affaires',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Le chiffre d\'affaires pour l\'année $annee est $_chiffreAffaireTotal FCFA'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
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
        backgroundColor: Colors.blue[900],
        title: const Center(
          child: Text(
            "Point Comptable",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: 325,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Année: $_anneeCourante',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'CA: $_chiffreAffaireTotal FCFA',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Rechercher par année",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchChiffreAffaireParAnnee(_searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _elevesData.length,
                itemBuilder: (context, index) {
                  final eleve = _elevesData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.orange[200] : Colors.lightGreen[200],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${index + 1}. ${eleve['nom']} ${eleve['prenom']}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Mois: ${eleve['mois']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Statut: ${eleve['statut']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: eleve['statut'] == 'Payé' ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
