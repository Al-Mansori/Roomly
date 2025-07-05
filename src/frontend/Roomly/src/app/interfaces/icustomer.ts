export interface ICustomer {
    type: string;
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    phone: string;
    address: string;
    id: string;
    blocked?: boolean; // Derived from blocked users API
}
