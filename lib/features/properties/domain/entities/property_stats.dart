class PropertyStats {
  final int propertyId;
  final int totalApartments;
  final int occupiedApartments;
  final int availableApartments;
  final int maintenanceApartments;
  final double occupancyRate;
  final int expectedMonthlyIncome; // Minor units

  const PropertyStats({
    required this.propertyId,
    required this.totalApartments,
    required this.occupiedApartments,
    required this.availableApartments,
    required this.maintenanceApartments,
    required this.occupancyRate,
    required this.expectedMonthlyIncome,
  });

  factory PropertyStats.empty(int propertyId) {
    return PropertyStats(
      propertyId: propertyId,
      totalApartments: 0,
      occupiedApartments: 0,
      availableApartments: 0,
      maintenanceApartments: 0,
      occupancyRate: 0.0,
      expectedMonthlyIncome: 0,
    );
  }
}
