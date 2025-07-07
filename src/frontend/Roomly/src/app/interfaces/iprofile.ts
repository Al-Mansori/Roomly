export interface Iprofile {
 
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  type: 'DEFAULT' | 'ADMIN' | 'WORKER' | 'MANGER';
  password?: string;

}
