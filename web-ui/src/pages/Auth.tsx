import React, { useState } from 'react';
import { useAuthStore } from '../store/useAuthStore';
import { apiClient } from '../lib/apiClient';
import { useNavigate } from 'react-router-dom';

export default function Auth() {
    const [isLogin, setIsLogin] = useState(true);
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const login = useAuthStore((state) => state.login);
    const navigate = useNavigate();

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError('');
        setLoading(true);

        try {
            const endpoint = isLogin ? '/auth/login' : '/auth/register';
            const { data } = await apiClient.post(endpoint, { email, password });

            const { token, user } = data.data;
            login(token, user);
            navigate('/');
        } catch (err: any) {
            setError(err.response?.data?.message || 'Authentication failed');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-neutral-950 flex items-center justify-center p-4">
            <div className="max-w-md w-full bg-neutral-900 border border-neutral-800 rounded-xl p-8 shadow-2xl">
                <h2 className="text-3xl font-bold text-white mb-6 text-center">
                    {isLogin ? 'Welcome Back' : 'Create Account'}
                </h2>

                {error && (
                    <div className="bg-red-500/10 border border-red-500/50 text-red-400 p-3 rounded-lg mb-6 text-sm text-center">
                        {error}
                    </div>
                )}

                <form onSubmit={handleSubmit} className="space-y-4">
                    <div>
                        <label className="block text-sm font-medium text-neutral-400 mb-1">Email</label>
                        <input
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            className="w-full bg-neutral-950 border border-neutral-800 rounded-lg px-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500"
                            required
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-neutral-400 mb-1">Password</label>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            className="w-full bg-neutral-950 border border-neutral-800 rounded-lg px-4 py-2 text-white focus:outline-none focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500"
                            required
                        />
                    </div>
                    <button
                        type="submit"
                        disabled={loading}
                        className="w-full bg-amber-600 hover:bg-amber-500 text-white font-medium py-2 px-4 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        {loading ? 'Processing...' : isLogin ? 'Sign In' : 'Sign Up'}
                    </button>
                </form>

                <p className="mt-6 text-center text-sm text-neutral-400">
                    {isLogin ? "Don't have an account? " : "Already have an account? "}
                    <button
                        onClick={() => setIsLogin(!isLogin)}
                        className="text-amber-500 hover:text-amber-400 font-medium transition-colors"
                    >
                        {isLogin ? 'Create one' : 'Sign in'}
                    </button>
                </p>
            </div>
        </div>
    );
}
