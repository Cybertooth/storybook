import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AppShell } from './components/layout/AppShell';
import { PlotGerminator } from './components/features/story-engine/PlotGerminator';
import { CharactersPage } from './components/pages/CharactersPage';
import { TimelinePage } from './components/pages/TimelinePage';
import { LocationsPage } from './components/pages/LocationsPage';
import { DraftPage } from './components/pages/DraftPage';
import { SettingsPage } from './components/pages/SettingsPage';
import { ToastContainer } from './components/ui/Toast';
import { ThemeProvider } from './components/ThemeProvider';

function App() {
    return (
        <ThemeProvider>
            <BrowserRouter>
                <ToastContainer />
                <Routes>
                    <Route path="/" element={<AppShell />}>
                        <Route index element={<PlotGerminator />} />
                        <Route path="characters" element={<CharactersPage />} />
                        <Route path="locations" element={<LocationsPage />} />
                        <Route path="timeline" element={<TimelinePage />} />
                        <Route path="write" element={<DraftPage />} />
                        <Route path="settings" element={<SettingsPage />} />
                        <Route path="*" element={<Navigate to="/" replace />} />
                    </Route>
                </Routes>
            </BrowserRouter>
        </ThemeProvider>
    )
}

export default App

