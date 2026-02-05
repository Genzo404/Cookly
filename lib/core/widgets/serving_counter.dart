import 'package:flutter/material.dart';

class ServingCounter extends StatelessWidget {
  final int currentnum;
  final Function() onAdd;
  final Function() onRemove;
  const ServingCounter({
    super.key,
    required this.currentnum,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 2.5, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(children: [
        IconButton(onPressed: onRemove, icon: Icon(Icons.remove)),
        SizedBox(width: 10,),
        Text("$currentnum",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        SizedBox(width: 10,),
        IconButton(onPressed: onAdd, icon: Icon(Icons.add)),
      ],),
    );
  }
}
