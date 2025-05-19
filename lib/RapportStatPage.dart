/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RapportStatPage extends StatefulWidget {
  const RapportStatPage({super.key});

  @override
  State<RapportStatPage> createState() => _RapportStatPageState();
}

class _RapportStatPageState extends State<RapportStatPage> {
  final TextEditingController _yearController = TextEditingController();

  // Fonction pour afficher le dialogue d'entrée de l'année
  void _showYearDialog(String examType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Précisez l'année pour $examType"),
          content: TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Entrez l'année"),
          ),
          actions: [
            TextButton(
              child: const Text("Valider"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListeElevesPage(
                      examType: examType,
                      year: _yearController.text,
                    ),
                  ),
                );
              },
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
        title: const Text(
          "Statistiques",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showYearDialog("BAC"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Générer Stats du BAC"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showYearDialog("BEPC"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Générer Stats du BEPC"),
            ),
          ],
        ),
      ),
    );
  }
}

class ListeElevesPage extends StatefulWidget {
  final String examType;
  final String year;
  const ListeElevesPage({Key? key, required this.examType, required this.year}) : super(key: key);

  @override
  _ListeElevesPageState createState() => _ListeElevesPageState();
}

class _ListeElevesPageState extends State<ListeElevesPage> {
  List<DocumentSnapshot> elevesList = [];
  List<bool> selectedEleves = [];
  bool showGenerateButton = false;

  @override
  void initState() {
    super.initState();
    _fetchEleves();
  }

  Future<void> _fetchEleves() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Eleves')
        .where('Annee', isEqualTo: widget.year)
        .get();
    setState(() {
      elevesList = querySnapshot.docs;
      selectedEleves = List<bool>.filled(elevesList.length, false);
    });
  }

  void _toggleSelect(int index) {
    setState(() {
      selectedEleves[index] = !selectedEleves[index];
      showGenerateButton = selectedEleves.contains(true);
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final selectedCount = selectedEleves.where((e) => e).length;
    final successRate = (selectedCount / elevesList.length) * 100;
    final failureRate = 100 - successRate;

    final ByteData imageData = await rootBundle.load('assets/image.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                "RESULTATS DU ${widget.examType} DE L'ONG SHAB",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text("ANNEE ${widget.year}", style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Text("LISTES DES ADMIS :"),
              pw.SizedBox(height: 10),
              pw.ListView.builder(
                itemCount: elevesList.length,
                itemBuilder: (context, index) {
                  if (selectedEleves[index]) {
                    final eleve = elevesList[index];
                    return pw.Text("${eleve['Nom']} ${eleve['Prenoms']}");
                  }
                  return pw.SizedBox();
                },
              ),
              pw.SizedBox(height: 20),
              pw.Text("RAPPORT STATISTIQUES"),
              pw.Text("Pourcentage des admis: ${successRate.toStringAsFixed(2)}%"),
              pw.Text("Pourcentage des non-admis: ${failureRate.toStringAsFixed(2)}%"),
              pw.SizedBox(height: 20),
              pw.Center(child: pw.Image(image, width: 100, height: 100)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/rapport_statistique_${widget.examType}_${widget.year}.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PDF généré dans : ${file.path}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Élèves"),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView.builder(
        itemCount: elevesList.length,
        itemBuilder: (context, index) {
          final eleve = elevesList[index];
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text("${eleve['Nom']} ${eleve['Prenoms']}"),
              trailing: Checkbox(
                value: selectedEleves[index],
                onChanged: (value) => _toggleSelect(index),
                checkColor: Colors.white,
                activeColor: Colors.black,
              ),
            ),
          );
        },
      ),
      floatingActionButton: showGenerateButton
          ? FloatingActionButton.extended(
        label: const Text("Générer"),
        icon: const Icon(Icons.picture_as_pdf),
        onPressed: _generatePdf,
      )
          : null,
    );
  }
}
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RapportStatPage extends StatefulWidget {
  const RapportStatPage({super.key});

  @override
  State<RapportStatPage> createState() => _RapportStatPageState();
}

