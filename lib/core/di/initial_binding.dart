import 'package:get/get.dart';

import '../database/app_database.dart';
import '../../features/apartments/data/repositories/apartment_repository_impl.dart';
import '../../features/apartments/domain/repositories/apartment_repository.dart';
import '../../features/apartments/domain/usecases/apartments_usecases.dart';
import '../../features/apartments/presentation/controllers/apartment_controller.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_metrics_usecase.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/navigation/presentation/controllers/navigation_controller.dart';
import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/payments/domain/usecases/payments_usecases.dart';
import '../../features/payments/presentation/controllers/payment_controller.dart';
import '../../features/properties/data/repositories/property_repository_impl.dart';
import '../../features/properties/domain/repositories/property_repository.dart';
import '../../features/properties/domain/usecases/properties_usecases.dart';
import '../../features/properties/presentation/controllers/property_controller.dart';
import '../../features/services/data/repositories/service_repository_impl.dart';
import '../../features/services/domain/repositories/service_repository.dart';
import '../../features/services/domain/usecases/services_usecases.dart';
import '../../features/services/presentation/controllers/service_bill_controller.dart';
import '../../features/tenants/data/repositories/tenant_repository_impl.dart';
import '../../features/tenants/domain/repositories/tenant_repository.dart';
import '../../features/tenants/domain/usecases/tenants_usecases.dart';
import '../../features/tenants/presentation/controllers/tenant_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Core Database
    final db = AppDatabase();
    Get.put<AppDatabase>(db, permanent: true);

    // 2. Repositories
    Get.lazyPut<PropertyRepository>(
      () => PropertyRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ApartmentRepository>(
      () => ApartmentRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<TenantRepository>(
      () => TenantRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServiceRepository>(
      () => ServiceRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<PaymentRepository>(
      () => PaymentRepositoryImpl(Get.find()),
      fenix: true,
    );

    // 3. Properties UseCases
    Get.lazyPut(() => GetPropertiesUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPropertyByIdUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CreatePropertyUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdatePropertyUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeletePropertyUseCase(Get.find()), fenix: true);

    // 4. Apartments UseCases
    Get.lazyPut(() => GetApartmentsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetApartmentByIdUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetApartmentsByPropertyUseCase(Get.find()), fenix: true);
    Get.lazyPut(
      () => GetApartmentSpecificationUseCase(Get.find()),
      fenix: true,
    );
    Get.lazyPut(() => CreateApartmentUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateApartmentUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateApartmentStatusUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteApartmentUseCase(Get.find()), fenix: true);

    // 5. Tenants UseCases
    Get.lazyPut(() => GetAllTenantsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetTenantByIdUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetTenantsForApartmentUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetActiveTenantUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => RegisterTenantUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => VacateTenantUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateTenantUseCase(Get.find()), fenix: true);

    // 6. Services UseCases
    Get.lazyPut(() => GetAllServicesUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetServiceByIdUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetServicesForApartmentUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CreateServiceBillUseCase(Get.find()), fenix: true);

    // 7. Payments UseCases
    Get.lazyPut(() => GetAllPaymentsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPaymentByIdUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPaymentsForApartmentUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => RecordPaymentUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CalculateRentBalanceUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CalculateServiceBalanceUseCase(Get.find()), fenix: true);

    // 8. Dashboard UseCases
    Get.lazyPut(
      () => GetDashboardMetricsUseCase(
        propertyRepository: Get.find(),
        apartmentRepository: Get.find(),
        tenantRepository: Get.find(),
        serviceRepository: Get.find(),
        paymentRepository: Get.find(),
      ),
      fenix: true,
    );

    // 9. Navigation Controller
    Get.lazyPut(() => NavigationController(), fenix: true);

    // 10. Presentation Controllers
    Get.lazyPut(
      () => DashboardController(getDashboardMetricsUseCase: Get.find()),
      fenix: true,
    );
    Get.lazyPut(
      () => PropertyController(
        getPropertiesUseCase: Get.find(),
        getPropertyByIdUseCase: Get.find(),
        createPropertyUseCase: Get.find(),
        updatePropertyUseCase: Get.find(),
        deletePropertyUseCase: Get.find(),
        getApartmentsUseCase: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => ApartmentController(
        getAllApartmentsUseCase: Get.find(),
        getApartmentByIdUseCase: Get.find(),
        getApartmentsByPropertyUseCase: Get.find(),
        getSpecificationUseCase: Get.find(),
        createApartmentUseCase: Get.find(),
        updateApartmentUseCase: Get.find(),
        updateApartmentStatusUseCase: Get.find(),
        deleteApartmentUseCase: Get.find(),
        getPropertiesUseCase: Get.find(),
        getActiveTenantUseCase: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => TenantController(
        getAllTenantsUseCase: Get.find(),
        getTenantByIdUseCase: Get.find(),
        getTenantsUseCase: Get.find(),
        getActiveTenantUseCase: Get.find(),
        registerTenantUseCase: Get.find(),
        vacateTenantUseCase: Get.find(),
        updateTenantUseCase: Get.find(),
        getApartmentsUseCase: Get.find(),
        getApartmentByIdUseCase: Get.find(),
        getPropertiesUseCase: Get.find(),
        getPaymentsForApartmentUseCase: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => ServiceBillController(
        getAllServicesUseCase: Get.find(),
        getServiceByIdUseCase: Get.find(),
        getServicesUseCase: Get.find(),
        createServiceBillUseCase: Get.find(),
        calculateServiceBalanceUseCase: Get.find(),
        recordPaymentUseCase: Get.find(),
        paymentRepository: Get.find(),
        getPropertiesUseCase: Get.find(),
        getApartmentsUseCase: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => PaymentController(
        getAllPaymentsUseCase: Get.find(),
        getPaymentByIdUseCase: Get.find(),
        getPaymentsUseCase: Get.find(),
        recordPaymentUseCase: Get.find(),
        calculateRentBalanceUseCase: Get.find(),
        calculateServiceBalanceUseCase: Get.find(),
        getPropertiesUseCase: Get.find(),
        getApartmentsUseCase: Get.find(),
        getAllTenantsUseCase: Get.find(),
      ),
      fenix: true,
    );
  }
}
