// export interface IReservation {
//   id: string;
//   reservationDate: string;
//   startTime: string;
//   endTime: string;
//   status: string;
//   amenitiesCount: number;
//   totalCost: number;
//   payment: string | null;
//   reservationType: string;
//   accessCode: string;
// }
export interface IReservation {
  id: string;
  reservationDate: string;
  startTime: string;
  endTime: string;
  status: string;
  amenitiesCount: number;
  totalCost: number;
  payment: {
    id: string;
    paymentMethod: string;
    paymentDate: string;
    amount: number;
    status: string;
  };
  reservationType: string;
  accessCode: string;
}