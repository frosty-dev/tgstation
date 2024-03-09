import {
  range,
  zip,
  filter,
  map,
  filterMap,
  COMPARATOR,
  sortBy,
} from './collections';

// Type assertions, these will lint if the types are wrong.
const _zip1: [string, number] = zip(['a'], [1])[0];

describe('range', () => {
  test('range(0, 5)', () => {
    expect(range(0, 5)).toEqual([0, 1, 2, 3, 4]);
  });
});

describe('zip', () => {
  test("zip(['a', 'b', 'c'], [1, 2, 3, 4])", () => {
    expect(zip(['a', 'b', 'c'], [1, 2, 3, 4])).toEqual([
      ['a', 1],
      ['b', 2],
      ['c', 3],
    ]);
  });
  test('zip on empty arrays', () => {
    expect(zip()).toEqual([]);
  });
});

describe('filter', () => {
  test('filter([1, 2, 3, 4, 5], (item) => item > 2)', () => {
    const result = filter<number>((item) => item > 2)([1, 2, 3, 4, 5]);
    expect(result).toEqual([3, 4, 5]);
  });

  test('filter on empty array', () => {
    const result = filter<number>((item) => item > 2)([]);
    expect(result).toEqual([]);
  });

  test('filter on null', () => {
    const result = filter<number>((item) => item > 2)(null);
    expect(result).toBe(null);
  });

  test('filter on undefined', () => {
    const result = filter<number>((item) => item > 2)(undefined);
    expect(result).toBe(undefined);
  });

  test('filter on non-array', () => {
    expect(() => {
      filter<number>((item) => item > 2)({} as any);
    }).toThrowError(`filter() can't iterate on type object`);
  });
});

describe('map', () => {
  test('map([1, 2, 3], (item) => item * 2)', () => {
    const result = map<number, number>((item) => item * 2)([1, 2, 3]);
    expect(result).toEqual([2, 4, 6]);
  });

  test('map on empty array', () => {
    const result = map<number, number>((item) => item * 2)([]);
    expect(result).toEqual([]);
  });

  test('map on null', () => {
    const result = map<number, number>((item) => item * 2)(null);
    expect(result).toBe(null);
  });

  test('map on undefined', () => {
    const result = map<number, number>((item) => item * 2)(undefined);
    expect(result).toBe(undefined);
  });

  test('map on object', () => {
    const result = map<number, number>((value, key) => value * 2)({
      a: 1,
      b: 2,
    });
    expect(result).toEqual([2, 4]);
  });

  test('map on non-array and non-object', () => {
    expect(() => {
      map<number, number>((item) => item * 2)('string' as any);
    }).toThrowError(`map() can't iterate on type string`);
  });
});

describe('filterMap', () => {
  test('filterMap([1, 2, 3, 4, 5], (item) => item > 2 ? item : undefined)', () => {
    const result = filterMap<number, number | undefined>(
      [1, 2, 3, 4, 5],
      (item) => (item > 2 ? item : undefined)
    );
    expect(result).toEqual([3, 4, 5]);
  });

  test('filterMap on empty array', () => {
    const result = filterMap<number, number | undefined>([], (item) =>
      item > 2 ? item : undefined
    );
    expect(result).toEqual([]);
  });

  test('filterMap with all undefined results', () => {
    const result = filterMap<number, number | undefined>(
      [1, 2, 3, 4, 5],
      (item) => (item > 5 ? item : undefined)
    );
    expect(result).toEqual([]);
  });
});

describe('COMPARATOR', () => {
  test('COMPARATOR with equal criteria', () => {
    const objA = { criteria: [1, 2, 3] };
    const objB = { criteria: [1, 2, 3] };
    expect(COMPARATOR(objA, objB)).toEqual(0);
  });

  test('COMPARATOR with objA < objB', () => {
    const objA = { criteria: [1, 2, 3] };
    const objB = { criteria: [1, 2, 4] };
    expect(COMPARATOR(objA, objB)).toEqual(-1);
  });

  test('COMPARATOR with objA > objB', () => {
    const objA = { criteria: [1, 2, 4] };
    const objB = { criteria: [1, 2, 3] };
    expect(COMPARATOR(objA, objB)).toEqual(1);
  });
});

