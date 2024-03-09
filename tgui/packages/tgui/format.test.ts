import {
  formatDb,
  formatMoney,
  formatSiBaseTenUnit,
  formatSiUnit,
  formatTime,
} from './format';

describe('formatMoney', () => {
  it('formats integer values with default precision', () => {
    const value = 1234567;
    const result = formatMoney(value);
    expect(result).toBe('1\u2009234\u2009567');
  });

  it('formats float values with specified precision', () => {
    const value = 1234567.89;
    const result = formatMoney(value, 2);
    expect(result).toBe('1\u2009234\u2009567.89');
  });

  it('formats negative values correctly', () => {
    const value = -1234567.89;
    const result = formatMoney(value, 2);
    expect(result).toBe('-1\u2009234\u2009567.89');
  });

  it('returns non-finite values as is', () => {
    const value = Infinity;
    const result = formatMoney(value);
    expect(result).toBe('Infinity');
  });

  it('formats zero correctly', () => {
    const value = 0;
    const result = formatMoney(value);
    expect(result).toBe('0');
  });
});

describe('formatDb', () => {
  it('formats positive values correctly', () => {
    const value = 1;
    const result = formatDb(value);
    expect(result).toBe('+0.00 dB');
  });

  it('formats negative values correctly', () => {
    const value = 0.5;
    const result = formatDb(value);
    expect(result).toBe('-6.02 dB');
  });

  it('formats Infinity correctly', () => {
    const value = 0;
    const result = formatDb(value);
    expect(result).toBe('-Inf dB');
  });

  it('formats very large values correctly', () => {
    const value = 1e6;
    const result = formatDb(value);
    expect(result).toBe('+120.00 dB');
  });

  it('formats very small values correctly', () => {
    const value = 1e-6;
    const result = formatDb(value);
    expect(result).toBe('-120.00 dB');
  });
});

describe('formatSiBaseTenUnit', () => {
  it('formats SI base 10 units', () => {
    expect(formatSiBaseTenUnit(1e9)).toBe('1.00 · 10⁹');
    expect(formatSiBaseTenUnit(1234567890, 0, 'm')).toBe('1.23 · 10⁹ m');
  });

  it('NAN', () => {
    expect(formatSiBaseTenUnit(Infinity)).toBe('NaN');
  });
});

describe('formatTime', () => {
  it('formats time values', () => {
    expect(formatTime(36000)).toBe('01:00:00');
    expect(formatTime(36610)).toBe('01:01:01');
    expect(formatTime(36610, 'short')).toBe('1h1m1s');
  });

  it('formats time values with zero hours correctly', () => {
    expect(formatTime(61, 'short')).toBe('6s');
  });

  it('formats time values with zero minutes correctly', () => {
    expect(formatTime(3601, 'short')).toBe('6m');
  });

  it('formats time values with zero seconds correctly', () => {
    expect(formatTime(3660, 'short')).toBe('6m6s');
  });
});

describe('formatSiUnit', () => {
  const SI_BASE_INDEX = 5;
  const SI_SYMBOLS = [
    'f',
    'p',
    'n',
    'μ',
    'm',
    '',
    'k',
    'M',
    'G',
    'T',
    'P',
    'E',
    'Z',
    'Y',
  ];

  it('formats base values correctly', () => {
    const value = 100;
    const result = formatSiUnit(value, -SI_BASE_INDEX, 'Hz');
    expect(result).toBe('100 Hz');
  });

  it('formats kilo values correctly', () => {
    const value = 1500;
    const result = formatSiUnit(value, -SI_BASE_INDEX, 'Hz');
    expect(result).toBe('1.50 kHz');
  });

  it('formats micro values correctly', () => {
    const value = 0.0001;
    const result = formatSiUnit(value, -SI_BASE_INDEX, 'Hz');
    expect(result).toBe('100 μHz');
  });

  it('handles non-finite values correctly', () => {
    const value = Infinity;
    const result = formatSiUnit(value, -SI_BASE_INDEX, 'Hz');
    expect(result).toBe('Infinity');
  });

  it('removes trailing zeroes after the decimal point', () => {
    const value = 1500.0;
    const result = formatSiUnit(value, -SI_BASE_INDEX, 'Hz');
    expect(result).toBe('1.50 kHz');
  });

  it('removes trailing zero after the decimal point', () => {
    const originalToFixed = Number.prototype.toFixed;
    Number.prototype.toFixed = function () {
      return '1.50.0';
    };
    const value = 1500.5;
    const result = formatSiUnit(value, -SI_BASE_INDEX, 'Hz');
    expect(result).toBe('1.50 kHz');
    Number.prototype.toFixed = originalToFixed;
  });
  it('uses default minBase1000 when not provided', () => {
    const value = 100;
    const result = formatSiUnit(value);
    expect(result).toBe('100');
  });

  it('uses default unit when not provided', () => {
    const value = 1500;
    const result = formatSiUnit(value);
    expect(result).toBe('1.50 k');
  });
});

import { formatPower } from './format';

describe('formatPower', () => {
  it('formats power values correctly', () => {
    const value = 1e6;
    const result = formatPower(value);
    expect(result).toBe('1 MW');
  });
});
