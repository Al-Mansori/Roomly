// src/utils/jwt-utils.ts
export interface JwtPayload {
  sub?: string; // Subject (user ID)
  staffId?: string; // Custom staff ID
  exp?: number; // Expiration time
  // Add other expected claims as needed
}

export function decodeToken(token: string): JwtPayload | null {
  if (!token) return null;
  try {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split('')
        .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    );
    return JSON.parse(jsonPayload);
  } catch (e) {
    console.error('Error decoding token:', e);
    return null;
  }
}