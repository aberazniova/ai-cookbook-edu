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
    <div className="flex-1 pb-[10rem] content-center">
      <Card className="px-6 py-4 shadow mx-auto max-w-sm my-10">
        <h1 className="text-2xl sm:text-3xl font-semibold mb-4">Sign Up</h1>
        <form onSubmit={onSubmit} className="space-y-4">
          <div>
            <Label htmlFor="email" className="text-base">Email</Label>
            <TextInput
              id="email"
              type="email"
              placeholder="you@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full text-base py-1"
            />
          </div>
          <div>
            <Label htmlFor="password" className="text-base">Password</Label>
            <TextInput
              id="password"
              type="password"
              placeholder="••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              className="w-full text-base py-1"
            />
          </div>
          <div>
            <Label htmlFor="password_confirmation" className="text-base">Confirm Password</Label>
            <TextInput
              id="password_confirmation"
              type="password"
              placeholder="••••••"
              value={passwordConfirmation}
              onChange={(e) => setPasswordConfirmation(e.target.value)}
              required
              className="w-full text-base py-1"
            />
          </div>
          <Button
            type="submit"
            className="w-full bg-sage-green hover:bg-sage-green-800 text-white text-base py-2"
          >
            Create account
          </Button>
        </form>
        <div className="mt-3 text-sm">
          <span>Already have an account? </span>
          <Link to="/sign-in" className="text-sage-green hover:underline">Sign in</Link>
        </div>
      </Card>
    </div>
  );
}
