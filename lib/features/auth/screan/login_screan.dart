
import 'package:whatsapp/features/auth/viewmodel/auth_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../../../common/widgets/Buttom_container.dart';
import '../../../common/widgets/Form_Container.dart';
import '../../../constant.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class Login_Screan extends ConsumerStatefulWidget {
  const Login_Screan({Key? key}) : super(key: key);

  @override
  ConsumerState<Login_Screan> createState() => _Login_ScreanState();
}

class _Login_ScreanState extends ConsumerState<Login_Screan> {
  final Phone_Controller = TextEditingController();
  Country? country;
  bool isLoading = false; // حالة التحميل
  bool isSuccess = false; // حالة النجاح
  String errorMessage = '';
  @override
  void dispose() {
    Phone_Controller.dispose(); // Ensure you dispose the viewmodel correctly
    super.dispose();
  }

  void selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  Widget HeaderBuild() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 50.0,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Row(
          children: [

            Spacer(), // Pushes the next widget to the far right
            Text(
              "Enter your password",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(), // Optional: To center the text further
          ],
        ),
      ),
    );
  }

  Widget bobScrean() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            "ChattingApp will need to verify your phone number",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          TextButton(
            onPressed: selectCountry,
            child: Text(
              'Pick Your Country',
              style: TextStyle(
                color: kkPrimaryColor,
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            children: [
              if (country != null)
                Text(
                  '+${country!.phoneCode}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              Expanded(
                child: FormContainerWidget(
                  controller: Phone_Controller,
                  hintText: 'Phone number',
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ButtonContainerWidget(
            color: kkPrimaryColor,
            text: 'Next',
            onTapListener: signInWithPhone,
          ),
        ],
      ),
    );
  }


  void signInWithPhone() async {
    final phonenumber = Phone_Controller.text.trim();

    if (country != null && phonenumber.isNotEmpty) {
      ref.read(authviewProvider.notifier).signInWithPhonenumber(
        context,
        '+${country!.phoneCode}$phonenumber',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authviewProvider);
    if(userState.isLoading){
      Center(
        child: CircularProgressIndicator(),
      );
    }
   else if  (userState.errorMessage != null && userState.errorMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userState.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      });
    }


    return Scaffold(

      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [

                HeaderBuild(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),


                bobScrean(),







              ],
            ),
          ),
        ],
      ),
    );
  }
}

