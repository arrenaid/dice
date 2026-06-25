import 'package:dice/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/dice_cubit.dart';
import 'bottom_sheet_widget.dart';

class CustomSideDiceSheet extends StatefulWidget {
  final double width;

  const CustomSideDiceSheet({super.key, required this.width});

  @override
  State<CustomSideDiceSheet> createState() => _CustomSideDiceSheetState();
}

class _CustomSideDiceSheetState extends State<CustomSideDiceSheet> {

  final List<int> _sides= [];
  final _formKey = GlobalKey<FormState>();
  bool _isVisible = false;

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
            const Divider( color: defSecClr,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dc${_sides.length}',
                  style: defTs
                ),
                ElevatedButton(
                  onPressed: () {
                    if(_sides.length > 1) {
                      context.read<DiceCubit>().insertDiceCustomSide(_sides);
                      Navigator.pop(context);
                    }else{
                      ScaffoldMessenger.of(context)
                          .showSnackBar(MySnackBar("Few sides"));
                    }
                  }, //Icon(CupertinoIcons.paperclip, color: defBtnClr,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defSecClr,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Save Dice',
                    style: defTs.copyWith(color: defBtnClr, shadows: []),),
                  // color: defSecClr,
                  // borderRadius: BorderRadius.circular(30),
                ),
              ],
            ),
            Text('Add side:',style: defTs,),
            addSide(context),
            SizedBox(
                height: MediaQuery.of(context).size.height/3,
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
                            Text('side ${index + 1}', style: defTs,),
                            Text(_sides[index].toString(), style: defTs,),
                            /*Bounce*/ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _sides.removeAt(index);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: defSecClr,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: SizedBox(
                                width: 50,
                                child: Icon(CupertinoIcons.delete_solid,
                                  color: defBtnClr,),
                              ),
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
          child: SizedBox(
            width: widget.width/2,
            child: TextFormField(
              cursorColor: defSecClr,
              decoration: const InputDecoration(hintText: "Number side",
                hintStyle: defTs ,
                suffixStyle: defTs,
                labelStyle: defTs,
                helperStyle: defTs,
                errorStyle: defTs,
                prefixStyle: defTs,
                counterStyle: defTs,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: defSecClr, width: 2.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: defSecClr, width: 2.5),
                ),
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
                if (int.parse(value) < -maxIntRandom) {
                  return "pls enter a larger number...";
                }
                if (int.parse(value) > maxIntRandom) {
                  return "pls enter number < $maxIntRandom...";
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
                  content: const Text( 'error form',
                    style: defTs,
                    textAlign: TextAlign.center,)));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: defSecClr,
            elevation: 3,
            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          child: const Icon(
            Icons.add,
            color: defPriClr,
          ),
        ),
      ],
    )
        :SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isVisible = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: defSecClr,
          elevation: 3,
          shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
        child: const Icon(
          Icons.add,
          color: defPriClr,
        ),
      ),
    );
  }
}
