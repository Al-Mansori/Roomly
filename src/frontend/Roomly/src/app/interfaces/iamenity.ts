export interface IAmenityResponse {
  amenityId: string;
  message: string;
  roomId: string;
  success?: boolean;  // Optional based on your API
}

export interface IAmenity {
  name: string;
  type: string;
  description: string;
  totalCount: number;
  roomId: string;
  imageUrls: string[];
  staffId: string;
}

export interface IExtendedAmenity extends IAmenity {
  id?: string; // For update-amenity and getAmenityById
  availableCount?: number; // For form, not sent to APIs
}