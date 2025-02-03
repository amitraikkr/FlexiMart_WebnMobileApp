// ignore_for_file: unused_result

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/category_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../Const/api_config.dart';
import 'Repo/category_repo.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({Key? key, required this.categoryModel}) : super(key: key);

  final CategoryModel categoryModel;

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<EditCategory> {
  bool showProgress = false;
  late String categoryName;
  bool sizeCheckbox = false;
  bool colorCheckbox = false;
  bool weightCheckbox = false;
  bool capacityCheckbox = false;
  bool typeCheckbox = false;
  TextEditingController categoryNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryNameController.text = widget.categoryModel.categoryName ?? '';
    sizeCheckbox = widget.categoryModel.variationSize ?? false;
    colorCheckbox = widget.categoryModel.variationColor ?? false;
    weightCheckbox = widget.categoryModel.variationWeight ?? false;
    capacityCheckbox = widget.categoryModel.variationSize ?? false;
    typeCheckbox = widget.categoryModel.variationType ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Image(
                image: AssetImage('images/x.png'),
              )),
          title: Text(
            lang.S.of(context).addCategory,
            //'Add Category',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: showProgress,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: kMainColor,
                      strokeWidth: 5.0,
                    ),
                  ),
                ),
                TextFormField(
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    // hintText: 'Enter category name',
                    hintText: lang.S.of(context).enterCategoryName,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    //labelText: 'Category name',
                    labelText: lang.S.of(context).categoryName,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  lang.S.of(context).selectVariations,
                ),
                //'Select variations : '),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(
                          lang.S.of(context).size,
                          // "Size",
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: sizeCheckbox,
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            sizeCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(
                          lang.S.of(context).color,
                          //"Color",
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: colorCheckbox,
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            colorCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(
                          lang.S.of(context).weight,
                          // "Weight",
                          overflow: TextOverflow.ellipsis,
                        ),
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        value: weightCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            weightCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(
                          lang.S.of(context).capacity,
                          // "Capacity",
                          overflow: TextOverflow.ellipsis,
                        ),
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        value: capacityCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            capacityCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: Text(
                    lang.S.of(context).type,
                    //"Type",
                    overflow: TextOverflow.ellipsis,
                  ),
                  checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  value: typeCheckbox,
                  onChanged: (newValue) {
                    setState(() {
                      typeCheckbox = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              height: 200.0,
                              width: MediaQuery.of(context).size.width - 80,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.photo_library_rounded,
                                            size: 60.0,
                                            color: kMainColor,
                                          ),
                                          Text(
                                            lang.S.of(context).gallery,
                                            //'Gallery',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20.0,
                                              color: kMainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40.0,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        pickedImage = await _picker.pickImage(source: ImageSource.camera);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.camera,
                                            size: 60.0,
                                            color: kGreyTextColor,
                                          ),
                                          Text(
                                            lang.S.of(context).camera,
                                            style: GoogleFonts.poppins(
                                              fontSize: 20.0,
                                              color: kGreyTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          image: pickedImage == null
                              ? widget.categoryModel.icon == null
                                  ? DecorationImage(
                                      image: AssetImage(noProductImageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage('${APIConfig.domain}${widget.categoryModel.icon ?? ''}'),
                                      fit: BoxFit.cover,
                                    )
                              : DecorationImage(
                                  image: FileImage(File(pickedImage!.path)),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            color: kMainColor,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonGlobalWithoutIcon(
                  //buttontext: 'Save',
                  buttontext: lang.S.of(context).save,
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    final categoryRepo = CategoryRepo();
                    await categoryRepo.editCategory(
                      id: widget.categoryModel.id ?? 0,
                      ref: ref,
                      context: context,
                      name: categoryNameController.text,
                      variationSize: sizeCheckbox,
                      variationColor: colorCheckbox,
                      variationCapacity: capacityCheckbox,
                      variationType: typeCheckbox,
                      variationWeight: weightCheckbox,
                      image: pickedImage == null ? null : File(pickedImage!.path),
                    );
                    setState(() {
                      showProgress = false;
                    });
                  },
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
