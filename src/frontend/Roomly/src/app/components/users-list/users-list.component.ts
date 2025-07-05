import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { FormsModule } from '@angular/forms';
import { ICustomer } from '../../interfaces/icustomer';
import Swal from 'sweetalert2';
import { CustomerService } from '../../core/services/customer/customer.service';
import { switchMap } from 'rxjs';

export interface User {
  id: number;
  name: string;
  email: string;
  phone: string;
  avatar: string;
}

@Component({
  selector: 'app-users-list',
  standalone: true,
  imports: [SideNavbarComponent, FormsModule],
  templateUrl: './users-list.component.html',
  styleUrl: './users-list.component.scss'
})
export class UsersListComponent {

  users: ICustomer[] = [];
  filteredUsers: ICustomer[] = [];
  perPage = 10;
  page = 1;
  staffId: string | null = null;
  searchTerm: string = '';
  filterStatus: 'all' | 'blocked' | 'unblocked' = 'all';
  selectedUser: ICustomer | null = null;
  isLoading = false;



  // get totalPages(): number {
  //   return Math.ceil(this.users.length / this.perPage);
  // }

  // get pageStart(): number {
  //   return (this.page - 1) * this.perPage;
  // }

  // get pageEnd(): number {
  //   return Math.min(this.pageStart + this.perPage, this.users.length);
  // }

  // get paginatedUsers(): User[] {
  //   return this.users.slice(this.pageStart, this.pageEnd);
  // }
  get totalPages(): number {
    return Math.ceil(this.filteredUsers.length / this.perPage);
  }

  get pageStart(): number {
    return (this.page - 1) * this.perPage;
  }

  get pageEnd(): number {
    return Math.min(this.pageStart + this.perPage, this.filteredUsers.length);
  }

  get paginatedUsers(): ICustomer[] {
    return this.filteredUsers.slice(this.pageStart, this.pageEnd);
  }


  constructor(private customerService: CustomerService) { }



  // ngOnInit(): void {
  //   this.loadStaffId();
  //   if (this.staffId) {
  //     this.loadUsers();
  //     this.loadBlockedUsers();
  //   }
  // }
  ngOnInit(): void {
    this.loadStaffId();
    if (this.staffId) {
      this.loadUsersAndBlocked();
    }
  }

  loadStaffId(): void {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    this.staffId = user?.id || null;
    if (!this.staffId) {
      console.error('No staffId found, user not authenticated');
    }
  }

  loadUsersAndBlocked(): void {
    if (!this.staffId) {
      console.error('No staffId found');
      return;
    }

    // Load users first
    this.customerService.getUsersByStaff(this.staffId).subscribe({
      next: (data: ICustomer[]) => {
        this.users = data; // Load users without assuming blocked status
        this.loadBlockedStatuses(); // Then apply blocked statuses
      },
      error: (err) => {
        console.error('Error loading users:', err);
      }
    });
  }
  loadBlockedStatuses(): void {
    if (!this.staffId) {
      console.error('No staffId found');
      return;
    }

    this.customerService.getBlockedUsers(this.staffId).subscribe({
      next: (blockedIds: string[]) => {
        this.users = this.users.map(user => ({
          ...user,
          blocked: blockedIds.includes(user.id)
        }));
        this.applyFilters();
      },
      error: (err) => {
        console.error('Error loading blocked users:', err);
      }
    });
  }

  loadData(): void {
    this.isLoading = true;
    this.customerService.getBlockedUsers(this.staffId!).pipe(
      switchMap(() => this.customerService.getUsersByStaff(this.staffId!))
    ).subscribe({
      next: (users) => {
        this.users = users;
        this.applyFilters();
        this.isLoading = false;
      },
      error: (err) => {
        console.error('Error loading data:', err);
        this.isLoading = false;
      }
    });
  }




