import 'package:dice/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bouncing_widgets/Widgets/bounce_elevated_button.dart';

import '../cubit/dice_cubit.dart';
import 'bottom_sheet_widget.dart';

class CustomSideDiceSheet extends StatefulWidget {
  @override
  State<CustomSideDiceSheet> createState() => _CustomSideDiceSheetState();
}

class _CustomSideDiceSheetState extends State<CustomSideDiceSheet> {

  final _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  final List<int> _sides= [];

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
            const Text('Add dice with a customizable side',
              style: defTs,
              textAlign: TextAlign.center,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dc' +  _sides.length.toString(),
                  style: defTs
                ),
                BounceElevatedButton(
                  onPressed: () {
                    if(_sides.length > 1) {
                      context.read<DiceCubit>().insertDiceCustomSide(_sides);
                      Navigator.pop(context);
                    }else{
                      ScaffoldMessenger.of(context)
                          .showSnackBar(MySnackBar("Few sides"));
                    }
                  },
                  child: Text('Save Dice',
                    style: defTs.copyWith(color: defBtnClr, shadows: []),), //Icon(CupertinoIcons.paperclip, color: defBtnClr,),
                  color: defSecClr,
                  borderRadius: BorderRadius.circular(30),
                ),
              ],
            ),
            Text('Add side:',style: defTs,),
            addSide(context),
            SizedBox(
                height: 300,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
              itemCount: _sides.length,

                itemBuilder: (item, index){
                  return _sides.length < 1
                      ? Text('empty', style: defTs,)
                      : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('side ' + ((index + 1).toString()), style: defTs,),
                            Text(_sides[index].toString(), style: defTs,),
                            BounceElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _sides.removeAt(index);
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
    return _isVisible
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            child: TextFormField(
              decoration: const InputDecoration(hintText: "Number side",
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
                _isVisible = false;
                _sides.add(formValue);
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
            _isVisible = true;
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
