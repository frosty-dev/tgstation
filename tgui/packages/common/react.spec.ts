/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { classes } from './react';

describe('classes', () => {
  test('empty', () => {
    expect(classes([])).toBe('');
  });

  test('result contains inputs', () => {
    const output = classes(['foo', 'bar', false, true, 0, 1, 'baz']);
    expect(output).toContain('foo');
    expect(output).toContain('bar');
    expect(output).toContain('baz');
  });
});

import { normalizeChildren } from './react';

describe('normalizeChildren', () => {
  test('normalizeChildren with array of values', () => {
    const children = [1, 2, [3, 4], 5, null, 6];
    const result = normalizeChildren<number | number[]>(children);
    expect(result).toEqual([1, 2, 3, 4, 5, 6]);
  });

  test('normalizeChildren with single value', () => {
    const children = { id: 1 };
    const result = normalizeChildren<{ id: number }>(children);
    expect(result).toEqual([{ id: 1 }]);
  });

  test('normalizeChildren with empty array', () => {
    const children = [];
    const result = normalizeChildren<number[]>(children);
    expect(result).toEqual([]);
  });

  test('normalizeChildren with non-array and non-object', () => {
    const children = 'string';
    const result = normalizeChildren<string>(children);
    expect(result).toEqual([]);
  });
});

import { shallowDiffers } from './react';

describe('shallowDiffers', () => {
  test('shallowDiffers with different objects', () => {
    const a = { id: 1, name: 'John' };
    const b = { id: 2, name: 'Jane' };
    expect(shallowDiffers(a, b)).toBe(true);
  });

  test('shallowDiffers with identical objects', () => {
    const a = { id: 1, name: 'John' };
    const b = { id: 1, name: 'John' };
    expect(shallowDiffers(a, b)).toBe(false);
  });

  test('shallowDiffers with extra property in second object', () => {
    const a = { id: 1 };
    const b = { id: 1, name: 'John' };
    expect(shallowDiffers(a, b)).toBe(true);
  });

  test('shallowDiffers with extra property in first object', () => {
    const a = { id: 1, name: 'John' };
    const b = { id: 1 };
    expect(shallowDiffers(a, b)).toBe(true);
  });
});

import { pureComponentHooks } from './react';

describe('pureComponentHooks', () => {
  test('onComponentShouldUpdate with different objects', () => {
    const lastProps = { id: 1, name: 'John' };
    const nextProps = { id: 2, name: 'Jane' };
    expect(
      pureComponentHooks.onComponentShouldUpdate(lastProps, nextProps)
    ).toBe(true);
  });

  test('onComponentShouldUpdate with identical objects', () => {
    const lastProps = { id: 1, name: 'John' };
    const nextProps = { id: 1, name: 'John' };
    expect(
      pureComponentHooks.onComponentShouldUpdate(lastProps, nextProps)
    ).toBe(false);
  });

  test('onComponentShouldUpdate with extra property in second object', () => {
    const lastProps = { id: 1 };
    const nextProps = { id: 1, name: 'John' };
    expect(
      pureComponentHooks.onComponentShouldUpdate(lastProps, nextProps)
    ).toBe(true);
  });

  test('onComponentShouldUpdate with extra property in first object', () => {
    const lastProps = { id: 1, name: 'John' };
    const nextProps = { id: 1 };
    expect(
      pureComponentHooks.onComponentShouldUpdate(lastProps, nextProps)
    ).toBe(true);
  });
});

import { canRender } from './react';

describe('canRender', () => {
  test('canRender with undefined', () => {
    expect(canRender(undefined)).toBe(false);
  });

  test('canRender with null', () => {
    expect(canRender(null)).toBe(false);
  });

  test('canRender with boolean', () => {
    expect(canRender(true)).toBe(false);
  });

  test('canRender with string', () => {
    expect(canRender('string')).toBe(true);
  });

  test('canRender with number', () => {
    expect(canRender(1)).toBe(true);
  });

  test('canRender with object', () => {
    expect(canRender({ id: 1 })).toBe(true);
  });
});