  loadUsers(): void {
    if (!this.staffId) {
      console.error('No staffId found');
      return;
    }
    this.customerService.getUsersByStaff(this.staffId).subscribe({
      next: (data: ICustomer[]) => {
        this.users = data.map(user => ({ ...user, blocked: false })); // Initialize as unblocked
        this.applyFilters();
      },
      error: (err) => {
        console.error('Error loading users:', err);
      }
    });
  }

  loadBlockedUsers(): void {
    if (!this.staffId) {
      console.error('No staffId found');
      return;
    }
    this.customerService.getBlockedUsers(this.staffId).subscribe({
      next: (blockedIds: string[]) => {
        this.users = this.users.map(user => ({
          ...user,
          blocked: blockedIds.includes(user.id)
        }));
        this.applyFilters();
      },
      error: (err) => {
        console.error('Error loading blocked users:', err);
      }
    });
  }


  blockUser(userId: string): void {
    if (!this.staffId) {
      console.error('No staffId found');
      return;
    }
    Swal.fire({
      title: 'Are you sure?',
      text: 'This will block the user from accessing the platform',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes, block!',
      cancelButtonText: 'Cancel'
    }).then((result) => {
      if (result.isConfirmed) {
        this.customerService.blockUser(this.staffId!, userId).subscribe({
          next: (response) => {
            console.log(response);
            this.loadUsersAndBlocked(); // Refresh both users and blocked statuses
            Swal.fire('Success!', response, 'success');
          },
          error: (err) => {
            console.error('Error blocking user:', err);
            Swal.fire('Error!', err.message || 'Failed to block user.', 'error');
          }
        });
      }
    });
  }
  unblockUser(userId: string): void {
    if (!this.staffId) {
      console.error('No staffId found');
      return;
    }
    Swal.fire({
      title: 'Are you sure?',
      text: 'This will restore the user\'s access to the platform',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes, unblock!',
      cancelButtonText: 'Cancel'
    }).then((result) => {
      if (result.isConfirmed) {
        this.customerService.unblockUser(this.staffId!, userId).subscribe({
          next: (response) => {
            console.log(response);
            this.loadUsersAndBlocked(); // Refresh both users and blocked statuses
            Swal.fire('Success!', response, 'success');
          },
          error: (err) => {
            console.error('Error unblocking user:', err);
            Swal.fire('Error!', err.message || 'Failed to unblock user.', 'error');
          }
        });
      }
    });
  }

  // toggleUserDetails(user: User): void {
  //   this.selectedUser = this.selectedUser?.id === user.id ? null : user;
  // }
  applyFilters(): void {
    let filtered = [...this.users];
    if (this.searchTerm) {
      filtered = filtered.filter(user =>
        user.firstName.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
        user.lastName.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
        user.email.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
        user.phone.includes(this.searchTerm)
      );
    }
    if (this.filterStatus === 'blocked') {
      filtered = filtered.filter(user => user.blocked);
    } else if (this.filterStatus === 'unblocked') {
      filtered = filtered.filter(user => !user.blocked);
    }
    this.filteredUsers = filtered;
    this.page = 1; // Reset to first page on filter change
  }

  selectUser(user: ICustomer): void {
    this.selectedUser = this.selectedUser?.id === user.id ? null : user;
  }


  // onSearchChange(event: Event): void {
  //   this.searchTerm = (event.target as HTMLInputElement).value;
  //   this.applyFilters();
  // }

  // onFilterChange(event: Event): void {
  //   this.filterStatus = (event.target as HTMLSelectElement).value as 'all' | 'blocked' | 'unblocked';
  //   this.applyFilters();
  // }
  nextPage(): void {
    if (this.page < this.totalPages) this.page++;
  }

  prevPage(): void {
    if (this.page > 1) this.page--;
  }

  updatePagination(): void {
    this.page = 1;
  }

  onSearchChange(event: Event): void {
    this.searchTerm = (event.target as HTMLInputElement).value;
    this.applyFilters();
  }

  onFilterChange(event: Event): void {
    this.filterStatus = (event.target as HTMLSelectElement).value as 'all' | 'blocked' | 'unblocked';
    this.applyFilters();
  }

}
