import { Component, inject, PLATFORM_ID } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { NgChartsModule } from 'ng2-charts';
import { CommonModule, CurrencyPipe, isPlatformBrowser, SlicePipe } from '@angular/common';
import {
  ChartConfiguration, ChartType, ChartOptions,
  ChartData
} from 'chart.js';
import { IWorkspace } from '../../interfaces/iworkspace';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { FormsModule } from '@angular/forms';
import { IWorkspaceAnalysis } from '../../interfaces/iworkspace-analysis';



@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [SideNavbarComponent, NgChartsModule, FormsModule, CurrencyPipe, SlicePipe],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent {

  isBrowser = isPlatformBrowser(inject(PLATFORM_ID));
  workspaces: IWorkspace[] = [];
  selectedWorkspaceId: string | null = null;
  analysisData: IWorkspaceAnalysis | null = null;
  isLoading = false;
  error: string | null = null;

  // Chart Types
  pieChartType: 'pie' = 'pie';
  barChartType: 'bar' = 'bar';
  lineChartType: 'line' = 'line';

  // Chart Options
  pieChartOptions: ChartOptions<'pie'> = { responsive: true, plugins: { legend: { position: 'bottom' } } };
  barChartOptions: ChartOptions<'bar'> = { responsive: true, plugins: { legend: { display: false } } };
  lineChartOptions: ChartOptions<'line'> = { responsive: true, plugins: { legend: { display: false } } };

  // Chart Data
  pieChartData: ChartData<'pie'> = { labels: [], datasets: [] };
  barChartData: ChartData<'bar'> = { labels: [], datasets: [] };
  lineChartData: ChartData<'line'> = { labels: [], datasets: [] };

  constructor(private workspaceService: WorkspaceService) {}

  ngOnInit(): void {
    this.loadStaffWorkspaces();
  }

  loadStaffWorkspaces(): void {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) {
      this.error = 'User not authenticated';
      return;
    }

    this.isLoading = true;
    this.workspaceService.getWorkspacesByStaff(staffId).subscribe({
      next: (workspaces) => {
        this.workspaces = workspaces;
        if (workspaces.length > 0) {
          this.selectedWorkspaceId = workspaces[0].id;
          this.loadWorkspaceAnalysis();
        }
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to load workspaces';
        this.isLoading = false;
        console.error('Error loading workspaces:', err);
      }
    });
  }

  loadWorkspaceAnalysis(): void {
    if (!this.selectedWorkspaceId) {
      this.error = 'No workspace selected';
      return;
    }

    this.isLoading = true;
    this.workspaceService.getWorkspaceAnalysis(this.selectedWorkspaceId).subscribe({
      next: (response) => {
        this.analysisData = response.data.analysis;
        this.updateCharts();
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to load analysis data';
        this.isLoading = false;
        console.error('Error loading analysis:', err);
      }
    });
  }

  onWorkspaceChange(): void {
    this.loadWorkspaceAnalysis();
  }

  updateCharts(): void {
    if (!this.analysisData) return;

    // Booking Status Pie Chart
    if (this.analysisData.reservation_kpis?.[0]) {
      const kpis = this.analysisData.reservation_kpis[0];
      this.pieChartData = {
        labels: ['Completed', 'Cancelled', 'Confirmed'],
        datasets: [{ data: [kpis.CompletedReservations, kpis.CancelledReservations, kpis.ConfirmedReservations], backgroundColor: ['#28a745', '#dc3545', '#17a2b8'] }]
      };
    }

    // Peak Time Bar Chart
    if (this.analysisData.popular_booking_times) {
      const sortedTimes = [...this.analysisData.popular_booking_times].sort((a, b) => b.BookingCount - a.BookingCount).slice(0, 5);
      this.barChartData = {
        labels: sortedTimes.map(t => `${t.HourOfDay}:00`),
        datasets: [{ label: 'Bookings', data: sortedTimes.map(t => t.BookingCount), backgroundColor: '#007bff' }]
      };
    }

    // Reservation Over Time Line Chart
    if (this.analysisData.revenue_trend) {
      const sortedTrends = [...this.analysisData.revenue_trend].sort((a, b) => new Date(a.Month).getTime() - new Date(b.Month).getTime());
      this.lineChartData = {
        labels: sortedTrends.map(t => t.Month.split('-')[1]),
        datasets: [{ label: 'Reservations', data: sortedTrends.map(t => t.ReservationCount || 0), borderColor: '#28a745', backgroundColor: 'rgba(40, 167, 69, 0.2)', fill: true }]
      };
    }
  }
}
