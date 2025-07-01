import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { FormsModule } from '@angular/forms';

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

  users: User[] = [
    { id: 1, name: 'Otis Howe', email: 'Otis.Howe8@gmail.com', phone: '1-386-983-8257 x70632', avatar: 'https://i.pravatar.cc/100?img=1' },
    { id: 2, name: 'Marshall King', email: 'Marshall91@gmail.com', phone: '(335) 806-4574 x96978', avatar: 'https://i.pravatar.cc/100?img=2' },
    { id: 3, name: 'Ebony Wolf', email: 'Ebony.Wolf@gmail.com', phone: '1-587-448-0739 x4387', avatar: 'https://i.pravatar.cc/100?img=3' },
    { id: 4, name: 'Sheryl Ryan', email: 'Sheryl81@yahoo.com', phone: '1-544-894-1763 x0133', avatar: 'https://i.pravatar.cc/100?img=4' },
    { id: 5, name: 'Fredrick Littel', email: 'Fredrick_Littel79@hotmail.com', phone: '1-317-303-6444 x725', avatar: 'https://i.pravatar.cc/100?img=5' },
    { id: 6, name: 'Rosemary Romaguera', email: 'Rosemary_Romaguera45@yahoo.com', phone: '884.951.4788 x371', avatar: 'https://i.pravatar.cc/100?img=6' },
    { id: 7, name: 'Marta Carroll', email: 'Marta91@gmail.com', phone: '(497) 804-8026', avatar: 'https://i.pravatar.cc/100?img=7' },
    { id: 8, name: 'Patricia Effertz', email: 'Patricia_Effertz94@hotmail.com', phone: '1-771-508-5628', avatar: 'https://i.pravatar.cc/100?img=8' },
    { id: 9, name: 'Freddie Bogisich', email: 'Freddie.Bogisich32@hotmail.com', phone: '780.607.9605 x38708', avatar: 'https://i.pravatar.cc/100?img=9' },
    { id: 10, name: 'Victor Muller', email: 'Victor84@gmail.com', phone: '(834) 205-1073 x8791', avatar: 'https://i.pravatar.cc/100?img=10' },
  ];

  perPage = 10;
  page = 1;

  get totalPages(): number {
    return Math.ceil(this.users.length / this.perPage);
  }

  get pageStart(): number {
    return (this.page - 1) * this.perPage;
  }

  get pageEnd(): number {
    return Math.min(this.pageStart + this.perPage, this.users.length);
  }

  get paginatedUsers(): User[] {
    return this.users.slice(this.pageStart, this.pageEnd);
  }

  nextPage(): void {
    if (this.page < this.totalPages) this.page++;
  }

  prevPage(): void {
    if (this.page > 1) this.page--;
  }

  updatePagination(): void {
    this.page = 1;
  }

}
