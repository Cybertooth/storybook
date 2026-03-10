import axios, { InternalAxiosRequestConfig } from 'axios';
import { useAuthStore } from '../store/useAuthStore';

export const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api/v1',
    headers: {
        'Content-Type': 'application/json',
    },
});

apiClient.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    const token = useAuthStore.getState().token;
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

// When the server returns 401 (token expired or invalid), clear local auth
// state and redirect to the login page so the user can re-authenticate.
apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            useAuthStore.getState().logout();
            window.location.href = '/auth';
        }
        return Promise.reject(error);
    }
);
