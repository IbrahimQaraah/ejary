enum PayerResponsibility {
  owner,
  tenant;

  String get displayName {
    switch (this) {
      case PayerResponsibility.owner:
        return 'المالك';
      case PayerResponsibility.tenant:
        return 'المستأجر';
    }
  }
}
