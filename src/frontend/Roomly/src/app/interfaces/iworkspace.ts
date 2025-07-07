export interface IWorkspace {
  id: string;
  name: string;
  description: string;
  address: string;
  location: {
    id: string;
    city: string | null;
    town: string | null;
    country: string | null;
    longitude: number;
    latitude: number;
  };
  creationDate: string;
  avgRating: number;
  type: string;
  rooms: IRoom[] | null;
  workspaceImages: string[] | null;
  reviews: IReview[] | null;
  paymentType: string;
}

export interface IRoom {
  imageUrls: never[];
  id: string;
  name: string;
  type: string;
  description: string;
  capacity: number;
  availableCount: number;
  pricePerHour: number;
  status: string;
  amenities: string[] | null;
  // roomImages: string[] | null;
  roomImages: { imageUrl: string }[] | null;

  offers: IOffer[] | null;
}


export interface IReview {
  id: string;
  rating: number;
  comment: string;
  reviewDate: string;
  userId: string;
  comments: string;
}

export interface IOffer {
  id?: string;
  offerTitle: string;
  description: string;
  discountPercentage: number;
  validFrom: string;
  validTo: string;
  // status: string;
  status: 'Active' | 'Inactive';

}