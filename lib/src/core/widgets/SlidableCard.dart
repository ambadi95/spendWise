import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableCard extends StatelessWidget {
  Widget? title;
  Widget? subTitle;
  Widget? trailing;
  final VoidCallback? onTap;
  final Function(BuildContext)? onPressDelete;

  SlidableCard({super.key, this.title, this.subTitle,this.trailing, this.onPressDelete, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Slidable(
          endActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              onPressed: onPressDelete,
              backgroundColor: Colors.red,
              icon: Icons.delete_forever,
              label: 'Delete',
            )
          ]), child: Card(
            child: ListTile(
              title: title,
              subtitle: subTitle,
              trailing: trailing,
            ),
      ),
      ),
    );
  }
}
