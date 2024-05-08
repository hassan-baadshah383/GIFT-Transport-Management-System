import 'package:flutter/material.dart';

class DashboardItems extends StatelessWidget {
  final String title;
  final Widget icon;
  final String route;
  final Color color;

  DashboardItems(this.title, this.icon, this.route, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Card(
          color: color,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                icon,
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
