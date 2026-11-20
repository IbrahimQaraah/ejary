import '../entities/property.dart';
import '../repositories/property_repository.dart';

class GetPropertiesUseCase {
  final PropertyRepository repository;
  GetPropertiesUseCase(this.repository);

  Future<List<Property>> call() => repository.getAllProperties();
}

class CreatePropertyUseCase {
  final PropertyRepository repository;
  CreatePropertyUseCase(this.repository);

  Future<int> call(Property property) => repository.createProperty(property);
}

class GetPropertyByIdUseCase {
  final PropertyRepository repository;
  GetPropertyByIdUseCase(this.repository);

  Future<Property?> call(int id) => repository.getPropertyById(id);
}

class UpdatePropertyUseCase {
  final PropertyRepository repository;
  UpdatePropertyUseCase(this.repository);

  Future<void> call(Property property) => repository.updateProperty(property);
}

class DeletePropertyUseCase {
  final PropertyRepository repository;
  DeletePropertyUseCase(this.repository);

  Future<void> call(int id) => repository.deleteProperty(id);
}
