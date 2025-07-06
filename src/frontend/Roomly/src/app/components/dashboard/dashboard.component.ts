import { Component, inject, OnDestroy, Pipe, PipeTransform, PLATFORM_ID } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { NgChartsModule } from 'ng2-charts';
import { CommonModule, DatePipe, DecimalPipe, isPlatformBrowser, PercentPipe, SlicePipe } from '@angular/common';
import {
  ChartConfiguration, ChartType, ChartOptions,
  ChartData
} from 'chart.js';
import { IOffer, IRoom, IWorkspace } from '../../interfaces/iworkspace';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { FormsModule } from '@angular/forms';
import { IDashboardInsight, IExtendedOffer, IExtendedReview, IReservationAnalytics, IRoomAnalytics, IWorkspaceAnalysis, KPI } from '../../interfaces/iworkspace-analysis';
import { RouterModule } from '@angular/router';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { AbsoluteValuePipe } from '../../core/pipes/absolute-value.pipe';



@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [SideNavbarComponent, NgChartsModule, FormsModule, DatePipe,
    PercentPipe, DecimalPipe, RouterModule, NgxSkeletonLoaderModule, CommonModule, AbsoluteValuePipe],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent {
  isBrowser = isPlatformBrowser(inject(PLATFORM_ID));
  workspaces: IWorkspace[] = [];
  selectedWorkspaceId: string | null = null;
  isLoading = false;
  errorMessage: string | null = null;
  dashboardInsight: IDashboardInsight = {
    averageAmenityUsage: 0,
    maxOccupancyRate: '0%',
    reviewSentimentScore: 0,
    totalCustomerValue: 0,
    peakOccupancyHour: 0,
    revenuePerRoomType: [],
    topAmenities: [],
    customerRetentionRate: 0,
    bookingCancellationRate: 0
  };
  analysisData: IWorkspaceAnalysis = {};
  heatmapMetaData: { rate: number; occupied: number; capacity: number }[] = [];

  // Chart Types
  readonly lineChartType: 'line' = 'line';
  readonly pieChartType: 'pie' = 'pie';
  readonly barChartType: 'bar' = 'bar';
  readonly heatmapChartType: 'bar' = 'bar';
  readonly doughnutChartType: 'doughnut' = 'doughnut';

  pieChartOptions: ChartOptions<'pie' | 'doughnut'> = {
    responsive: true, maintainAspectRatio: false,
    plugins: { legend: { position: 'bottom', labels: { padding: 20, usePointStyle: true } } }
  };

  barChartOptions: ChartOptions<'bar'> = {
    responsive: true, maintainAspectRatio: false,
    plugins: { legend: { display: false }, tooltip: { backgroundColor: 'rgba(0,0,0,0.8)', bodyFont: { size: 14 }, padding: 12 } },
    scales: { x: { grid: { display: false }, ticks: { maxRotation: 45, minRotation: 45 } }, y: { beginAtZero: true } }
  };

  lineChartOptions: ChartOptions<'line'> = {
    responsive: true, maintainAspectRatio: false,
    plugins: { legend: { display: true }, tooltip: { mode: 'index', intersect: false } },
    scales: { y: { beginAtZero: true, ticks: { precision: 0 } } },
    interaction: { intersect: false, mode: 'nearest' }
  };

  heatmapOptions: ChartOptions<'bar'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        callbacks: {
          label: (context) => {
            const index = context.dataIndex;
            const meta = this.heatmapMetaData[index] || { rate: 0, occupied: 0, capacity: 0 };
            return `Occupancy: ${meta.rate.toFixed(1)}% (${meta.occupied}/${meta.capacity})`;
          }
        }
      }
    },
    scales: {
      x: { stacked: true, title: { display: true, text: 'Time of Day' } },
      y: { stacked: true, title: { display: true, text: 'Occupancy Rate (%)' }, beginAtZero: true }
    }
  };

  roomStatusChartData: ChartData<'doughnut'> = { labels: [], datasets: [] };
  reviewsChartData: ChartData<'bar'> = { labels: [], datasets: [] };
  roomTypesChartData: ChartData<'bar'> = { labels: [], datasets: [] };
  paymentMethodChartData: ChartData<'pie'> = { labels: [], datasets: [] };
  bookingTrendsChartData: ChartData<'line'> = { labels: [], datasets: [] };
  revenueChartData: ChartData<'line'> = { labels: [], datasets: [] };
  amenitiesChartData: ChartData<'bar'> = { labels: [], datasets: [] };
  heatmapData: ChartData<'bar'> = { labels: [], datasets: [] };

  constructor(private workspaceService: WorkspaceService) { }

  ngOnInit(): void {
    this.loadStaffWorkspaces();
    if (this.isBrowser) {
      setInterval(() => {
        if (this.selectedWorkspaceId) {
          this.loadWorkspaceAnalysis(this.selectedWorkspaceId);
        }
      }, 5 * 60 * 1000);
    }
  }

  loadStaffWorkspaces(): void {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;

    if (!staffId) {
      this.errorMessage = 'User not authenticated. Please log in.';
      return;
    }

    this.isLoading = true;
    this.workspaceService.getWorkspacesByStaff(staffId).subscribe({
      next: (workspaces) => {
        this.workspaces = workspaces ?? [];
        if (workspaces?.length > 0) {
          this.selectedWorkspaceId = workspaces[0].id;
          this.loadWorkspaceAnalysis(workspaces[0].id);
        } else {
          this.errorMessage = 'No workspaces found for your account.';
        }
        this.isLoading = false;
      },
      error: (err) => {
        console.error('Error loading workspaces:', err);
        this.errorMessage = 'Failed to load workspaces. Please try again later.';
        this.isLoading = false;
      }
    });
  }

  loadWorkspaceAnalysis(workspaceId: string): void {
    this.isLoading = true;
    this.errorMessage = null;
    this.workspaceService.getWorkspaceAnalysis(workspaceId).subscribe({
      next: (response) => {
        this.analysisData = response.data?.analysis ?? {};
        localStorage.setItem(`analysis_${workspaceId}`, JSON.stringify(this.analysisData));
        this.calculateDashboardInsights();
        this.updateCharts();
        this.isLoading = false;
      },
      error: (err) => {
        console.error('Error loading analysis:', err);
        this.errorMessage = 'Failed to load workspace analysis. Using cached data if available.';
        const cachedData = localStorage.getItem(`analysis_${workspaceId}`);
        if (cachedData) {
          this.analysisData = JSON.parse(cachedData);
          this.calculateDashboardInsights();
          this.updateCharts();
        }
        this.isLoading = false;
      }
    });
  }

  private calculateDashboardInsights(): void {
    const amenities = this.analysisData.amenities_distribution ?? [];
    const occupancy = this.analysisData.occupancy_heatmap ?? [];
    const customers = this.analysisData.customers ?? [];
    const revenuePerRoom = this.analysisData.revenue_per_room ?? [];
    const popularTimes = this.analysisData.popular_booking_times ?? [];

    const peakHourData = popularTimes.reduce(
      (prev, current) => (prev.BookingCount ?? 0) > (current.BookingCount ?? 0) ? prev : current,
      { HourOfDay: 0, BookingCount: 0 }
    );

    this.dashboardInsight = {
      averageAmenityUsage: amenities.length
        ? amenities.reduce((sum, a) => sum + (parseFloat(a.AverageItemsPerAmenity ?? '0') || 0), 0) / amenities.length
        : 0,
      maxOccupancyRate: occupancy.length
        ? `${Math.max(...occupancy.map(o => parseFloat(o.OccupancyRate ?? '0') || 0), 0).toFixed(1)}%`
        : '0%',
      reviewSentimentScore: this.analysisData.review_statistics?.[0]?.AverageRating ?? 0,
      totalCustomerValue: customers.reduce((sum, c) => sum + (isNaN(c.TotalSpent ?? 0) ? 0 : c.TotalSpent ?? 0), 0),
      peakOccupancyHour: peakHourData.HourOfDay ?? 0,
      revenuePerRoomType: (this.analysisData.room_types_distribution ?? []).map(type => ({
        type: type.Type ?? 'Unknown',
        revenue: revenuePerRoom
          .filter(r => r.RoomType === type.Type)
          .reduce((sum, r) => sum + (isNaN(r.TotalRevenue ?? 0) ? 0 : r.TotalRevenue ?? 0), 0)
      })),
      topAmenities: amenities
        .map(a => ({ name: a.Type ?? 'Unknown', usage: parseFloat(a.AverageItemsPerAmenity ?? '0') || 0 }))
        .sort((a, b) => b.usage - a.usage)
        .slice(0, 3),
      customerRetentionRate: customers.length
        ? customers.filter(c => (c.TotalBookings ?? 0) > 1).length / customers.length
        : 0,
      bookingCancellationRate: this.analysisData.reservation_kpis?.[0]?.TotalReservations
        ? (this.analysisData.reservation_kpis[0].CancelledReservations ?? 0) /
        (this.analysisData.reservation_kpis[0].TotalReservations ?? 1)
        : 0
    };
  }

  onWorkspaceChange(): void {
    if (this.selectedWorkspaceId) {
      this.loadWorkspaceAnalysis(this.selectedWorkspaceId);
    }
  }

  private updateCharts(): void {
    // Room Status Overview Donut Chart
    const roomStats = this.analysisData.room_statistics?.[0];
    this.roomStatusChartData = {
      labels: ['Available', 'Occupied', 'Total'],
      datasets: [{
        data: [
          parseInt(roomStats?.TotalAvailableRooms ?? '0') || 0,
          roomStats?.OccupiedRooms ?? 0,
          roomStats?.TotalRooms ?? 0
        ],
        backgroundColor: ['#28a745', '#dc3545', '#6c757d'],
        borderColor: ['#ffffff', '#ffffff', '#ffffff'],
        borderWidth: 2
      }]
    };

    // Customer Reviews Distribution Chart
    const reviewStats = this.analysisData.review_statistics?.[0];
    this.reviewsChartData = {
      labels: ['1 Star', '2 Stars', '3 Stars', '4 Stars', '5 Stars'],
      datasets: [{
        label: 'Reviews',
        data: [
          reviewStats?.OneStarReviews ?? 0,
          reviewStats?.TwoStarReviews ?? 0,
          reviewStats?.ThreeStarReviews ?? 0,
          reviewStats?.FourStarReviews ?? 0,
          reviewStats?.FiveStarReviews ?? 0
        ],
        backgroundColor: ['#dc3545', '#ff6f00', '#ffc107', '#17a2b8', '#28a745'],
        borderRadius: 4
      }]
    };

    // Room Types Distribution Chart
    this.roomTypesChartData = {
      labels: (this.analysisData.room_types_distribution ?? []).map(t => t.Type ?? 'Unknown'),
      datasets: [{
        label: 'Room Count',
        data: (this.analysisData.room_types_distribution ?? []).map(t => t.RoomCount ?? 0),
        backgroundColor: ['#007bff', '#28a745', '#dc3545', '#ffc107', '#17a2b8'],
        borderRadius: 4
      }]
    };

    // Payment Method Distribution Chart
    // const paymentMethods = this.analysisData.revenue_analysis?.[0]?.PaymentMethods ?? [];
    // this.paymentMethodChartData = {
    //   labels: paymentMethods.map(m => m.method ?? 'Unknown'),
    //   datasets: [{
    //     data: paymentMethods.map(m => m.amount ?? 0),
    //     backgroundColor: ['#007bff', '#28a745', '#dc3545', '#ffc107'],
    //     hoverOffset: 4
    //   }]
    // };
    // 1. Extract payment types from basic_info
    const paymentTypes = this.analysisData.basic_info?.map(info => info?.PaymentType ?? 'Unknown') ?? [];

    const methodCounts: { [method: string]: number } = {};
    for (const method of paymentTypes) {
      methodCounts[method] = (methodCounts[method] || 0) + 1;
    }

    const labels = Object.keys(methodCounts);
    const totalCount = Object.values(methodCounts).reduce((sum, count) => sum + count, 0);
    const totalRevenue = this.analysisData.revenue_analysis?.[0]?.TotalRevenue ?? 0;

    // 2. Distribute revenue proportionally
    const data = labels.map(method => {
      const methodShare = totalCount ? methodCounts[method] / totalCount : 0;
      return +(totalRevenue * methodShare).toFixed(2);
    });

    // 3. Set chart data
    this.paymentMethodChartData = {
      labels,
      datasets: [{
        data,
        backgroundColor: ['#007bff', '#28a745', '#dc3545', '#ffc107', '#6f42c1'], // Add more colors if needed
        hoverOffset: 4
      }]
    };

    // Booking Trends Multi-line Chart
    const sortedTrends = [...(this.analysisData.trends ?? [])].sort((a, b) => this.compareMonths(a?.Month, b?.Month));
    this.bookingTrendsChartData = {
      labels: sortedTrends.map(t => this.formatMonthLabel(t?.Month)),
      datasets: [
        {
          label: 'Bookings',
          data: sortedTrends.map(t => t.Bookings ?? 0),
          borderColor: '#007bff',
          backgroundColor: 'rgba(0, 123, 255, 0.2)',
          fill: true,
          tension: 0.4
        },
        {
          label: 'Revenue',
          data: sortedTrends.map(t => isNaN(t.Revenue ?? 0) ? 0 : t.Revenue ?? 0),
          borderColor: '#28a745',
          backgroundColor: 'rgba(40, 167, 69, 0.2)',
          fill: true,
          tension: 0.4
        },
        {
          label: 'Unique Customers',
          data: sortedTrends.map(t => t.UniqueCustomers ?? 0),
          borderColor: '#dc3545',
          backgroundColor: 'rgba(220, 53, 69, 0.2)',
          fill: true,
          tension: 0.4
        }
      ]
    };

    // Revenue Trend Chart
    const revenueTrend = [...(this.analysisData.revenue_trend ?? [])].sort((a, b) => this.compareMonths(a?.Month, b?.Month));
    this.revenueChartData = {
      labels: revenueTrend.map(t => this.formatMonthLabel(t?.Month)),
      datasets: [{
        label: 'Revenue ($)',
        data: revenueTrend.map(t => isNaN(t.MonthlyRevenue ?? 0) ? 0 : t.MonthlyRevenue ?? 0),
        borderColor: '#28a745',
        backgroundColor: 'rgba(40, 167, 69, 0.2)',
        fill: true,
        tension: 0.4,
        borderWidth: 2
      }]
    };

    // Amenities Distribution Chart
    this.amenitiesChartData = {
      labels: (this.analysisData.amenities_distribution ?? []).map(a => a.Type ?? 'Unknown'),
      datasets: [{
        label: 'Average Items Used',
        data: (this.analysisData.amenities_distribution ?? []).map(a => parseFloat(a.AverageItemsPerAmenity ?? '0') || 0),
        backgroundColor: '#007bff',
        borderRadius: 4
      }]
    };

    // Occupancy Heatmap
    const hourlyData: { [hour: number]: { total: number, count: number, occupied: number, capacity: number } } = {};
    (this.analysisData.occupancy_heatmap ?? []).forEach(item => {
      const hour = item.Hour ?? 0;
      if (!hourlyData[hour]) {
        hourlyData[hour] = { total: 0, count: 0, occupied: item.OccupiedSeats ?? 0, capacity: item.Capacity ?? 0 };
      }
      hourlyData[hour].total += parseFloat(item.OccupancyRate ?? '0') || 0;
      hourlyData[hour].count++;
      hourlyData[hour].occupied += item.OccupiedSeats ?? 0;
      hourlyData[hour].capacity += item.Capacity ?? 0;
    });
    const hours = Object.keys(hourlyData).map(Number).sort((a, b) => a - b);
    this.heatmapMetaData = hours.map(hour => ({
      rate: hourlyData[hour].count ? hourlyData[hour].total / hourlyData[hour].count : 0,
      occupied: hourlyData[hour].occupied,
      capacity: hourlyData[hour].capacity
    }));
    this.heatmapData = {
      labels: hours.map(h => `${h}:00`),
      datasets: [{
        label: 'Occupancy Rate',
        data: hours.map(hour => hourlyData[hour].count ? hourlyData[hour].total / hourlyData[hour].count : 0),
        backgroundColor: hours.map(hour => this.getHeatmapColor(hourlyData[hour].count ? hourlyData[hour].total / hourlyData[hour].count : 0)),
        borderColor: 'rgba(0,0,0,0.1)',
        borderWidth: 1
      }]
    };
  }

  getTopRooms(limit: number): IRoomAnalytics[] {
    return (this.analysisData.popular_rooms ?? [])
      .filter((room): room is IRoomAnalytics => !!room && !!room.id)
      .sort((a, b) => (b.BookingCount ?? 0) - (a.BookingCount ?? 0))
      .slice(0, limit);
  }

  getRoomRevenue(roomId: string): number {
    return this.analysisData.revenue_per_room?.find(r => r.RoomId === roomId)?.TotalRevenue ?? 0;
  }

  getRecentReservations(limit: number): IReservationAnalytics[] {
    return (this.analysisData.reservations ?? [])
      .filter((res): res is IReservationAnalytics => !!res && !!res.ReservationId)
      .sort((a, b) => new Date(b.BookingDate ?? '').getTime() - new Date(a.BookingDate ?? '').getTime())
      .slice(0, limit);
  }

  getRecentReviews(limit: number): IExtendedReview[] {
    return (this.analysisData.reviews ?? [])
      .filter((rev): rev is IExtendedReview => !!rev && !!rev.id)
      .sort((a, b) => new Date(b.reviewDate ?? '').getTime() - new Date(a.reviewDate ?? '').getTime())
      .slice(0, limit);
  }

  getActiveOffers(): IExtendedOffer[] {
    const now = new Date();
    return (this.analysisData.offers ?? [])
      .filter((offer): offer is IExtendedOffer => !!offer && !!offer.id)
      .filter(offer => {
        try {
          const from = new Date(offer.validFrom ?? '');
          const to = new Date(offer.validTo ?? '');
          return now >= from && now <= to && offer.status === 'Active';
        } catch {
          return false;
        }
      });
  }

  private compareMonths(a: string | undefined, b: string | undefined): number {
    try {
      const [aYear, aMonth] = (a ?? '').split('-').map(Number);
      const [bYear, bMonth] = (b ?? '').split('-').map(Number);
      return aYear - bYear || aMonth - bMonth;
    } catch {
      return 0;
    }
  }

  private formatMonthLabel(monthStr: string | undefined): string {
    try {
      const [year, month] = (monthStr ?? '').split('-').map(Number);
      return new Date(year, month - 1, 1).toLocaleDateString('default', { month: 'short', year: '2-digit' });
    } catch {
      return monthStr ?? '';
    }
  }

  private getHeatmapColor(value: number): string {
    // const normalizedValue = Math.min(Math.max(value, 0), 100);
    // const hue = ((100 - normalizedValue) * 120) / 100;
    // return `hsl(${hue}, 100%, 50%)`;onst normalizedValue = Math.min(Math.max(value, 0), 100) / 100;
    const normalizedValue = Math.min(Math.max(value, 0), 100) / 100;
    const r = Math.round(0 * (1 - normalizedValue) + 255 * normalizedValue); // 0 to 255
    const g = Math.round(128 * (1 - normalizedValue) + 0 * normalizedValue); // 128 to 0
    const b = Math.round(128 * (1 - normalizedValue) + 0 * normalizedValue); // 128 to 0
    return `rgb(${r}, ${g}, ${b})`;

  }

  getWorkspaceName(): string {
    return this.analysisData.basic_info?.[0]?.Name ?? 'Workspace Dashboard';
  }

  getWorkspaceLocation(): string {
    const town = this.analysisData.basic_info?.[0]?.Town ?? '';
    const city = this.analysisData.basic_info?.[0]?.City ?? '';
    return town && city ? `${town}, ${city}` : town || city || '';
  }

  hasRating(): boolean {
    return !!this.analysisData.kpis?.[0]?.AverageRating;
  }

  getAverageRating(): string {
    return (this.analysisData.kpis?.[0]?.AverageRating ?? 0).toFixed(1);
  }

  // getKPIs() {
  //   const kpis = this.analysisData.kpis?.[0] ?? {};
  //   return [
  //     {
  //       title: 'Total Rooms',
  //       value: kpis.TotalRooms ?? 0,
  //       icon: '🏢',
  //       color: 'blue',
  //       format: 'number'
  //     },
  //     {
  //       title: 'Total Revenue',
  //       value: isNaN(kpis.TotalRevenue ?? 0) ? 0 : kpis.TotalRevenue ?? 0,
  //       icon: '💰',
  //       color: 'green',
  //       format: 'currency'
  //     },
  //     {
  //       title: 'Monthly Revenue',
  //       value: isNaN(kpis.MonthlyRevenue ?? 0) ? 0 : kpis.MonthlyRevenue ?? 0,
  //       icon: '📈',
  //       color: 'orange',
  //       format: 'currency'
  //     },
  //     {
  //       title: 'Average Rating',
  //       value: isNaN(kpis.AverageRating ?? 0) ? '0.0' : (kpis.AverageRating ?? 0).toFixed(1),
  //       icon: '⭐',
  //       color: 'gold',
  //       format: 'number'
  //     },
  //     {
  //       title: 'Total Reservations',
  //       value: kpis.TotalReservations ?? 0,
  //       icon: '📅',
  //       color: 'purple',
  //       format: 'number'
  //     },
  //     {
  //       title: 'Active Offers',
  //       value: kpis.ActiveOffers ?? 0,
  //       icon: '🎁',
  //       color: 'red',
  //       format: 'number'
  //     }
  //   ];
  // }


  // grok version:
  // getKPIs(): KPI[] {
  //   const kpis = this.analysisData.kpis?.[0] ?? {};
  //   return [
  //     {
  //       title: 'Total Rooms',
  //       value: kpis.TotalRooms ?? 0,
  //       icon: '🏢',
  //       color: 'blue',
  //       format: 'number'
  //     },
  //     {
  //       title: 'Total Revenue',
  //       value: isNaN(kpis.TotalRevenue ?? 0) ? 0 : kpis.TotalRevenue ?? 0,
  //       icon: '💰',
  //       color: 'green',
  //       format: 'currency'
  //     },
  //     {
  //       title: 'Monthly Revenue',
  //       value: isNaN(kpis.MonthlyRevenue ?? 0) ? 0 : kpis.MonthlyRevenue ?? 0,
  //       icon: '📈',
  //       color: 'orange',
  //       format: 'currency'
  //     },
  //     {
  //       title: 'Average Rating',
  //       value: isNaN(kpis.AverageRating ?? 0) ? 0 : kpis.AverageRating ?? 0,
  //       icon: '⭐',
  //       color: 'gold',
  //       format: 'number'
  //     },
  //     {
  //       title: 'Total Reservations',
  //       value: kpis.TotalReservations ?? 0,
  //       icon: '📅',
  //       color: 'purple',
  //       format: 'number'
  //     },
  //     {
  //       title: 'Active Offers',
  //       value: kpis.ActiveOffers ?? 0,
  //       icon: '🎁',
  //       color: 'red',
  //       format: 'number'
  //     }
  //   ];
  // }

  // chatgpt version:
  getKPIs(): KPI[] {
    const kpis = this.analysisData.kpis?.[0] ?? {};
    return [
      {
        title: 'Total Rooms',
        value: kpis.TotalRooms ?? 0,
        icon: '🏢',
        color: 'blue',
        format: 'number'
      },
      {
        title: 'Total Revenue',
        value: isNaN(kpis.TotalRevenue ?? NaN) ? 0 : kpis.TotalRevenue ?? 0,
        icon: '💰',
        color: 'green',
        format: 'currency'
      },
      {
        title: 'Monthly Revenue',
        value: isNaN(kpis.MonthlyRevenue ?? NaN) ? 0 : kpis.MonthlyRevenue ?? 0,
        icon: '📈',
        color: 'orange',
        format: 'currency'
      },
      {
        title: 'Average Rating',
        value: isNaN(kpis.AverageRating ?? NaN) ? 0 : kpis.AverageRating ?? 0,
        icon: '⭐',
        color: 'gold',
        format: 'number' // this is now a number, not a string
      },
      {
        title: 'Total Reservations',
        value: kpis.TotalReservations ?? 0,
        icon: '📅',
        color: 'purple',
        format: 'number'
      },
      {
        title: 'Active Offers',
        value: kpis.ActiveOffers ?? 0,
        icon: '🎁',
        color: 'red',
        format: 'number'
      }
    ];
  }


  safeDate(dateString: string | undefined): Date | null {
    return dateString ? new Date(dateString) : null;
  }

  hasChartData(chartData: ChartData): boolean {
    return this.isBrowser && Array.isArray(chartData?.labels) && chartData.labels.length > 0;
  }

  parseAverageBookingDuration(): number {
    return parseFloat(this.analysisData.performance_metrics?.[0]?.AverageBookingDuration ?? '0') || 0;
  }
  isValueNaN(value: any): boolean {
    return isNaN(value);
  }
  getTotalRevenue(): number {
    const val = this.analysisData.revenue_analysis?.[0]?.TotalRevenue ?? 0;
    return isNaN(val) ? 0 : val;
  }
  getAveragePayment(): number {
    const val = this.analysisData.revenue_analysis?.[0]?.AveragePaymentAmount ?? 0;
    return isNaN(val) ? 0 : val;
  }
  getRevenuePerRoom(): number {
    const val = this.analysisData.revenue_analysis?.[0]?.RevenuePerRoom ?? 0;
    return isNaN(val) ? 0 : val
  }
}
interface HeatmapDataPoint {
  x: number;
  y: number;
  rate: number;
  occupied: number;
  capacity: number;
}

