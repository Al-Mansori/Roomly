import { IOffer, IReview, IRoom } from "./iworkspace";

// Extended interfaces for API compatibility
export interface IExtendedOffer extends IOffer {
  DiscountedPrice?: number | null;
  OriginalPrice?: number | null;
  OfferId?: string;
  OfferStatus?: string;
  RoomName?: string;
  RoomType?: string;
}


export interface IExtendedReview extends IReview {
  Email?: string;
  FName?: string;
  LName?: string;
  RatingStars?: string;
}

export interface IExtendedRoom extends IRoom {
  StatusIcon?: string;
}

export interface IRoomAnalytics extends IRoom {
  AvailableCount?: number | null;
  BookingCount?: number | null;
  TotalRevenue?: number | null;
  Capacity?: number | null;
  Description?: string;
  PricePerHour?: number | null;
  RoomStatus?: string;
  WorkspaceId?: string;
}
export interface IWorkspaceAnalysis {
  amenities?: {
    Description?: string;
    Id?: string;
    Name?: string;
    RoomId?: string;
    RoomName?: string;
    RoomType?: string;
    TotalCount?: number | null;
    Type?: string;
  }[];
  amenities_distribution?: {
    AmenityCount?: number | null;
    AverageItemsPerAmenity?: string;
    RoomsWithThisAmenity?: number | null;
    TotalItems?: string;
    Type?: string;
  }[];
  analytics?: {
    AverageRating?: number | null;
    Date?: string;
    TotalBookings?: number | null;
    TotalRevenue?: number | null;
    UsagePatterns?: string;
    WorkspaceId?: string;
    WorkspaceName?: string;
  }[];
  basic_info?: {
    AvgRating?: number | null;
    City?: string;
    Country?: string;
    CreatedDate?: string;
    DailyPrice?: number | null;
    Id?: string;
    Latitude?: number | null;
    Longitude?: number | null;
    MonthPrice?: number | null;
    Name?: string;
    PaymentType?: string;
    Town?: string;
    Type?: string;
    YearPrice?: number | null;
  }[];
  customers?: {
    AverageBookingValue?: number | null;
    AverageDuration?: string;
    Email?: string;
    FName?: string;
    FirstBooking?: string;
    LName?: string;
    LastBooking?: string;
    TotalBookings?: number | null;
    TotalSpent?: number | null;
    UserId?: string;
  }[];
  insights_summary?: {
    kpis?: {
      ActiveOffers?: number | null;
      AvailableRooms?: number | null;
      AverageRating?: number | null;
      AverageRoomPrice?: number | null;
      MonthlyRevenue?: number | null;
      StaffCount?: number | null;
      TotalAmenities?: number | null;
      TotalReservations?: number | null;
      TotalRevenue?: number | null;
      TotalRooms?: number | null;
    };
    performance?: {
      AverageBookingDuration?: string;
      AverageBookingValue?: number | null;
      AverageOccupancyRate?: string;
      MonthlyBookings?: number | null;
      MonthlyRevenue?: number | null;
      MonthlyUniqueCustomers?: number | null;
    };
    top_customers?: {
      AverageBookingValue?: number | null;
      AverageDuration?: string;
      Email?: string;
      FName?: string;
      FirstBooking?: string;
      LName?: string;
      LastBooking?: string;
      TotalBookings?: number | null;
      TotalSpent?: number | null;
      UserId?: string;
    }[];
    trends?: {
      AverageBookingValue?: number | null;
      AverageDuration?: string;
      Bookings?: number | null;
      Month?: string;
      Revenue?: number | null;
      UniqueCustomers?: number | null;
    }[];
  };
  kpis?: {
    ActiveOffers?: number | null;
    AvailableRooms?: number | null;
    AverageRating?: number | null;
    AverageRoomPrice?: number | null;
    MonthlyRevenue?: number | null;
    StaffCount?: number | null;
    TotalAmenities?: number | null;
    TotalReservations?: number | null;
    TotalRevenue?: number | null;
    TotalRooms?: number | null;
  }[];
  occupancy_heatmap?: {
    AvailableSeats?: number | null;
    Capacity?: number | null;
    Date?: string;
    Hour?: number | null;
    OccupancyLevel?: string;
    OccupancyRate?: string;
    OccupiedSeats?: number | null;
    RoomName?: string;
  }[];
  offers?: IExtendedOffer[];
  performance_metrics?: {
    AverageBookingDuration?: string;
    AverageBookingValue?: number | null;
    AverageOccupancyRate?: string;
    MonthlyBookings?: number | null;
    MonthlyRevenue?: number | null;
    MonthlyUniqueCustomers?: number | null;
  }[];
  popular_booking_times?: {
    AverageBookingValue?: number | null;
    AverageDuration?: string;
    BookingCount?: number | null;
    HourOfDay?: number | null;
  }[];
  popular_rooms?: IRoomAnalytics[];
  reservation_kpis?: {
    AverageBookingValue?: number | null;
    AverageDurationHours?: string;
    CancelledReservations?: number | null;
    CompletedReservations?: number | null;
    CompletionRate?: string;
    ConfirmedReservations?: number | null;
    RoomsBooked?: number | null;
    TotalReservations?: number | null;
    UniqueCustomers?: number | null;
  }[];
  reservations?: {
    AccessCode?: string;
    BookingDate?: string;
    DurationHours?: number | null;
    Email?: string;
    EndTime?: string;
    FName?: string;
    LName?: string;
    ReservationId?: string;
    ReservationStatus?: string;
    ReservationType?: string;
    RoomName?: string;
    RoomType?: string;
    StartTime?: string;
    TotalCost?: number | null;
  }[];
  revenue_analysis?: {
    AveragePaymentAmount?: number | null;
    RevenuePerRoom?: number | null;
    RoomsWithBookings?: number | null;
    TotalPayments?: number | null;
    TotalReservations?: number | null;
    TotalRevenue?: number | null;
    PaymentMethods?: { method?: string; amount?: number | null }[];
  }[];
  revenue_per_room?: {
    AverageBookingValue?: number | null;
    PricePerHour?: number | null;
    RevenuePerBooking?: number | null;
    RoomId?: string;
    RoomName?: string;
    RoomType?: string;
    TotalBookings?: number | null;
    TotalRevenue?: number | null;
  }[];
  revenue_trend?: {
    AveragePaymentAmount?: number | null;
    Month?: string;
    MonthlyRevenue?: number | null;
    PaymentCount?: number | null;
    ReservationCount?: number | null;
  }[];
  review_statistics?: {
    AverageRating?: number | null;
    FiveStarReviews?: number | null;
    FourStarReviews?: number | null;
    OneStarReviews?: number | null;
    PositiveReviewPercentage?: string;
    ThreeStarReviews?: number | null;
    TotalReviews?: number | null;
    TwoStarReviews?: number | null;
  }[];
  reviews?: IExtendedReview[];
  room_availability?: {
    AvailableSeats?: number | null;
    Capacity?: number | null;
    Date?: string;
    Hour?: number | null;
    OccupancyRate?: string;
    RoomId?: string;
    RoomName?: string;
    RoomStatus?: string;
    RoomType?: string;
  }[];
  room_statistics?: {
    AvailableRooms?: number | null;
    AveragePricePerHour?: number | null;
    OccupiedRooms?: number | null;
    TotalAvailableRooms?: string;
    TotalCapacity?: string;
    TotalRooms?: number | null;
  }[];
  room_types_distribution?: {
    AveragePrice?: number | null;
    RoomCount?: number | null;
    TotalCapacity?: string;
    Type?: string;
  }[];
  rooms?: IExtendedRoom[];
  schedule?: {
    Day?: string;
    EndTime?: string;
    StartTime?: string;
  }[];
  staff?: {
    Email?: string;
    FName?: string;
    Id?: string;
    LName?: string;
    Phone?: string;
    StaffIcon?: string;
    StaffType?: string;
  }[];
  trends?: {
    AverageBookingValue?: number | null;
    AverageDuration?: string;
    Bookings?: number | null;
    Month?: string;
    Revenue?: number | null;
    UniqueCustomers?: number | null;
  }[];
}

