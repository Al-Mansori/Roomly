export interface IPlan {
  id: number;
  title: string;
  description: string;
  dailyPrice: number;
  monthPrice: number;
  yearPrice: number;
  allowedFeatures: string[];
  deniedFeatures: string[];
}

export interface IPlanData {
  dailyPrice: number;
  monthPrice: number;
  yearPrice: number;
}