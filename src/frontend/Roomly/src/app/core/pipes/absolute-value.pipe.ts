import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'abs',
  standalone: true
})
export class AbsoluteValuePipe implements PipeTransform {

  transform(value: number): number {
    return Math.abs(value);
  }

}
