import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_service/features/auth/presentation/services/data/service_repository.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository repository;

  ServiceCubit(this.repository) : super(ServiceInitial());

  Future<void> getServicesByCategory(String categoryId) async {
    try {
      emit(ServiceLoading());

      print('CATEGORY ID: $categoryId');

      final services =
          await repository.getServicesByCategory(categoryId);

      print('SERVICES COUNT: ${services.length}');

      if (services.isEmpty) {
        emit(ServiceEmpty());
      } else {
        emit(ServiceLoaded(services));
      }
    } catch (e, stackTrace) {
      print('================ SERVICE ERROR ================');
      print(e);
      print(stackTrace);
      print('================================================');

      emit(
        ServiceError(
          'حدث خطأ أثناء تحميل الخدمات',
        ),
      );
    }
  }
}