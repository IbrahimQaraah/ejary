import '../../../../core/enums/apartment_status.dart';
import '../entities/apartment.dart';
import '../entities/apartment_specification.dart';

abstract class ApartmentRepository {
  Future<List<Apartment>> getAllApartments();
  Future<List<Apartment>> getApartmentsByPropertyId(int propertyId);
  Future<Apartment?> getApartmentById(int id);
  Future<ApartmentSpecification?> getSpecificationForApartment(int apartmentId);
  Future<int> createApartment({
    required Apartment apartment,
    required ApartmentSpecification specification,
  });
  Future<void> updateApartment(Apartment apartment);
  Future<void> updateSpecification(ApartmentSpecification specification);
  Future<void> updateApartmentAndSpecification({
    required Apartment apartment,
    required ApartmentSpecification specification,
  });
  Future<void> updateApartmentStatus(int apartmentId, ApartmentStatus status);
  Future<void> deleteApartment(int id);
}
