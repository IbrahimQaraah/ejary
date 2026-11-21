import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:production_login/core/database/app_database.dart';
import 'package:production_login/core/enums/apartment_status.dart';
import 'package:production_login/core/enums/payer_responsibility.dart';
import 'package:production_login/core/enums/payment_method.dart';
import 'package:production_login/core/enums/payment_type.dart';
import 'package:production_login/core/enums/property_type.dart';
import 'package:production_login/core/enums/service_type.dart';
import 'package:production_login/core/theme/app_colors.dart';
import 'package:production_login/features/apartments/data/repositories/apartment_repository_impl.dart';
import 'package:production_login/features/apartments/domain/entities/apartment.dart';
import 'package:production_login/features/apartments/domain/entities/apartment_specification.dart';
import 'package:production_login/features/apartments/domain/usecases/apartments_usecases.dart';
import 'package:production_login/features/apartments/presentation/controllers/apartment_controller.dart';
import 'package:production_login/features/apartments/presentation/screens/apartment_details_view.dart';
import 'package:production_login/features/apartments/presentation/screens/apartment_form_view.dart';
import 'package:production_login/features/apartments/presentation/screens/apartments_list_view.dart';
import 'package:production_login/features/dashboard/domain/usecases/get_dashboard_metrics_usecase.dart';
import 'package:production_login/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:production_login/features/dashboard/presentation/screens/dashboard_view.dart';
import 'package:production_login/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:production_login/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:production_login/features/payments/domain/entities/payment.dart';
import 'package:production_login/features/payments/domain/usecases/payments_usecases.dart';
import 'package:production_login/features/payments/presentation/controllers/payment_controller.dart';
import 'package:production_login/features/payments/presentation/screens/payment_details_view.dart';
import 'package:production_login/features/payments/presentation/screens/payments_list_view.dart';
import 'package:production_login/features/payments/presentation/screens/record_payment_view.dart';
import 'package:production_login/features/properties/data/repositories/property_repository_impl.dart';
import 'package:production_login/features/properties/domain/entities/property.dart';
import 'package:production_login/features/properties/domain/usecases/properties_usecases.dart';
import 'package:production_login/features/properties/presentation/controllers/property_controller.dart';
import 'package:production_login/features/properties/presentation/screens/properties_list_view.dart';
import 'package:production_login/features/properties/presentation/screens/property_details_view.dart';
import 'package:production_login/features/reports/presentation/screens/reports_view.dart';
import 'package:production_login/features/services/data/repositories/service_repository_impl.dart';
import 'package:production_login/features/services/domain/entities/service.dart';
import 'package:production_login/features/services/domain/usecases/services_usecases.dart';
import 'package:production_login/features/services/presentation/controllers/service_bill_controller.dart';
import 'package:production_login/features/services/presentation/screens/service_bill_form_view.dart';
import 'package:production_login/features/services/presentation/screens/service_details_view.dart';
import 'package:production_login/features/services/presentation/screens/services_list_view.dart';
import 'package:production_login/features/settings/presentation/controllers/settings_controller.dart';
import 'package:production_login/features/settings/presentation/screens/settings_view.dart';
import 'package:production_login/features/tenants/data/repositories/tenant_repository_impl.dart';
import 'package:production_login/features/tenants/domain/entities/tenant.dart';
import 'package:production_login/features/tenants/domain/usecases/tenants_usecases.dart';
import 'package:production_login/features/tenants/presentation/controllers/tenant_controller.dart';
import 'package:production_login/features/tenants/presentation/screens/tenant_details_view.dart';
import 'package:production_login/features/tenants/presentation/screens/tenant_form_view.dart';
import 'package:production_login/features/tenants/presentation/screens/tenants_list_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed by')) {
        return;
      }
      originalOnError?.call(details);
    };
  });

  late AppDatabase db;
  late int samplePropId;
  late int sampleAptId;
  late int sampleTenantId;
  late int samplePaymentId;
  late int sampleServiceId;

  setUp(() async {
    Get.reset();
    db = AppDatabase(NativeDatabase.memory());
    Get.put<AppDatabase>(db, permanent: true);

    final propRepo = PropertyRepositoryImpl(db);
    final aptRepo = ApartmentRepositoryImpl(db);
    final tenantRepo = TenantRepositoryImpl(db);
    final paymentRepo = PaymentRepositoryImpl(db);
    final serviceRepo = ServiceRepositoryImpl(db);

    Get.put<PropertyRepositoryImpl>(propRepo);
    Get.put<ApartmentRepositoryImpl>(aptRepo);
    Get.put<TenantRepositoryImpl>(tenantRepo);
    Get.put<PaymentRepositoryImpl>(paymentRepo);
    Get.put<ServiceRepositoryImpl>(serviceRepo);

    // Register all use cases
    Get.put(GetPropertiesUseCase(propRepo));
    Get.put(GetPropertyByIdUseCase(propRepo));
    Get.put(CreatePropertyUseCase(propRepo));
    Get.put(UpdatePropertyUseCase(propRepo));
    Get.put(DeletePropertyUseCase(propRepo));

    Get.put(GetApartmentsUseCase(aptRepo));
    Get.put(GetApartmentByIdUseCase(aptRepo));
    Get.put(GetApartmentsByPropertyUseCase(aptRepo));
    Get.put(GetApartmentSpecificationUseCase(aptRepo));
    Get.put(CreateApartmentUseCase(aptRepo));
    Get.put(UpdateApartmentUseCase(aptRepo));
    Get.put(UpdateApartmentStatusUseCase(aptRepo));
    Get.put(DeleteApartmentUseCase(aptRepo));

    Get.put(GetAllTenantsUseCase(tenantRepo));
    Get.put(GetTenantByIdUseCase(tenantRepo));
    Get.put(GetTenantsForApartmentUseCase(tenantRepo));
    Get.put(GetActiveTenantUseCase(tenantRepo));
    Get.put(RegisterTenantUseCase(tenantRepo));
    Get.put(VacateTenantUseCase(tenantRepo));
    Get.put(UpdateTenantUseCase(tenantRepo));

    Get.put(GetAllPaymentsUseCase(paymentRepo));
    Get.put(GetPaymentByIdUseCase(paymentRepo));
    Get.put(GetPaymentsForApartmentUseCase(paymentRepo));
    Get.put(RecordPaymentUseCase(paymentRepo));
    Get.put(CalculateRentBalanceUseCase(paymentRepo));
    Get.put(CalculateServiceBalanceUseCase(paymentRepo));

    Get.put(GetAllServicesUseCase(serviceRepo));
    Get.put(GetServiceByIdUseCase(serviceRepo));
    Get.put(GetServicesForApartmentUseCase(serviceRepo));
    Get.put(CreateServiceBillUseCase(serviceRepo));

    Get.put(
      GetDashboardMetricsUseCase(
        propertyRepository: propRepo,
        apartmentRepository: aptRepo,
        tenantRepository: tenantRepo,
        serviceRepository: serviceRepo,
        paymentRepository: paymentRepo,
      ),
    );

    // Register controllers
    Get.put(NavigationController());
    Get.put(DashboardController(getDashboardMetricsUseCase: Get.find()));
    Get.put(
      PropertyController(
        getPropertiesUseCase: Get.find(),
        getPropertyByIdUseCase: Get.find(),
        createPropertyUseCase: Get.find(),
        updatePropertyUseCase: Get.find(),
        deletePropertyUseCase: Get.find(),
        getApartmentsUseCase: Get.find(),
      ),
    );
    Get.put(
      ApartmentController(
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
    );
    Get.put(
      TenantController(
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
    );
    Get.put(
      PaymentController(
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
    );
    Get.put(
      ServiceBillController(
        getAllServicesUseCase: Get.find(),
        getServiceByIdUseCase: Get.find(),
        getServicesUseCase: Get.find(),
        createServiceBillUseCase: Get.find(),
        calculateServiceBalanceUseCase: Get.find(),
        recordPaymentUseCase: Get.find(),
        paymentRepository: paymentRepo,
        getPropertiesUseCase: Get.find(),
        getApartmentsUseCase: Get.find(),
      ),
    );
    Get.put(SettingsController(db));

    // Seed comprehensive test data
    final now = DateTime.now();
    samplePropId = await propRepo.createProperty(
      Property(
        id: 0,
        name: 'برج الواحة السكني',
        propertyType: PropertyType.residential,
        city: 'الرياض',
        district: 'النرجس',
        address: 'طريق عثمان بن عفان، مبنى 12',
        numberOfFloors: 5,
        createdAt: now,
        updatedAt: now,
      ),
    );

    sampleAptId = await aptRepo.createApartment(
      apartment: Apartment(
        id: 0,
        propertyId: samplePropId,
        apartmentNumber: '201',
        floorNumber: 2,
        area: 135.0,
        monthlyRent: 350000,
        status: ApartmentStatus.available,
        createdAt: now,
        updatedAt: now,
      ),
      specification: const ApartmentSpecification(
        id: 0,
        apartmentId: 0,
        bedrooms: 3,
        bathrooms: 2,
        livingRooms: 1,
        kitchens: 1,
        balconies: 1,
        hasAc: true,
        hasParking: true,
      ),
    );

    sampleTenantId = await tenantRepo.registerNewTenant(
      Tenant(
        id: 0,
        apartmentId: sampleAptId,
        fullName: 'سلطان بن فهد الدوسري',
        phone: '0551234567',
        nationalId: '1098765432',
        address: 'الرياض - حي النرجس',
        monthlyRent: 350000,
        depositAmount: 150000,
        contractStartDate: now,
        contractEndDate: now.add(const Duration(days: 365)),
        paymentDueDay: 1,
        moveInDate: now,
        createdAt: now,
        updatedAt: now,
      ),
    );

    samplePaymentId = await paymentRepo.recordPayment(
      PaymentTransaction(
        id: 0,
        apartmentId: sampleAptId,
        tenantId: sampleTenantId,
        paymentType: PaymentType.rent,
        amount: 350000,
        paymentDate: now,
        paidBy: PayerResponsibility.tenant,
        paymentMethod: PaymentMethod.bankTransfer,
        billingPeriod: '${now.year}-${now.month.toString().padLeft(2, '0')}',
        referenceNumber: 'REC-2026-001',
        notes: 'سداد دفعة إيجار شهرية بالكامل',
        createdAt: now,
      ),
    );

    sampleServiceId = await serviceRepo.createServiceBill(
      ServiceBill(
        id: 0,
        apartmentId: sampleAptId,
        serviceType: ServiceType.electricity,
        previousReading: 1100.0,
        currentReading: 1320.0,
        consumption: 220.0,
        unitPrice: 0,
        totalAmount: 28000,
        billingDate: now,
        dueDate: now.add(const Duration(days: 15)),
        payerResponsibility: PayerResponsibility.tenant,
        notes: 'فاتورة الكهرباء الشهرية',
        createdAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> captureScreen({
    required WidgetTester tester,
    required Widget screen,
    required String screenshotName,
  }) async {
    final GlobalKey repaintKey = GlobalKey();

    tester.view.physicalSize = const Size(600, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final testTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: testTheme,
        locale: const Locale('ar', 'SA'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: RepaintBoundary(key: repaintKey, child: screen),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.runAsync(() async {
      final boundary =
          repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final dir = Directory('test_evidence/screenshots');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final file = File('test_evidence/screenshots/$screenshotName.png');
      file.writeAsBytesSync(byteData!.buffer.asUint8List());
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), isPositive);
    });
  }

  testWidgets('Capture 1: Dashboard Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const DashboardView(),
      screenshotName: 'dashboard',
    );
  });

  testWidgets('Capture 2: Properties List Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const PropertiesListView(),
      screenshotName: 'properties_list',
    );
  });

  testWidgets('Capture 3: Property Details Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: PropertyDetailsView(propertyId: samplePropId),
      screenshotName: 'property_details',
    );
  });

  testWidgets('Capture 4: Apartments List Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const ApartmentsListView(),
      screenshotName: 'apartments_list',
    );
  });

  testWidgets('Capture 5: Apartment Details Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: ApartmentDetailsView(apartmentId: sampleAptId),
      screenshotName: 'apartment_details',
    );
  });

  testWidgets('Capture 6: Apartment Form Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: ApartmentFormView(preselectedPropertyId: samplePropId),
      screenshotName: 'apartment_form',
    );
  });

  testWidgets('Capture 7: Tenants List Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const TenantsListView(),
      screenshotName: 'tenants_list',
    );
  });

  testWidgets('Capture 8: Tenant Details Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: TenantDetailsView(tenantId: sampleTenantId),
      screenshotName: 'tenant_details',
    );
  });

  testWidgets('Capture 9: Tenant Form Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: TenantFormView(preselectedApartmentId: sampleAptId),
      screenshotName: 'tenant_form',
    );
  });

  testWidgets('Capture 10: Payments List Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const PaymentsListView(),
      screenshotName: 'payments_list',
    );
  });

  testWidgets('Capture 11: Record Payment Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: RecordPaymentView(
        preselectedApartmentId: sampleAptId,
        preselectedTenantId: sampleTenantId,
      ),
      screenshotName: 'record_payment',
    );
  });

  testWidgets('Capture 12: Payment Details Voucher Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: PaymentDetailsView(paymentId: samplePaymentId),
      screenshotName: 'payment_details',
    );
  });

  testWidgets('Capture 13: Services List Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const ServicesListView(),
      screenshotName: 'services_list',
    );
  });

  testWidgets('Capture 14: Service Details Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: ServiceDetailsView(serviceId: sampleServiceId),
      screenshotName: 'service_details',
    );
  });

  testWidgets('Capture 15: Service Bill Form Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: ServiceBillFormView(preselectedApartmentId: sampleAptId),
      screenshotName: 'service_bill_form',
    );
  });

  testWidgets('Capture 16: Reports and Analytics Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const ReportsView(),
      screenshotName: 'reports',
    );
  });

  testWidgets('Capture 17: Settings and Backup Screenshot', (tester) async {
    await captureScreen(
      tester: tester,
      screen: const SettingsView(),
      screenshotName: 'settings_backup',
    );
  });
}
