// في ملف ishowworkspace.ts
export interface Ishowworkspace {
  phone: string;
  id: string;
  name: string;
  description: string;
  address: string;
  location: {
    city: string;
    town: string;
    country: string;
    longitude: number;
    latitude: number;
  };

  creationDate?: string;
  avgRating?: number;
  type: string;
  rooms?: any[];
  workspaceImages: string;
  reviews?: any[];
  paymentType: string;
  staffId?: string;
}