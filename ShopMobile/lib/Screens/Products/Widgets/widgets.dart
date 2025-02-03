import 'package:flutter/material.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

Future<bool> showDeleteAlert({required String itemsName, required BuildContext context}) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: const Text('Delete Confirmation'),
            title:  Text(lang.S.of(context).deleteConfirmation),
           // content: Text('Are you sure you want to delete this $itemsName?\nRelated data will be deleted also.'),
            content: Text('${lang.S.of(context).areYouSureYouWantToDeleteThis} $itemsName?\n${lang.S.of(context).relatedDataWillBeDeletedAlso}.'),
            actions: <Widget>[
              TextButton(
                //child: const Text('Cancel'),
                child:  Text(lang.S.of(context).cancel),
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false when Cancel is pressed
                },
              ),
              TextButton(
                child:  Text(
                  lang.S.of(context).delete,
                  //'Delete',
                  style: const TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true when Delete is pressed
                },
              ),
            ],
          );
        },
      ) ??
      false; // In case the dialog is dismissed without any action
}
