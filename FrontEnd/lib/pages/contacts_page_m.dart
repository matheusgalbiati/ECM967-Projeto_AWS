import 'package:flutter/material.dart';

import 'package:sentinel_guard/models/bnavbar.dart';
import 'package:sentinel_guard/pages/contacts_page.dart';
import 'package:sentinel_guard/pages/contacts_page_c.dart';

class ContactsPageM extends StatefulWidget {
  final String userEmail;
  const ContactsPageM({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<ContactsPageM> createState() => _ContactsPageMState();
}

class _ContactsPageMState extends State<ContactsPageM> {
  final _controller = PageController();
  int currentPage = 0; // Variável para rastrear a página atual

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // Atualizar a página atual
      setState(() {
        currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(152, 218, 217, 1),
        title: Text(
          currentPage == 0 ? 'Seus dispositivos' : 'Compartilhados',
        ),
        leading: IconButton(
          onPressed: () {
            // Não faz nada
          },
          icon: const Icon(Icons.contacts),
        ),
      ),
    
      body: Column(
        children: [      
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.black)
              ),            
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    _controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                  },
                  child: Text(
                    'Seus dispositivos',
                    style: TextStyle(
                      fontWeight: currentPage == 0 ? FontWeight.bold : FontWeight.normal,
                      fontSize: currentPage == 0 ? 20 : 18,
                      color: currentPage == 0 ? Colors.black : Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                  },
                  child: Text(
                    'Compartilhados',
                    style: TextStyle(
                      fontWeight: currentPage == 1 ? FontWeight.bold : FontWeight.normal,
                      fontSize: currentPage == 1 ? 20 : 18,
                      color: currentPage == 1 ? Colors.black : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: PageView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              children: [
                ContactsPage(userEmail: widget.userEmail),
                ContactsPageC(userEmail: widget.userEmail),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromRGBO(152, 218, 217, 1))),
        ),
        child: bnavbar(userEmail: widget.userEmail, selectedIndex: 1),
      ),
    );
  }
}