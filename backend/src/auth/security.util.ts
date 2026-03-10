const TEST_FALLBACK_JWT_SECRET = 'test-only-insecure-jwt-secret-change-me';

export function getJwtSecret(): string {
  const secret = process.env.JWT_SECRET?.trim();
  const isTest = process.env.NODE_ENV === 'test';

  if (!secret) {
    if (isTest) {
      return TEST_FALLBACK_JWT_SECRET;
    }
    throw new Error('JWT_SECRET is required');
  }

  if (!isTest && secret.length < 32) {
    throw new Error('JWT_SECRET must be at least 32 characters');
  }

  return secret;
}

export function getCorsOrigins(): string[] {
  const raw = process.env.CORS_ORIGINS?.trim();
  const isProd = process.env.NODE_ENV === 'production';

  if (!raw) {
    if (isProd) {
      throw new Error('CORS_ORIGINS must be set in production');
    }
    return ['http://localhost:5173', 'http://127.0.0.1:5173'];
  }

  return raw
    .split(',')
    .map((origin) => origin.trim())
    .filter((origin) => origin.length > 0 && origin !== '*');
}
