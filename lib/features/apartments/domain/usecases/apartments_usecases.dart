import '../../../../core/enums/apartment_status.dart';
import '../entities/apartment.dart';
import '../entities/apartment_specification.dart';
import '../repositories/apartment_repository.dart';

class GetApartmentsByPropertyUseCase {
  final ApartmentRepository repository;
  GetApartmentsByPropertyUseCase(this.repository);

  Future<List<Apartment>> call(int propertyId) =>
      repository.getApartmentsByPropertyId(propertyId);
}

class GetApartmentSpecificationUseCase {
  final ApartmentRepository repository;
  GetApartmentSpecificationUseCase(this.repository);

  Future<ApartmentSpecification?> call(int apartmentId) =>
      repository.getSpecificationForApartment(apartmentId);
}

class CreateApartmentUseCase {
  final ApartmentRepository repository;
  CreateApartmentUseCase(this.repository);

  Future<int> call({
    required Apartment apartment,
    required ApartmentSpecification specification,
  }) => repository.createApartment(
    apartment: apartment,
    specification: specification,
  );
}

class UpdateApartmentStatusUseCase {
  final ApartmentRepository repository;
  UpdateApartmentStatusUseCase(this.repository);

  Future<void> call(int apartmentId, ApartmentStatus status) =>
      repository.updateApartmentStatus(apartmentId, status);
}

class DeleteApartmentUseCase {
  final ApartmentRepository repository;
  DeleteApartmentUseCase(this.repository);

  Future<void> call(int id) => repository.deleteApartment(id);
}
