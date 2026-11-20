enum PayerResponsibility {
  owner,
  tenant;

  String get displayName {
    switch (this) {
      case PayerResponsibility.owner:
        return 'Owner';
      case PayerResponsibility.tenant:
        return 'Tenant';
    }
  }
}
