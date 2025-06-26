
import 'package:whatsapp/features/status/viewmodel/getstatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/Loeading.dart';
import '../../../constant.dart';
import '../../../model/status/status.dart';


class StatusListScreen extends ConsumerWidget {
  const StatusListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth * 0.05; // 5% of screen width
    final double subtitleFontSize = screenWidth * 0.04; // 4% of screen width

    return FutureBuilder<List<Status>>(
      future: ref.read(getstatusProvider.notifier).fetchStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loeading();  // Corrected 'Loeading' to 'Loading'
        }
        if (snapshot.data!.isEmpty) {
          return Center(child: Text('No statuses found.'));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final statusData = snapshot.data![index];  // Accessing the data correctly

            return Column(
              children: [
                InkWell(
                  onTap: () {
              Navigator.pushNamed(
                context,
                PageConst.StatusScrean,
                   arguments : {
              'username': statusData.username,
             'profilePic': statusData.profilePic,
              'phoneNumber': statusData.phoneNumber,
              'PhotoUrl': statusData.PhotoUrl,
               'massage':statusData.massage,
                     'uid':statusData.uid
              },
              );

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      subtitle: Text(
                        statusData.phoneNumber,  // Assuming you want to show the phone number as a subtitle
                        style: TextStyle(fontSize: subtitleFontSize),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(),
              ],
            );
          },
        );
      },
    );
  }
}





