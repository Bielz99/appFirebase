import 'package:app_firebase/components/menu_drawer.dart';
import 'package:app_firebase/helpers/hour_helpers.dart';
import 'package:app_firebase/models/hours_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HoursModel> listHours = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horas'),
      ),
      drawer: MenuDrawer(user: widget.user),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listHours.isEmpty)
          ? const Center(
              child: Text(
              'Nenhuma hora registrada',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ))
          : ListView(
              padding: const EdgeInsets.only(left: 4, right: 4),
              children: List.generate(listHours.length, (index) {
                HoursModel model = listHours[index];
                return Dismissible(
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 12),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    remove(model);
                  },
                  key: ValueKey<HoursModel>(model),
                  direction: DismissDirection.endToStart,
                  child: Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          ListTile(
                            onLongPress: () {
                              showFormModal(model: model);
                            },
                            onTap: () {},
                            leading: const Icon(
                              Icons.list_alt_rounded,
                              size: 56,
                            ),
                            title: Text(
                                'Data: ${model.data}, hora: ${HourHelpers.minutesToHours(model.minutos)}'),
                            subtitle: Text(model.description!),
                          )
                        ],
                      )),
                );
              }),
            ),
    );
  }

  showFormModal({HoursModel? model}) {
    String title = 'Adicionar';
    String confirmationButton = 'Salvar';
    String skipButton = 'Cancelar';

    TextEditingController dataController = TextEditingController();
    final dateMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');
    TextEditingController minutesController = TextEditingController();
    final minutesMaskFormatter = MaskTextInputFormatter(mask: '##:##');
    TextEditingController descricaoController = TextEditingController();

    if (model != null) {
      title = 'Editando';
      dataController.text = model.data;
      minutesController.text = HourHelpers.minutesToHours(model.minutos);

      if (model.description != null) {
        descricaoController.text = model.description!;
      }
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32),
          child: ListView(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: dataController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [dateMaskFormatter],
                decoration: const InputDecoration(
                  hintText: '01/06/2024',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                inputFormatters: [minutesMaskFormatter],
                decoration: const InputDecoration(
                  hintText: '00:00',
                  labelText: 'Horas trabalhadas',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(
                    hintText: 'Lembrete do que você fez',
                    labelText: 'Descrição'),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      HoursModel hour = HoursModel(
                        id: const Uuid().v1(),
                        data: dataController.text,
                        minutos:
                            HourHelpers.hoursToMinutes(minutesController.text),
                      );
                      if (descricaoController.text != '') {
                        hour.description = descricaoController.text;
                      }

                      if (model != null) {
                        hour.id = model.id;
                      }
                      firestore
                          .collection(widget.user.uid)
                          .doc(hour.id)
                          .set(hour.toMap());

                      refresh();
                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void remove(HoursModel model) {
    firestore.collection(widget.user.uid).doc(model.id).delete();
  }

  Future<void> refresh() async {
    List<HoursModel> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(widget.user.uid).get();

    for (var doc in snapshot.docs) {
      temp.add(
        HoursModel.fromMap(
          doc.data(),
        ),
      );
    }
    setState(() {
      listHours = temp;
    });
  }
}