export interface IDashboardInsight {
  averageAmenityUsage: number;
  maxOccupancyRate: string;
  reviewSentimentScore: number;
  totalCustomerValue: number;
  peakOccupancyHour: number;
  revenuePerRoomType: { type: string; revenue: number }[];
  topAmenities: { name: string; usage: number }[];
  customerRetentionRate: number;
  bookingCancellationRate: number;
}
// export interface IReservationAnalytics {
//   AccessCode: string;
//   BookingDate: string;
//   DurationHours: number;
//   Email: string;
//   EndTime: string;
//   FName: string;
//   LName: string;
//   ReservationId: string;
//   ReservationStatus: string;
//   ReservationType: string;
//   RoomName: string;
//   RoomType: string;
//   StartTime: string;
//   TotalCost: number;
// }

// export interface IRevenueTrend {
//   AveragePaymentAmount: number;
//   Month: string;
//   MonthlyRevenue: number;
//   PaymentCount: number;
//   ReservationCount: number;
// }
export interface IReservationAnalytics {
  AccessCode?: string;
  BookingDate?: string;
  DurationHours?: number | null;
  Email?: string;
  EndTime?: string;
  FName?: string;
  LName?: string;
  ReservationId?: string;
  ReservationStatus?: string;
  ReservationType?: string;
  RoomName?: string;
  RoomType?: string;
  StartTime?: string;
  TotalCost?: number | null;
}

export interface IRevenueTrend {
  AveragePaymentAmount?: number | null;
  Month?: string;
  MonthlyRevenue?: number | null;
  PaymentCount?: number | null;
  ReservationCount?: number | null;
}
export interface KPI {
  title: string;
  value: number;
  icon: string;
  color: string;
  format: 'number' | 'currency';
}

export interface IWorkspaceAnalysisResponse {
  data?: { analysis?: IWorkspaceAnalysis };
}