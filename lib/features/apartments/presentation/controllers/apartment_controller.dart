import 'package:get/get.dart';

import '../../../../core/enums/apartment_status.dart';
import '../../domain/entities/apartment.dart';
import '../../domain/entities/apartment_specification.dart';
import '../../domain/usecases/apartments_usecases.dart';

class ApartmentController extends GetxController {
  final GetApartmentsByPropertyUseCase getApartmentsUseCase;
  final GetApartmentSpecificationUseCase getSpecificationUseCase;
  final CreateApartmentUseCase createApartmentUseCase;
  final UpdateApartmentStatusUseCase updateApartmentStatusUseCase;
  final DeleteApartmentUseCase deleteApartmentUseCase;

  ApartmentController({
    required this.getApartmentsUseCase,
    required this.getSpecificationUseCase,
    required this.createApartmentUseCase,
    required this.updateApartmentStatusUseCase,
    required this.deleteApartmentUseCase,
  });

  final RxList<Apartment> apartments = <Apartment>[].obs;
  final RxMap<int, ApartmentSpecification> specifications =
      <int, ApartmentSpecification>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadApartments(int propertyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final list = await getApartmentsUseCase(propertyId);
      apartments.assignAll(list);

      for (final apt in list) {
        final spec = await getSpecificationUseCase(apt.id);
        if (spec != null) {
          specifications[apt.id] = spec;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addApartment({
    required Apartment apartment,
    required ApartmentSpecification specification,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await createApartmentUseCase(
        apartment: apartment,
        specification: specification,
      );
      await loadApartments(apartment.propertyId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setStatus(
    int apartmentId,
    int propertyId,
    ApartmentStatus status,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await updateApartmentStatusUseCase(apartmentId, status);
      await loadApartments(propertyId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> removeApartment(int apartmentId, int propertyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await deleteApartmentUseCase(apartmentId);
      await loadApartments(propertyId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
