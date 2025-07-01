import { Component, inject, PLATFORM_ID } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { NgChartsModule } from 'ng2-charts';
import { isPlatformBrowser } from '@angular/common';
import { ChartConfiguration, ChartType, ChartOptions,
  ChartData } from 'chart.js';



@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [SideNavbarComponent, NgChartsModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent {

  isBrowser = isPlatformBrowser(inject(PLATFORM_ID));

  // ✅ Chart Types as string literals
  pieChartType: 'pie' = 'pie';
  barChartType: 'bar' = 'bar';
  lineChartType: 'line' = 'line';

  pieChartOptions: ChartOptions<'pie'> = {
    responsive: true,
    plugins: { legend: { position: 'bottom' } }
  };

  pieChartData: ChartData<'pie'> = {
    labels: ['Confirmed', 'Declined', 'Canceled', 'Expired'],
    datasets: [
      {
        data: [15800, 500, 1000, 200],
        backgroundColor: ['#007bff', '#dc3545', '#ffc107', '#17a2b8'],
      }
    ]
  };

  barChartOptions: ChartOptions<'bar'> = {
    responsive: true,
    plugins: { legend: { display: false } }
  };

  barChartData: ChartData<'bar'> = {
    labels: ['9 AM', '12 PM', '3 PM', '6 PM', '9 PM'],
    datasets: [
      {
        label: 'Peak Bookings',
        data: [10, 35, 50, 20, 15],
        backgroundColor: '#007bff',
      }
    ]
  };

  lineChartOptions: ChartOptions<'line'> = {
    responsive: true,
    plugins: { legend: { display: false } }
  };

  lineChartData: ChartData<'line'> = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
    datasets: [
      {
        label: 'Reservations',
        data: [65, 59, 80, 81, 56],
        borderColor: '#28a745',
        backgroundColor: 'rgba(40, 167, 69, 0.2)',
        fill: true
      }
    ]
  };
}
