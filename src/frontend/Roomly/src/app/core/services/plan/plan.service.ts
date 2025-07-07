import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../environment/environments';
import { IPlanData } from '../../../interfaces/iplan';
@Injectable({
  providedIn: 'root'
})
export class PlanService {


  constructor(private http: HttpClient) { }

   baseUrl:string = environment.baseUrl;
  // Get plan for workspace
  // getPlan(selectedWorkspaceId: string): Observable<any> {
  //   return this.http.get(`${this.baseUrl}/staff/workspacePlan?workspaceId=${selectedWorkspaceId}`);
  // }  
  
    getPlanByStaff(staffId: string): Observable<IPlanData[]> {
    const url = `https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/staff-plans?staffId=${staffId}`;
    return this.http.get<IPlanData[]>(url);
  }
  // Create new plan
  createPlan(planData: { dailyPrice: number, monthPrice: number, yearPrice: number } , selectedWorkspaceId: string): Observable<any> {
    return this.http.post(`/api/staff/workspacePlan?workspaceId=${selectedWorkspaceId}`, planData);
  }

  // Update existing plan
  updatePlan(planData: { dailyPrice: number, monthPrice: number, yearPrice: number } ,selectedWorkspaceId: string): Observable<any> {
    return this.http.put(`/api/staff/workspacePlan?workspaceId=${selectedWorkspaceId}`, planData);
  }

  // Delete plan
  deletePlan(selectedWorkspaceId: string): Observable<any> {
    return this.http.delete(`/api/staff/workspacePlan?workspaceId=${selectedWorkspaceId}`);
  }

}
