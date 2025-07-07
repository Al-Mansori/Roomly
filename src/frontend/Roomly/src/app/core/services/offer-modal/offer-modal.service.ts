import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';

@Injectable({
  providedIn: 'root'
})
export class OfferModalService {

  constructor() { }
    private modalState = new BehaviorSubject<{ mode: 'add' | 'edit' | 'reapply'; offer: IOffer | null; roomId: string | null }>({
    mode: 'add',
    offer: null,
    roomId: null
  });
  modalState$ = this.modalState.asObservable();

  private offerUpdated = new BehaviorSubject<IOffer | null>(null);
  offerUpdated$ = this.offerUpdated.asObservable();

  openModal(mode: 'add' | 'edit' | 'reapply', offer: IOffer | null, roomId: string | null): void {
    this.modalState.next({ mode, offer, roomId });
  }

  notifyOfferUpdated(offer: IOffer): void {
    this.offerUpdated.next(offer);
  }
}
