import 'package:flutter/material.dart';
import 'package:mapapp/test/businesslogic/couple.dart';
import 'package:mapapp/test/model/couple.dart';

class CoupleInfoForm extends StatelessWidget {
  final CoupleService coupleService;
  final List<Couple> couples;
  final bool isCoupleLoaded;
  final Couple newCouple;
  final ValueChanged<Couple> onAdd;
  final ValueChanged<int> onDelete;
  final ValueChanged<List<Couple>> onSave;

  CoupleInfoForm({
    required this.coupleService,
    required this.couples,
    required this.isCoupleLoaded,
    required this.newCouple,
    required this.onAdd,
    required this.onDelete,
    required this.onSave,
  });

  final _coupleFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Couple _newCouple = newCouple;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Couples Info:'),
        if (isCoupleLoaded)
          Form(
            key: _coupleFormKey,
            child: Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: couples.length,
                itemBuilder: (context, index) {
                  final couple = couples[index];
                  return ListTile(
                    title: Text('Couple ID: ${couple.coupleId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: couple.anniversaryDate,
                          decoration:
                              InputDecoration(labelText: 'Anniversary Date'),
                          onSaved: (value) {
                            couples[index] =
                                couple.copyWith(anniversaryDate: value);
                          },
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        coupleService
                            .deleteCoupleInfo(couple.user1Id)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Couple info deleted')),
                          );
                          onDelete(index);
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to delete couple info: $error')),
                          );
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          )
        else
          _buildCoupleForm(context, _newCouple),
        ElevatedButton(
          onPressed: () {
            _coupleFormKey.currentState!.save(); // フォーム全体を保存
            for (var couple in couples) {
              coupleService.updateCoupleInfo(couple).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Couple info updated')),
                );
                onSave(couples);
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Failed to update couple info: $error')),
                );
              });
            }
          },
          child: Text('Save All Couples'),
        ),
      ],
    );
  }

  Widget _buildCoupleForm(BuildContext context, Couple newCouple) {
    return Form(
      key: _coupleFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'User 2 ID'),
            onSaved: (value) {
              newCouple = newCouple.copyWith(user2Id: value ?? '');
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Anniversary Date'),
            onSaved: (value) {
              newCouple = newCouple.copyWith(anniversaryDate: value ?? '');
            },
          ),
          ElevatedButton(
            onPressed: () {
              _coupleFormKey.currentState!.save();
              coupleService.addCoupleInfo(newCouple).then((_) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Couple info added')));
                onAdd(newCouple);
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to add couple info: $error')));
              });
            },
            child: Text('Add New Couple'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