class _RapportStatPageState extends State<RapportStatPage> {
  final TextEditingController _yearController = TextEditingController();

  // Fonction pour afficher le dialogue d'entrée de l'année
  void _showYearDialog(String examType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Précisez l'année pour $examType"),
          content: TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Entrez l'année"),
          ),
          actions: [
            TextButton(
              child: const Text("Valider"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListeElevesPage(
                      examType: examType,
                      year: _yearController.text,
                    ),
                  ),
                );
              },
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
        title: const Text(
          "Statistiques",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showYearDialog("BAC"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Générer Stats du BAC",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showYearDialog("BEPC"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Générer Stats du BEPC",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class ListeElevesPage extends StatefulWidget {
  final String examType;
  final String year;
  const ListeElevesPage({Key? key, required this.examType, required this.year}) : super(key: key);

  @override
  _ListeElevesPageState createState() => _ListeElevesPageState();
}

class _ListeElevesPageState extends State<ListeElevesPage> {
  List<DocumentSnapshot> elevesList = [];
  List<bool> selectedEleves = [];
  bool showGenerateButton = false;

  @override
  void initState() {
    super.initState();
    _fetchEleves();
  }

  Future<void> _fetchEleves() async {
    // Définir la condition de filtre selon le type d'examen
    Query elevesQuery = FirebaseFirestore.instance
        .collection('Eleves')
        .where('Annee', isEqualTo: widget.year);

    // Appliquer le filtre pour le BEPC et le BAC
    if (widget.examType == "BEPC") {
      elevesQuery = elevesQuery.where('Classe', whereIn: ['3ème', '3eme', '3e']);
    } else if (widget.examType == "BAC") {
      elevesQuery = elevesQuery.where('Classe', whereIn: ['Tle', 'Terminale']);
    }

    final querySnapshot = await elevesQuery.get();
    setState(() {
      elevesList = querySnapshot.docs;
      selectedEleves = List<bool>.filled(elevesList.length, false);
    });
  }

  void _toggleSelect(int index) {
    setState(() {
      selectedEleves[index] = !selectedEleves[index];
      showGenerateButton = selectedEleves.contains(true);
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final selectedCount = selectedEleves.where((e) => e).length;
    final successRate = (selectedCount / elevesList.length) * 100;
    final failureRate = 100 - successRate;

    final ByteData imageData = await rootBundle.load('assets/image.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                "RESULTATS DU ${widget.examType} DE L'ONG SHAB",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text("ANNEE ${widget.year}", style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Text("LISTES DES ADMIS :"),
              pw.SizedBox(height: 10),
              pw.ListView.builder(
                itemCount: elevesList.length,
                itemBuilder: (context, index) {
                  if (selectedEleves[index]) {
                    final eleve = elevesList[index];
                    return pw.Text("${eleve['Nom']} ${eleve['Prenoms']}");
                  }
                  return pw.SizedBox();
                },
              ),
              pw.SizedBox(height: 20),
              pw.Text("RAPPORT STATISTIQUES"),
              pw.Text("Pourcentage des admis: ${successRate.toStringAsFixed(2)}%"),
              pw.Text("Pourcentage des non-admis: ${failureRate.toStringAsFixed(2)}%"),
              pw.SizedBox(height: 20),
              pw.Center(child: pw.Image(image, width: 100, height: 100)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/rapport_statistique_${widget.examType}_${widget.year}.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PDF généré dans : ${file.path}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Liste des Élèves",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),

      body: ListView.builder(
        itemCount: elevesList.length,
        itemBuilder: (context, index) {
          final eleve = elevesList[index];
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text("${eleve['Nom']} ${eleve['Prenoms']}"),
              trailing: Checkbox(
                value: selectedEleves[index],
                onChanged: (value) => _toggleSelect(index),
                checkColor: Colors.white,
                activeColor: Colors.black,
              ),
            ),
          );
        },
      ),
      floatingActionButton: showGenerateButton
          ? FloatingActionButton.extended(
        label: const Text("Générer"),
        icon: const Icon(Icons.picture_as_pdf),
        onPressed: _generatePdf,
      )
          : null,
    );
  }
}
