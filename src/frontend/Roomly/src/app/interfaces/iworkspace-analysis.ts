import { IOffer, IReview, IRoom } from "./iworkspace";

export interface IWorkspaceAnalysis {
  amenities: {
    Description: string;
    Id: string;
    Name: string;
    RoomId: string;
    RoomName: string;
    RoomType: string;
    TotalCount: number;
    Type: string;
  }[];
  amenities_distribution: {
    AmenityCount: number;
    AverageItemsPerAmenity: string;
    RoomsWithThisAmenity: number;
    TotalItems: string;
    Type: string;
  }[];
  analytics: {
    AverageRating: number;
    Date: string;
    TotalBookings: number;
    TotalRevenue: number;
    UsagePatterns: string;
    WorkspaceId: string;
    WorkspaceName: string;
  }[];
  basic_info: {
    AvgRating: number;
    City: string;
    Country: string;
    CreatedDate: string;
    DailyPrice: number;
    Id: string;
    Latitude: number;
    Longitude: number;
    MonthPrice: number;
    Name: string;
    PaymentType: string;
    Town: string;
    Type: string;
    YearPrice: number;
  }[];
  customers: {
    AverageBookingValue: number;
    AverageDuration: string;
    Email: string;
    FName: string;
    FirstBooking: string;
    LName: string;
    LastBooking: string;
    TotalBookings: number;
    TotalSpent: number;
    UserId: string;
  }[];
  insights_summary: {
    kpis: {
      ActiveOffers: number;
      AvailableRooms: number;
      AverageRating: number;
      AverageRoomPrice: number;
      MonthlyRevenue: number;
      StaffCount: number;
      TotalAmenities: number;
      TotalReservations: number;
      TotalRevenue: number;
      TotalRooms: number;
    };
    performance: {
      AverageBookingDuration: string;
      AverageBookingValue: number;
      AverageOccupancyRate: string;
      MonthlyBookings: number;
      MonthlyRevenue: number;
      MonthlyUniqueCustomers: number;
    };
    top_customers: {
      AverageBookingValue: number;
      AverageDuration: string;
      Email: string;
      FName: string;
      FirstBooking: string;
      LName: string;
      LastBooking: string;
      TotalBookings: number;
      TotalSpent: number;
      UserId: string;
    }[];
    trends: {
      AverageBookingValue: number;
      AverageDuration: string;
      Bookings: number;
      Month: string;
      Revenue: number;
      UniqueCustomers: number;
    }[];
  };
  kpis: {
    ActiveOffers: number;
    AvailableRooms: number;
    AverageRating: number;
    AverageRoomPrice: number;
    MonthlyRevenue: number;
    StaffCount: number;
    TotalAmenities: number;
    TotalReservations: number;
    TotalRevenue: number;
    TotalRooms: number;
  }[];
  occupancy_heatmap: {
    AvailableSeats: number;
    Capacity: number;
    Date: string;
    Hour: number;
    OccupancyLevel: string;
    OccupancyRate: string;
    OccupiedSeats: number;
    RoomName: string;
  }[];
  offers: IOffer[];
  performance_metrics: {
    AverageBookingDuration: string;
    AverageBookingValue: number;
    AverageOccupancyRate: string;
    MonthlyBookings: number;
    MonthlyRevenue: number;
    MonthlyUniqueCustomers: number;
  }[];
  popular_booking_times: {
    AverageBookingValue: number;
    AverageDuration: string;
    BookingCount: number;
    HourOfDay: number;
  }[];
  popular_rooms: (IRoom & {
    AvailableCount: number;
    BookingCount: number;
    TotalRevenue: number;
  })[];
  reservation_kpis: {
    AverageBookingValue: number;
    AverageDurationHours: string;
    CancelledReservations: number;
    CompletedReservations: number;
    CompletionRate: string;
    ConfirmedReservations: number;
    RoomsBooked: number;
    TotalReservations: number;
    UniqueCustomers: number;
  }[];
  reservations: {
    AccessCode: string;
    BookingDate: string;
    DurationHours: number;
    Email: string;
    EndTime: string;
    FName: string;
    LName: string;
    ReservationId: string;
    ReservationStatus: string;
    ReservationType: string;
    RoomName: string;
    RoomType: string;
    StartTime: string;
    TotalCost: number;
  }[];
  revenue_analysis: {
    AveragePaymentAmount: number;
    RevenuePerRoom: number;
    RoomsWithBookings: number;
    TotalPayments: number;
    TotalReservations: number;
    TotalRevenue: number;
  }[];
  revenue_per_room: {
    AverageBookingValue: number;
    PricePerHour: number;
    RevenuePerBooking: number;
    RoomId: string;
    RoomName: string;
    RoomType: string;
    TotalBookings: number;
    TotalRevenue: number;
  }[];
  revenue_trend: {
    AveragePaymentAmount: number;
    Month: string;
    MonthlyRevenue: number;
    PaymentCount: number;
    ReservationCount: number;
  }[];
  review_statistics: {
    AverageRating: number;
    FiveStarReviews: number;
    FourStarReviews: number;
    OneStarReviews: number;
    PositiveReviewPercentage: string;
    ThreeStarReviews: number;
    TotalReviews: number;
    TwoStarReviews: number;
  }[];
  reviews: IReview[];
  room_availability: {
    AvailableSeats: number;
    Capacity: number;
    Date: string;
    Hour: number;
    OccupancyRate: string;
    RoomId: string;
    RoomName: string;
    RoomStatus: string;
    RoomType: string;
  }[];
  room_statistics: {
    AvailableRooms: number;
    AveragePricePerHour: number;
    OccupiedRooms: number;
    TotalAvailableRooms: string;
    TotalCapacity: string;
    TotalRooms: number;
  }[];
  room_types_distribution: {
    AveragePrice: number;
    RoomCount: number;
    TotalCapacity: string;
    Type: string;
  }[];
  rooms: IRoom[];
  schedule: {
    Day: string;
    EndTime: string;
    StartTime: string;
  }[];
  staff: {
    Email: string;
    FName: string;
    Id: string;
    LName: string;
    Phone: string;
    StaffIcon: string;
    StaffType: string;
  }[];
  trends: {
    AverageBookingValue: number;
    AverageDuration: string;
    Bookings: number;
    Month: string;
    Revenue: number;
    UniqueCustomers: number;
  }[];
}