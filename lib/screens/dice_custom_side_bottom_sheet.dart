import 'package:dice/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bouncing_widgets/Widgets/bounce_elevated_button.dart';

class CustomSideDiceSheet extends StatefulWidget {
  @override
  State<CustomSideDiceSheet> createState() => _CustomSideDiceSheetState();
}

class _CustomSideDiceSheetState extends State<CustomSideDiceSheet> {

  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  List<double> sidesDice= [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defBtnClr,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Add dice dc' + sidesDice.length.toString(),style: defTs, textAlign: TextAlign.center,),
            Divider(),
            BounceElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(CupertinoIcons.paperclip, color: defBtnClr,),
              color: defSecClr,
              borderRadius: BorderRadius.circular(30),
            ),
            Text('Add side',style: defTs,),
            addSide(context),
            SizedBox(height: 300,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
              itemCount: sidesDice.length,

                itemBuilder: (item, index){
                  return sidesDice.length < 1
                      ? Text('empty', style: defTs,)
                      : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('side ' + ((index + 1).toString()), style: defTs,),
                            Text(sidesDice[index].toString(), style: defTs,),
                            BounceElevatedButton(
                              onPressed: () {
                                setState(() {
                                  sidesDice.removeAt(index);
                                });
                              },
                              child: SizedBox(
                                width: 50,
                                child: Icon(CupertinoIcons.delete_solid,
                                  color: defBtnClr,),
                              ),
                              color: defSecClr,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ],
                        ),
                      );
                }
            )
            ),
          ],
        ),
      ),
    );
  }


  Widget addSide(BuildContext context, ){
    int formValue = 1;
    return isVisible
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            child: TextFormField(
              decoration: InputDecoration(hintText: "Dice number",
                hintStyle: defTs ,
                suffixStyle: defTs,
                labelStyle: defTs,
                helperStyle: defTs,
                errorStyle: defTs,
                prefixStyle: defTs,
                counterStyle: defTs,
              ),
              style: defTs,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onSaved: (value) => formValue = int.parse(value!),
              validator: (value) {
                if (value!.isEmpty) {
                  return "pls enter...";
                }
                if (int.parse(value) < 1) {
                  return "pls enter number > 0...";
                }
                return null;
              },
              onFieldSubmitted: (_) => _formKey.currentState!.validate(),
            ),
          ),
        ),

        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                isVisible = false;
                sidesDice.add(formValue.toDouble());
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),),
                  elevation: 35,
                  duration: const Duration(seconds: 3),
                  backgroundColor:defBtnClr,
                  content: Text( 'error form',
                    style: defTs,
                    textAlign: TextAlign.center,)));
            }
          },
          child: Icon(
            Icons.add,
            color: defPriClr,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: defSecClr,
            elevation: 3,
            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    )
        :Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isVisible = true;
          });
        },
        child: Icon(
          Icons.add,
          color: defPriClr,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: defSecClr,
          elevation: 3,
          shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
