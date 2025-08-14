import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { signUp } from 'utils/auth';
import { Button, TextInput, Label, Card } from 'flowbite-react';
import { useAlertStore } from 'stores/alertStore';

export default function SignUp() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const navigate = useNavigate();
  const addAlert = useAlertStore((s) => s.addAlert);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await signUp(
        email,
        password,
        passwordConfirmation,
      );
    } catch (error) {
      addAlert({
        type: 'failure',
        message: error?.message || 'Unable to sign up',
      });
      return;
    }
    navigate('/');
  };

  return (
    <div className="max-w-md mx-auto py-12">
      <Card>
        <h1 className="text-2xl font-semibold mb-4">Sign Up</h1>
        <form onSubmit={onSubmit} className="space-y-4">
          <div>
            <Label htmlFor="email">Email</Label>
            <TextInput
              id="email"
              type="email"
              placeholder="you@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div>
            <Label htmlFor="password">Password</Label>
            <TextInput
              id="password"
              type="password"
              placeholder="••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          <div>
            <Label htmlFor="password_confirmation">Confirm Password</Label>
            <TextInput
              id="password_confirmation"
              type="password"
              placeholder="••••••"
              value={passwordConfirmation}
              onChange={(e) => setPasswordConfirmation(e.target.value)}
              required
            />
          </div>
          <Button
            type="submit"
            className="w-full bg-emerald-600 hover:bg-emerald-700 text-white"
          >
            Create account
          </Button>
        </form>
        <div className="mt-2 text-sm">
          <span>Already have an account? </span>
          <Link to="/sign-in" className="text-emerald-700 hover:underline">Sign in</Link>
        </div>
      </Card>
    </div>
  );
}
