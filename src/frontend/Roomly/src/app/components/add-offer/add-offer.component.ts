import { Component } from '@angular/core';
import { MyWorkspacesComponent } from "../my-workspaces/my-workspaces.component";

@Component({
  selector: 'app-add-offer',
  standalone: true,
  imports: [MyWorkspacesComponent],
  templateUrl: './add-offer.component.html',
  styleUrl: './add-offer.component.scss'
})
export class AddOfferComponent {

}
