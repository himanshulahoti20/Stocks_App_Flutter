import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Row(
            children: [
              Icon(
                Icons.abc,
                size: 48,
              ),
              SizedBox(
                width: 18,
              ),
              Text(
                'Drawer Header',
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(EvaIcons.stopCircle),
          title: const Text('Item 1'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Item 2'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}
