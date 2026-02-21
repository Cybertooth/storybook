import { BrowserRouter, Routes, Route, Navigate, Outlet } from 'react-router-dom';
import { AppShell } from './components/layout/AppShell';
import { PlotGerminator } from './components/features/story-engine/PlotGerminator';
import { CharactersPage } from './components/pages/CharactersPage';
import { TimelinePage } from './components/pages/TimelinePage';
import { LocationsPage } from './components/pages/LocationsPage';
import { DraftPage } from './components/pages/DraftPage';
import { ScratchpadPage } from './components/pages/ScratchpadPage';
import { SettingsPage } from './components/pages/SettingsPage';
import { StoryDashboard } from './components/pages/StoryDashboard';
import { ToastContainer } from './components/ui/Toast';
import { ThemeProvider } from './components/ThemeProvider';
import AuthPage from './pages/Auth';
import { useAuthStore } from './store/useAuthStore';

function ProtectedRoute() {
    const token = useAuthStore(state => state.token);
    if (!token) {
        return <Navigate to="/auth" replace />;
    }
    return <Outlet />;
}

function App() {
    return (
        <ThemeProvider>
            <BrowserRouter>
                <ToastContainer />
                <Routes>
                    <Route path="/auth" element={<AuthPage />} />

                    <Route element={<ProtectedRoute />}>
                        <Route path="/" element={<AppShell />}>
                            <Route index element={<PlotGerminator />} />
                            <Route path="characters" element={<CharactersPage />} />
                            <Route path="locations" element={<LocationsPage />} />
                            <Route path="timeline" element={<TimelinePage />} />
                            <Route path="scratchpad" element={<ScratchpadPage />} />
                            <Route path="write" element={<DraftPage />} />
                            <Route path="settings" element={<SettingsPage />} />
                            <Route path="dashboard" element={<StoryDashboard />} />
                            <Route path="*" element={<Navigate to="/" replace />} />
                        </Route>
                    </Route>
                </Routes>
            </BrowserRouter>
        </ThemeProvider>
    )
}

export default App