describe('sortBy', () => {
  test('sortBy with one iteratee function', () => {
    const array = [{ age: 30 }, { age: 20 }, { age: 50 }, { age: 40 }];
    const result = sortBy<{ age: number }>((obj) => obj.age)(array);
    expect(result).toEqual([
      { age: 20 },
      { age: 30 },
      { age: 40 },
      { age: 50 },
    ]);
  });

  test('sortBy with multiple iteratee functions', () => {
    const array = [
      { age: 30, name: 'John' },
      { age: 20, name: 'Jane' },
      { age: 20, name: 'Alice' },
      { age: 30, name: 'Bob' },
    ];
    const result = sortBy<{ age: number; name: string }>(
      (obj) => obj.age,
      (obj) => obj.name
    )(array);
    expect(result).toEqual([
      { age: 20, name: 'Alice' },
      { age: 20, name: 'Jane' },
      { age: 30, name: 'Bob' },
      { age: 30, name: 'John' },
    ]);
  });

  test('sortBy on non-array', () => {
    const result = sortBy<number>((num) => num)({} as any);
    expect(result).toEqual({});
  });
});

import { reduce } from './collections';

describe('reduce', () => {
  test('reduce with sum reducer and initial value', () => {
    const array = [1, 2, 3, 4, 5];
    const result = reduce((acc, value) => acc + value, 0)(array);
    expect(result).toEqual(15);
  });

  test('reduce with sum reducer without initial value', () => {
    const array = [1, 2, 3, 4, 5];
    const result = reduce((acc, value) => acc + value)(array);
    expect(result).toEqual(15);
  });

  test('reduce with empty array and initial value', () => {
    const array = [];
    const result = reduce((acc, value) => acc + value, 0)(array);
    expect(result).toEqual(0);
  });

  test('reduce with empty array without initial value', () => {
    const array = [];
    const result = reduce((acc, value) => acc + value)(array);
    expect(result).toBeUndefined();
  });
});

import { uniqBy } from './collections';

describe('uniqBy', () => {
  test('uniqBy with iteratee function', () => {
    const array = [{ id: 1 }, { id: 2 }, { id: 1 }, { id: 3 }, { id: 2 }];
    const result = uniqBy<{ id: number }>((obj) => obj.id)(array);
    expect(result).toEqual([{ id: 1 }, { id: 2 }, { id: 3 }]);
  });

  test('uniqBy without iteratee function', () => {
    const array = [1, 2, 1, 3, 2];
    const result = uniqBy<number>()(array);
    expect(result).toEqual([1, 2, 3]);
  });

  test('uniqBy with empty array', () => {
    const array = [];
    const result = uniqBy<number>()(array);
    expect(result).toEqual([]);
  });

  test('uniqBy with NaN values', () => {
    const array = [NaN, NaN, 1, 2, 1, 3, 2];
    const result = uniqBy<number>()(array);
    expect(result).toEqual([NaN, 1, 2, 3]);
  });
  test('uniqBy with NaN values and iteratee function', () => {
    const array = [NaN, NaN, 1, 2, 1, 3, 2];
    const result = uniqBy<number>((value) => value)(array);
    expect(result).toEqual([NaN, 1, 2, 3]);
  });
});

import { zipWith } from './collections';

describe('zipWith', () => {
  test('zipWith with sum function', () => {
    const arrays = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ];
    const result = zipWith<number, number>((...values) =>
      values.reduce((a, b) => a + b, 0)
    )(...arrays);
    expect(result).toEqual([12, 15, 18]);
  });

  test('zipWith with empty arrays', () => {
    const arrays = [[], [], []];
    const result = zipWith<number, number>((...values) =>
      values.reduce((a, b) => a + b, 0)
    )(...arrays);
    expect(result).toEqual([]);
  });

  test('zipWith with arrays of different lengths', () => {
    const arrays = [[1, 2, 3], [4, 5], [7]];
    const result = zipWith<number, number>((...values) =>
      values.reduce((a, b) => a + b, 0)
    )(...arrays);
    expect(result).toEqual([12, NaN, NaN]);
  });
});

