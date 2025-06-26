import 'package:whatsapp/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constant.dart';


class OTP_Scresn extends ConsumerWidget {
  const OTP_Scresn({Key? key, required this.verficationId}) : super(key: key);
  final String verficationId;

  Widget HeaderBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Row(
          children: [


            Spacer(),
            Text(
              "Verifying your number",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget body(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authviewProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Text(
          'We have sent an SMS with a code.',
          style: TextStyle(
            color: kkPrimaryColor,
            fontSize: MediaQuery.of(context).size.width * 0.040,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        SizedBox(
       width: MediaQuery.of(context).size.width * 0.3,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '* * * * * *',
              hintStyle: TextStyle(
               // fontSize: MediaQuery.of(context).size.width * 0.1,
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              if (val.length == 6) {
                verfiyOTP(ref, context, val.trim());
              }
            },
          ),
        ),
        if (userState.isLoading) CircularProgressIndicator(),
      ],
    );
  }

  void verfiyOTP(WidgetRef ref, BuildContext context, String userOTP) {


      ref.read(authviewProvider.notifier).verifyOTP(
          context: context,
          verificationId: verficationId,
          userOTP: userOTP);




  }

  Widget CreatePassword(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            onTap: () {},
            child: ListTile(
              title: Text(
                "تغيير كلمه السر",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              leading: Icon(Icons.lock),
              iconColor: Color(0xFF21945A),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF21945A),
                size: MediaQuery.of(context).size.width * 0.045,
              ),
            ),
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authviewProvider);


     if(userState.isLoading){
      Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
   else if (userState.errorMessage != null &&userState.errorMessage!.isNotEmpty) {
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
      body: ListView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
        children: [

          HeaderBuild(context),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),

          body(context, ref),


        ],
      ),
    );



  }
}

