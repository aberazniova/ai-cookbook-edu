import { create } from 'zustand';
import { combine } from 'zustand/middleware';
import type { AuthUser } from 'types/auth';

export type AuthState = {
  user: AuthUser | null;
  token: string | null;
};

type Actions = {
  setAuth: (user: AuthUser, token: string) => void;
  clearAuth: () => void;
};

export const useAuthStore = create(
  combine<AuthState, Actions>({ user: null, token: null }, (set) => ({
    setAuth: (user, token) => set(() => ({ user, token })),
    clearAuth: () => set(() => ({ user: null, token: null })),
  }))
);
