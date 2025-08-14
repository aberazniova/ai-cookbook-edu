export type AuthUser = {
  id: number;
  email: string;
};

export type AuthResponse = {
  user: AuthUser;
};
