import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'app-upload-image',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './upload-image.component.html',
  styleUrl: './upload-image.component.scss'
})
export class UploadImageComponent {
      images: string[] = []; // روابط Cloudinary النهائية
  tempImages: string[] = []; // معاينات محلية مؤقتة
  currentImageIndex: number = 0;
  isEditing: boolean = false;
  isLoading: boolean = false; // مؤشر تحميل

  @Output() imagesChange = new EventEmitter<string[]>();

  async onFileSelected(event: any): Promise<void> {
    const file: File = event.target.files[0];
    
    if (!file) return;

    // التحقق من نوع الملف
    if (!file.type.match(/image\/(jpeg|png|gif)/)) {
      alert('يُسمح فقط بملفات الصور (JPEG, PNG, GIF)');
      return;
    }

    // التحقق من حجم الملف (5MB كحد أقصى)
    if (file.size > 5 * 1024 * 1024) {
      alert('حجم الملف كبير جداً (الحد الأقصى 5MB)');
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
      alert('فشل تحميل الصورة. الرجاء المحاولة مرة أخرى.');
    } finally {
      this.isLoading = false;
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

  async uploadImageToCloudinary(file: File): Promise<string> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('upload_preset', 'unsigned_preset'); // تأكدي من صحة هذا الـ preset
    
    const cloudName = 'dz2mzzcg4'; // تأكدي من صحة cloud name
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