import { binarySearch } from './collections';

describe('binarySearch', () => {
  test('binarySearch with empty collection', () => {
    const getKey = (value: number) => value;
    const collection: number[] = [];
    const inserting = 1;
    const result = binarySearch(getKey, collection, inserting);
    expect(result).toEqual(0);
  });

  test('binarySearch with collection containing the inserting value', () => {
    const getKey = (value: number) => value;
    const collection: number[] = [1, 2, 3, 4, 5];
    const inserting = 3;
    const result = binarySearch(getKey, collection, inserting);
    expect(result).toEqual(2);
  });

  test('binarySearch with collection not containing the inserting value', () => {
    const getKey = (value: number) => value;
    const collection: number[] = [1, 2, 4, 5];
    const inserting = 3;
    const result = binarySearch(getKey, collection, inserting);
    expect(result).toEqual(2);
  });

  test('binarySearch with inserting value in the middle of two collection values', () => {
    const getKey = (value: number) => value;
    const collection: number[] = [3, 2];
    const inserting = 0;
    const result = binarySearch(getKey, collection, inserting);
    expect(result).toEqual(0);
  });
});

import { binaryInsertWith } from './collections';

describe('binaryInsertWith', () => {
  test('binaryInsertWith with empty collection', () => {
    const getKey = (value: number) => value;
    const collection: number[] = [];
    const value = 1;
    const result = binaryInsertWith(getKey)(collection, value);
    expect(result).toEqual([1]);
  });

  test('binaryInsertWith with collection containing the inserting value', () => {
    const getKey = (value: number) => value;
    const collection: number[] = [1, 2, 3, 4, 5];
    const value = 3;
    const result = binaryInsertWith(getKey)(collection, value);
    expect(result).toEqual([1, 2, 3, 3, 4, 5]);
  });

  test('binaryInsertWith with collection not containing the inserting value', () => {
    const getKey = (value: number) => value;
    const collection: number[] = [1, 2, 4, 5];
    const value = 3;
    const result = binaryInsertWith(getKey)(collection, value);
    expect(result).toEqual([1, 2, 3, 4, 5]);
  });
});

import { paginate } from './collections';

describe('paginate', () => {
  test('paginate with collection and maxPerPage', () => {
    const collection = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    const maxPerPage = 3;
    const result = paginate(collection, maxPerPage);
    expect(result).toEqual([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]);
  });

  test('paginate with empty collection', () => {
    const collection: number[] = [];
    const maxPerPage = 3;
    const result = paginate(collection, maxPerPage);
    expect(result).toEqual([]);
  });

  test('paginate with maxPerPage greater than collection length', () => {
    const collection = [1, 2, 3];
    const maxPerPage = 5;
    const result = paginate(collection, maxPerPage);
    expect(result).toEqual([[1, 2, 3]]);
  });
});

import { deepMerge } from './collections';

describe('deepMerge', () => {
  test('deepMerge with multiple objects', () => {
    const object1 = { a: 1, b: [1, 2], c: { d: 1 } };
    const object2 = { a: 2, b: [3, 4], c: { e: 2 } };
    const object3 = { a: 3, b: [5, 6], c: { f: 3 } };
    const result = deepMerge(object1, object2, object3);
    expect(result).toEqual({
      a: 3,
      b: [1, 2, 3, 4, 5, 6],
      c: { d: 1, e: 2, f: 3 },
    });
  });

  test('deepMerge with empty objects', () => {
    const object1 = {};
    const object2 = {};
    const result = deepMerge(object1, object2);
    expect(result).toEqual({});
  });

  test('deepMerge with non-overlapping objects', () => {
    const object1 = { a: 1 };
    const object2 = { b: 2 };
    const result = deepMerge(object1, object2);
    expect(result).toEqual({ a: 1, b: 2 });
  });
});
