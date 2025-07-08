import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'app-upload-image',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './upload-image.component.html',
  styleUrls: ['./upload-image.component.scss']
})
export class UploadImageComponent {
  @Input() initialImages: string[] = [];
  @Output() imagesChange = new EventEmitter<string[]>();

  images: string[] = [];
  tempImages: string[] = [];
  currentImageIndex: number = 0;
  isEditing: boolean = false;
  isLoading: boolean = false;

  ngOnInit() {
    if (this.initialImages && this.initialImages.length > 0) {
      this.images = [...this.initialImages];
      this.tempImages = [...this.initialImages];
    }
  }

  async onFileSelected(event: any): Promise<void> {
    const files: FileList = event.target.files;
    if (!files || files.length === 0) return;

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      
      if (!file.type.match(/image\/(jpeg|png|gif)/)) {
        alert('Only JPEG, PNG, GIF images are allowed');
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        alert('File size too large (max 5MB)');
        return;
      }

      try {
        this.isLoading = true;
        const previewUrl = await this.readFileAsDataURL(file);
        this.tempImages.push(previewUrl);
        
        const cloudinaryUrl = await this.uploadImageToCloudinary(file);
        this.images.push(cloudinaryUrl);
        this.imagesChange.emit([...this.images]);
      } catch (error) {
        console.error('Upload error:', error);
        this.tempImages.pop();
        alert('Failed to upload image. Please try again.');
      } finally {
        this.isLoading = false;
      }
    }
  }

  private readFileAsDataURL(file: File): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (e: any) => resolve(e.target.result);
      reader.onerror = reject;
      reader.readAsDataURL(file);
    });
  }

  private async uploadImageToCloudinary(file: File): Promise<string> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('upload_preset', 'unsigned_preset');
    
    const cloudName = 'dz2mzzcg4';
    const apiUrl = `https://api.cloudinary.com/v1_1/${cloudName}/upload`;

    const response = await fetch(apiUrl, {
      method: 'POST',
      body: formData
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.message || 'Failed to upload image');
    }

    const result = await response.json();
    if (!result.secure_url) {
      throw new Error('Invalid response from Cloudinary');
    }

    return result.secure_url;
  }

  removeImage(index: number): void {
    if (index >= 0 && index < this.images.length) {
      this.images.splice(index, 1);
      this.tempImages.splice(index, 1);
      this.currentImageIndex = Math.max(0, Math.min(this.currentImageIndex, this.images.length - 1));
      this.imagesChange.emit([...this.images]);
    }
  }

  startEditing(): void {
    this.isEditing = true;
  }

  saveChanges(): void {
    this.isEditing = false;
    this.imagesChange.emit([...this.images]);
  }

  nextImage(): void {
    if (this.images.length > 0) {
      this.currentImageIndex = (this.currentImageIndex + 1) % this.images.length;
    }
  }

  prevImage(): void {
    if (this.images.length > 0) {
      this.currentImageIndex = (this.currentImageIndex - 1 + this.images.length) % this.images.length;
    }
  }
}