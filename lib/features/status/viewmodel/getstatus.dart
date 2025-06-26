
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/status/status.dart';
import '../repository/status_repository.dart';
final getstatusProvider = StateNotifierProvider<GetStatu,List<Status>>((ref) {
  final statusRepository = ref.watch(statusRepositoryProvider); // تأكد من وجود provider لـ StatusRepository
  return GetStatu(statusRepository);
});


class GetStatu extends StateNotifier<List<Status>> {
  final StatusRepository statusRepository;

  GetStatu(this.statusRepository) : super([]);

  Future<List<Status>>fetchStatus(BuildContext context) async {

      final List<Status> statuses = await statusRepository.getStatus(context);
     return state = statuses;

  }
}
