class FilterParams {
  final String? roomType;
  final int? numberOfSeats;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? amenities;
  final String? plan;
  final String? paymentMethod;

  FilterParams({
    this.roomType,
    this.numberOfSeats,
    this.minPrice,
    this.maxPrice,
    this.amenities,
    this.plan,
    this.paymentMethod,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};

    if (roomType != null) params['roomType'] = roomType!.toUpperCase();
    if (numberOfSeats != null) params['numberOfSeats'] = numberOfSeats;
    if (minPrice != null) params['minPrice'] = minPrice;
    if (maxPrice != null) params['maxPrice'] = maxPrice;
    if (amenities != null && amenities!.isNotEmpty)
      params['amenities'] = amenities!.join(',');
    if (plan != null) params['plan'] = plan;
    if (paymentMethod != null) params['paymentMethod'] = paymentMethod;

    return params;
  }
}
