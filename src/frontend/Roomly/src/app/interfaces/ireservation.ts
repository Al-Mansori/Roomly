export interface IReservation {
  id: string;
  reservationDate: string;
  startTime: string;
  endTime: string;
  status: string;
  amenitiesCount: number;
  totalCost: number;
  payment: string | null;
  reservationType: string;
  accessCode: string;
}