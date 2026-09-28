import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_service/features/auth/data/provider/join_data.dart';
import 'package:home_service/features/auth/data/provider/provider_repository.dart';

import 'provider_state.dart';

class ProviderCubit extends Cubit<ProviderState> {
  final ProviderRepository repository;

  ProviderCubit(this.repository) : super(ProviderInitial());

  Future<void> submitProvider(JoinData data) async {
    emit(ProviderLoading());

    try {
      await repository.submitProvider(data);

      emit(ProviderSuccess());
    } catch (e) {
      emit(
        ProviderError(
          'حدث خطأ أثناء إرسال الطلب، حاول مرة أخرى.',
        ),
      );
    }
  }
}