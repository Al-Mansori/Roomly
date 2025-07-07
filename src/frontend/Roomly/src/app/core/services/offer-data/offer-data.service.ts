import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';

@Injectable({
  providedIn: 'root'
})
export class OfferDataService {

  constructor() { }
  private offersSubject = new BehaviorSubject<IOffer[]>([]);
  offers$ = this.offersSubject.asObservable();

  setOffers(offers: IOffer[]): void {
    this.offersSubject.next(offers);
  }
}
