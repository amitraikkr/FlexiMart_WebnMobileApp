import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/shop_category_provider.dart';
import '../../Repository/API/business_setup_repo.dart';
import '../../constant.dart';
import '../../model/business_category_model.dart';
import '../../model/lalnguage_model.dart';
import '../internet checker/Internet_check_provider/util/network_observer_provider.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _loadLanguages();
  }

  // Language? selectedLanguage;
  BusinessCategory? selectedBusinessCategory;
  List<Language> language = [];

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  TextEditingController addressController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DropdownButton<BusinessCategory> getCategory({required List<BusinessCategory> list}) {
    List<DropdownMenuItem<BusinessCategory>> dropDownItems = [];

    for (BusinessCategory category in list) {
      var item = DropdownMenuItem(
        value: category,
        child: Text(category.name),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      hint: Text(lang.S.of(context).selectBusinessCategory
          //'Select Business Category'
          ),
      items: dropDownItems,
      value: selectedBusinessCategory,
      onChanged: (value) {
        setState(() {
          selectedBusinessCategory = value!;
        });
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ProviderNetworkObserver(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Consumer(builder: (context, ref, __) {
          final businessCategoryList = ref.watch(businessCategoryProvider);

          return businessCategoryList.when(data: (categoryList) {
            return Scaffold(
              backgroundColor: kWhite,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                title: Text(
                  lang.S.of(context).setUpProfile,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              bottomNavigationBar: ButtonGlobal(
                iconWidget: Icons.arrow_forward,
                buttontext: lang.S.of(context).continueButton,
                iconColor: Colors.white,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () async {
                  if (selectedBusinessCategory != null) {
                    if (_formKey.currentState!.validate()) {
                      try {
                        BusinessSetupRepo businessSetupRepo = BusinessSetupRepo();
                        await businessSetupRepo.businessSetup(
                          context: context,
                          phone: phoneController.text,
                          address: addressController.text.isEmptyOrNull ? null : addressController.text,
                          categoryId: selectedBusinessCategory!.id.toString(),
                          image: pickedImage == null ? null : File(pickedImage!.path),
                          openingBalance: openingBalanceController.text.isEmptyOrNull ? null : openingBalanceController.text,
                        );
                      } catch (e) {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a Business Category')));
                  }

                  // Navigator.pushNamed(context, '/otp');
                },
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                                  shape: BoxShape.circle,
                                  image: pickedImage == null
                                      ? const DecorationImage(
                                          image: AssetImage('images/noImage.png'),
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
                                    // borderRadius: const BorderRadius.all(Radius.circular(120)),
                                    shape: BoxShape.circle,
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
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 60.0,
                            child: FormField(
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: kInputDecoration.copyWith(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: lang.S.of(context).businessCat,
                                      labelStyle: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                  child: DropdownButtonHideUnderline(child: getCategory(list: categoryList)),
                                );
                              },
                            ),
                          ),
                        ),

                        ///__________Phone_________________________
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 60.0,
                            child: AppTextField(
                              controller: phoneController,
                              validator: (value) {
                                return null;
                              },
                              textFieldType: TextFieldType.PHONE,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).phone,
                                hintText: lang.S.of(context).enterYourPhoneNumber,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),

                        ///_________Address___________________________
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            textFieldType: TextFieldType.ADDRESS,
                            controller: addressController,
                            decoration: kInputDecoration.copyWith(
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kGreyTextColor),
                              ),
                              labelText: lang.S.of(context).companyAddress,
                              hintText: lang.S.of(context).enterFullAddress,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),

                        ///________Opening_balance_______________________
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            validator: (value) {
                              return null;
                            },
                            controller: openingBalanceController, // Optional
                            textFieldType: TextFieldType.PHONE,
                            decoration: kInputDecoration.copyWith(
                              hintText: lang.S.of(context).enterOpeningBalance,
                              labelText: lang.S.of(context).openingBalance,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }, error: (e, stack) {
            return Center(
              child: Text(e.toString()),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        }),
      ),
    );
  }
}
