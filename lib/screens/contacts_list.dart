import 'package:bytebank_armazen_interno/models/contact.dart';
import 'package:bytebank_armazen_interno/screens/contact_form.dart';
import 'package:flutter/material.dart';

import '../database/dao/contact_dao.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {

  final ContactDao _dao = ContactDao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transfer"),
      ),
      body: FutureBuilder(
        future: _dao.findAll(),
        builder: (context, snapshot) {
          final List<Contact>? contacts = snapshot.data as List<Contact>?;
          switch(snapshot.connectionState){
            case ConnectionState.none:
              // Quando future ainda nao foi executado, ideal para colocar botao para comecar o future
              break;
            case ConnectionState.waiting:
              //Esperando o Future carregar
              Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text('Carregando...')
                    ],
                  )
              );
              break;
            case ConnectionState.active:
              //mostra tudo que foi carregado até o momento
              //usado para mostrar progresso de download, por exemplo
              //stream
              break;
            case ConnectionState.done:
              //future ja carregado
              if (contacts != null) {
                return ListView.builder(
                    itemBuilder: (context, index) {
                      final Contact contact = contacts[index];
                      return _ContactItem(contact);
                    },
                    itemCount: contacts.length);
              }
              break;
          }
          return const Text('UNKNOWN ERROR');
          }),

    floatingActionButton:
    FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => const ContactForm())).then((value) => setState(() {}));
      },
      child: const Icon(
        Icons.add,
      ),
    )
    ,
    );
  }
}

class _ContactItem extends StatelessWidget {

  final Contact contact;

  const _ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(contact.name,
          style: const TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(contact.accountNumber.toString(),
            style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
