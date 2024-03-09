import {
  getGasColor,
  getGasFromId,
  getGasFromPath,
  getGasLabel,
} from './constants';

describe('gas helper functions', () => {
  it('should get the proper gas label', () => {
    const gasId = 'antinoblium';
    const gasLabel = getGasLabel(gasId);
    expect(gasLabel).toBe('Anti-Noblium');
  });

  it('should get the proper gas label with a fallback', () => {
    const gasId = 'nonexistent';
    const gasLabel = getGasLabel(gasId, 'fallback');

    expect(gasLabel).toBe('fallback');
  });

  it('should return none if no gas and no fallback is found', () => {
    const gasId = 'nonexistent';
    const gasLabel = getGasLabel(gasId);

    expect(gasLabel).toBe('None');
  });

  it('should get the proper gas color', () => {
    const gasId = 'antinoblium';
    const gasColor = getGasColor(gasId);

    expect(gasColor).toBe('maroon');
  });

  it('should return fallbackValue, if no gas is found', () => {
    const gasId = null;
    const gasColor = getGasColor(gasId, 'fallback');

    expect(gasColor).toBe('black');
  });

  it('2 should return fallbackValue, if no gas is found', () => {
    const gasId = '';
    const gasColor = getGasColor(gasId);

    expect(gasColor).toBe('black');
  });

  it('should return a string if no gas is found', () => {
    const gasId = 'nonexistent';
    const gasColor = getGasColor(gasId);

    expect(gasColor).toBe('black');
  });

  it('should return the gas object if found', () => {
    const gasId = 'antinoblium';
    const gas = getGasFromId(gasId);

    expect(gas).toEqual({
      id: 'antinoblium',
      path: '/datum/gas/antinoblium',
      name: 'Antinoblium',
      label: 'Anti-Noblium',
      color: 'maroon',
    });
  });

  it('should return undefined if no gas is found', () => {
    const gasId = 'nonexistent';
    const gas = getGasFromId(gasId);

    expect(gas).toBeUndefined();
  });

  it('should return the gas using a path', () => {
    const gasPath = '/datum/gas/antinoblium';
    const gas = getGasFromPath(gasPath);

    expect(gas).toEqual({
      id: 'antinoblium',
      path: '/datum/gas/antinoblium',
      name: 'Antinoblium',
      label: 'Anti-Noblium',
      color: 'maroon',
    });
  });
});

describe('getGasLabel', () => {
  const GASES = [
    { id: 'o2', label: 'Oxygen' },
    { id: 'n2', label: 'Nitrogen' },
  ];

  test('getGasLabel returns the label for a known gas', () => {
    const gasId = 'o2';
    const label = getGasLabel(gasId);
    expect(label).toBe('O₂');
  });

  test('getGasLabel returns the fallback value for an unknown gas', () => {
    const gasId = 'unknown';
    const fallback = 'Unknown gas';
    const label = getGasLabel(gasId, fallback);
    expect(label).toBe(fallback);
  });

  test('getGasLabel returns "None" for an unknown gas without a fallback value', () => {
    const gasId = 'unknown';
    const label = getGasLabel(gasId);
    expect(label).toBe('None');
  });

  test('getGasLabel returns the fallback value when gasId is not provided', () => {
    const fallback = 'No gas provided';
    const label = getGasLabel(undefined, fallback);
    expect(label).toBe(fallback);
  });

  test('getGasLabel returns "None" when gasId is not provided and no fallback value is given', () => {
    const label = getGasLabel();
    expect(label).toBe('None');
  });
});

describe('getGasFromId', () => {
  const GASES = [
    { id: 'o2', label: 'Oxygen' },
    { id: 'n2', label: 'Nitrogen' },
  ];

  test('getGasFromId returns the gas for a known gas id', () => {
    const gasId = 'o2';
    const gas = getGasFromId(gasId);
    expect(gas).toEqual({
      label: 'O₂',
      name: 'Oxygen',
      path: '/datum/gas/oxygen',
      color: 'blue',
      id: 'o2',
    });
  });

  test('getGasFromId returns undefined for an unknown gas id', () => {
    const gasId = 'unknown';
    const gas = getGasFromId(gasId);
    expect(gas).toBeUndefined();
  });

  test('getGasFromId returns undefined when gasId is not provided', () => {
    const gas = getGasFromId();
    expect(gas).toBeUndefined();
  });
});

describe('getGasFromPath', () => {
  test('getGasFromPath returns the gas for a known gas path', () => {
    const gasPath = '/datum/gas/oxygen';
    const gas = getGasFromPath(gasPath);
    expect(gas).toEqual({
      label: 'O₂',
      name: 'Oxygen',
      path: '/datum/gas/oxygen',
      color: 'blue',
      id: 'o2',
    });
  });

  test('getGasFromPath returns undefined when gasPath is not provided', () => {
    const gas = getGasFromPath();
    expect(gas).toBeUndefined();
  });
});
